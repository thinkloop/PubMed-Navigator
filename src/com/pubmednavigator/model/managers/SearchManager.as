package com.pubmednavigator.model.managers {
	
import be.boulevart.google.ajaxapi.search.GoogleSearchResult;
import be.boulevart.google.ajaxapi.search.web.GoogleWebSearch;
import be.boulevart.google.ajaxapi.search.web.data.GoogleWebItem;
import be.boulevart.google.events.GoogleAPIErrorEvent;
import be.boulevart.google.events.GoogleApiEvent;

import com.pubmednavigator.events.SearchEvent;
import com.pubmednavigator.model.objects.Pubmed;
import com.thinkloop.flex4.collections.CachingArrayCollection;
import com.thinkloop.flex4.utils.StringUtil;

import flash.events.IEventDispatcher;

public class SearchManager {
	
//--------------------------------------------------------------------------
//
// CONSTANTS
//
//--------------------------------------------------------------------------

//--------------------------------------------------------------------------
//
// DEPENDENCIES
//
//--------------------------------------------------------------------------

	[Inject] public var googleWebSearch:GoogleWebSearch;
	[Dispatcher] public var dispatcher:IEventDispatcher;

//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------
	
	public function SearchManager() {
	}
	
	
	[PostConstruct]
	public function pc():void {
		init();
	}
	
	public function init():void {		
		googleWebSearch.addEventListener(GoogleApiEvent.WEB_SEARCH_RESULT, handle_WebSearch) ;
		googleWebSearch.addEventListener(GoogleAPIErrorEvent.API_ERROR, handle_WebSearch_Error);
	}

	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------	
	
	[Bindable] public var pubmedItems:CachingArrayCollection = new CachingArrayCollection();
	
	[Bindable] public var pageIndex:int = 0;
	[Bindable] public var maxPageIndex:int = 0;
	
	// search text
	protected var _pendingSearchText:String = '';
	protected var _currentSearchText:String = '';

	// is searching
	private var _isSearching:Boolean = false;
	[Bindable]
	public function set isSearching(value:Boolean):void {
		_isSearching = value;
	}
	public function get isSearching():Boolean {
		return _isSearching;
	}

	
//--------------------------------------------------------------------------
//
// METHODS
//
//--------------------------------------------------------------------------	
	
	// search
	public function search(searchText:String):void {
		
		_pendingSearchText = searchText;
		
//trace(searchText, isSearching, _currentSearchText);		
		// don't search if bad search text
		if (isSearching || _pendingSearchText.length <= 0) {	
			return;
		}
		
		// if search text is the same as before, paginate
		if (_pendingSearchText == _currentSearchText) {
			if (pageIndex < maxPageIndex) {
				pageIndex++;
			}
			else {
				return;
			}
		}
		else {
			_currentSearchText = _pendingSearchText;
			pageIndex = 0;
		}
		
		executeSearch();
	}
	
	/* paginate
	public function paginate():void {

		// don't search if bad search text
		if (pageIndex >= maxPageIndex) {	
			return;
		}

		pageIndex++;
		
		executeSearch();
	}	
	*/
	
	// execute search
	protected function executeSearch():void {
		
		// set searching flag
		isSearching = true;
		
		dispatchSearchStarted();

trace('search: ' + _currentSearchText + ' - ' + pageIndex)
		
		// search google
		googleWebSearch.search(generateSearchPhrase(_currentSearchText), generateItemIndexFromPageIndex(pageIndex), 'en');
	}	
	
	// process web search
	protected function processSearch(googleSearchResult:GoogleSearchResult):void {
		
		isSearching = false;
		
		var i:int = 0;
		
		if (pageIndex <= 0) {
			pubmedItems.removeAll();
		}
		
		maxPageIndex = Math.min(6, googleSearchResult.numPages - 1);
					
		while (i < googleSearchResult.results.length && pubmedItems.length < 50) {
			
			var googleWebItem:GoogleWebItem = googleSearchResult.results[i];
			var getLastItemForID:Array = googleWebItem.unescapedUrl.split('/');
			var id:int = int(getLastItemForID[getLastItemForID.length - 1]);
			var keywords:Array = [];
			var keywordsIndex:int = 0;
			var tmpSplit:Array = _currentSearchText.split(' ');

			for each (var s:String in tmpSplit) {
				if (s.length >= 3) {
					keywords.push(s.toLowerCase());
				}
			}

			if (id > 10000) {
				var pubmed:Pubmed = new Pubmed();
				pubmed.id = id;
				pubmed.articleTitle = StringUtil.cleanAllWhiteSpace(unescape(googleWebItem.titleNoFormatting));
				pubmed.description = StringUtil.cleanAllWhiteSpace(StringUtil.stripHtmlTags(unescape(googleWebItem.content)));
				pubmed.url = StringUtil.cleanAllWhiteSpace(googleWebItem.unescapedUrl);

				var webItemTitle:String = googleWebItem.title.toLowerCase() + ' ' + googleWebItem.content.toLowerCase();
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
		
		dispatchSearchComplete();
	}
	
//--------------------------------------------------------------------------
//
// HANDLERS
//
//--------------------------------------------------------------------------
	
	// handle web search
	protected function handle_WebSearch(e:GoogleApiEvent):void {
		processSearch(e.data as GoogleSearchResult);
	}
	
	// handle web search error
	protected function handle_WebSearch_Error(evt:GoogleAPIErrorEvent):void {
		isSearching = false;
		trace("An API error has occured: " + evt.responseDetails, "responseStatus was: " + evt.responseStatus);		
	}
	
//--------------------------------------------------------------------------
//
// DISPATCHERS
//
//--------------------------------------------------------------------------
	
	// dispatch search started
	protected function dispatchSearchStarted():void {
		dispatcher.dispatchEvent(new SearchEvent(SearchEvent.SEARCH_STARTED, _currentSearchText, pageIndex, maxPageIndex));
	}
	
	// dispatch search complete
	protected function dispatchSearchComplete():void {
		dispatcher.dispatchEvent(new SearchEvent(SearchEvent.SEARCH_COMPLETE, _currentSearchText, pageIndex, maxPageIndex));
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