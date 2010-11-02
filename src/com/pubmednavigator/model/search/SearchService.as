package com.pubmednavigator.model.search {
	
import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
import be.boulevart.google.ajaxapi.search.web.GoogleWebSearch;
import be.boulevart.google.ajaxapi.search.web.data.GoogleWebItem;
import be.boulevart.google.events.GoogleAPIErrorEvent;
import be.boulevart.google.events.GoogleApiEvent;

import com.pubmednavigator.model.events.SearchEvent;
import com.pubmednavigator.model.pubmed.Pubmed;
import com.thinkloop.flex4components.CachingArrayCollection;
import com.thinkloop.flex4components.StringUtil;

import flash.events.IEventDispatcher;

public class SearchService {
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTANTS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * DEPENDENCIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	[Inject] public var googleWebSearch:GoogleWebSearch;
	[Dispatcher] public var dispatcher:IEventDispatcher;

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	public function SearchService() {
	}
	
	
	[PostConstruct]
	public function pc():void {
		init();
	}
	
	public function init():void {
		pubmedItems = new CachingArrayCollection();
		//pubmedItems.disableAutoUpdate();
		
		pendingSearchText = '';
		currentSearchText = '';
		currentPageIndex = 0;
		
		isSearching = false;
		
		googleWebSearch.addEventListener(GoogleApiEvent.WEB_SEARCH_RESULT, handle_WebSearch) ;
		googleWebSearch.addEventListener(GoogleAPIErrorEvent.API_ERROR, handle_WebSearch_Error);
	}

	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PROPERTIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
	
	[Bindable] public var pubmedItems:CachingArrayCollection;
	
	[Bindable] public var pendingSearchText:String;
	[Bindable] public var currentSearchText:String;
	[Bindable] public var currentPageIndex:int;
	
	[Bindable] public var lastPageIndex:int;
	
	private var _isSearching:Boolean;
	[Bindable]
	public function set isSearching(value:Boolean):void {
		_isSearching = value;
		
		if (value) {
			dispatcher.dispatchEvent(new SearchEvent(SearchEvent.SEARCH_STARTED, currentSearchText, currentPageIndex));
		}
		else {
trace('SEARCH_COMPLETE');			
			dispatcher.dispatchEvent(new SearchEvent(SearchEvent.SEARCH_COMPLETE, currentSearchText, currentPageIndex));
		}
	}
	public function get isSearching():Boolean {
		return _isSearching;
	}

	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
	
	// search
	public function search(searchText:String):void {
//trace('pendingSearchText: ' + pendingSearchText);		
		pendingSearchText = searchText;
		
		// don't search if bad search text
		if (isSearching || searchText.length <= 0 || pendingSearchText == currentSearchText) {
//trace('** skip search');			
			return;
		}
		
		// setup params for search
		currentSearchText = pendingSearchText;
		currentPageIndex = 0;
		
		isSearching = true;
		
		// search google
		//trace('** search: ' + searchBoxText + ' - ' + currentPageIndex);
		googleWebSearch.search(generateSearchPhrase(currentSearchText), generateItemIndexFromPageIndex(currentPageIndex), 'en');
		
		
//trace('search: ' + currentSearchText, currentPageIndex);
		
	}
	
	// paginate
	protected function paginate():void {
		
		currentPageIndex++;
		
		googleWebSearch.search(generateSearchPhrase(currentSearchText), generateItemIndexFromPageIndex(currentPageIndex), 'en');
		
		isSearching = true;
//trace('paging: ' + currentSearchText, currentPageIndex);	
		dispatcher.dispatchEvent(new SearchEvent(SearchEvent.SEARCH_STARTED, currentSearchText, currentPageIndex));
	}	
	
	// process web search
	protected function processSearch(googleSearchResult:GoogleSearchResult):void {
		
		isSearching = false;
		
		var i:int = 0;
		
		if (currentPageIndex <= 0) {
			pubmedItems.removeAll();
		}
trace('processSearch: ' + currentSearchText + ' - ' + currentPageIndex + ' - ' + googleSearchResult.results.length)		
		while (i < googleSearchResult.results.length && pubmedItems.length < 50) {
			
			var googleWebItem:GoogleWebItem = googleSearchResult.results[i];
			var getLastItemForID:Array = googleWebItem.unescapedUrl.split('/');
			var id:int = int(getLastItemForID[getLastItemForID.length - 1]);
			var keywords:Array = [];
			var keywordsIndex:int = 0;
			var tmpSplit:Array = currentSearchText.split(' ');

			for each (var s:String in tmpSplit) {
				if (s.length >= 3) {
					keywords.push(s.toLowerCase());
				}
			}

			if (id > 10000) {
				var pubmed:Pubmed = new Pubmed();
				pubmed.id = id;
				pubmed.articleTitle = StringUtil.cleanExtraWhiteSpace(googleWebItem.titleNoFormatting);
				pubmed.description = StringUtil.cleanExtraWhiteSpace(StringUtil.StripHtmlTags(googleWebItem.content));
				pubmed.url = StringUtil.cleanExtraWhiteSpace(googleWebItem.unescapedUrl);

				var webItemTitle:String = googleWebItem.title.toLowerCase();
				while ((keywordsIndex = webItemTitle.indexOf('<b>', keywordsIndex)) > -1) {
					keywordsIndex += 3;
					var keyword:String = StringUtil.trim(webItemTitle.substring(keywordsIndex, webItemTitle.indexOf('</b>', keywordsIndex)).toLocaleLowerCase());
					if (keyword.length >= 3 && keyword != '...') {
						keywords.push(keyword);
					}
				}

				pubmed.keywords = keywords;
				pubmed.isFullyPopulated = false;
				
				pubmedItems.addItem(pubmed);
			}
			
			i++;
			//pubmedItems.refresh();
		}
	
		if (currentSearchText != pendingSearchText) {
			search(pendingSearchText);
		}
		else if (googleSearchResult.currentPageIndex < Math.min(6, googleSearchResult.numPages - 1)) {
			paginate();
		}
	}
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * HANDLERS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// handle web search
	protected function handle_WebSearch(e:GoogleApiEvent):void {
		processSearch(e.data as GoogleSearchResult);
	}
	
	// handle web search error
	protected function handle_WebSearch_Error(evt:GoogleAPIErrorEvent):void {
		isSearching = false;
trace("An API error has occured: " + evt.responseDetails, "responseStatus was: " + evt.responseStatus);		
	}
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * BABY METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
	
	// generate search phrase
	public function generateSearchPhrase(searchTerms:String):String {
		return searchTerms + ' site:http://www.ncbi.nlm.nih.gov/pubmed';
	}
	
	// generate item index from page index
	public function generateItemIndexFromPageIndex(pageIndex:int):int {
		return pageIndex * 8;
	}
}}