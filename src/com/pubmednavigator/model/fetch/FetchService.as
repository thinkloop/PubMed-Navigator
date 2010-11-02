package com.pubmednavigator.model.fetch {

import com.pubmednavigator.model.pubmed.Pubmed;
import com.thinkloop.flex4components.CachingArrayCollection;
import com.thinkloop.flex4components.StringUtil;

import flash.events.Event;

import mx.events.DynamicEvent;

public class FetchService {

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTANTS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * DEPENDENCIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	[Inject] public var pubmedFetchDelegate:FetchDelegate;
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	public function FetchService() {
	}

	[PostConstruct]
	public function pc():void {
		init();
	}
	
	public function init():void {
		isFetching = false;
		
		pubmedFetchDelegate.addEventListener(FetchDelegate.PUBMED_FETCH_RESULT, handle_PubmedFetch) ;
		pubmedFetchDelegate.addEventListener(FetchDelegate.PUBMED_FETCH_ERROR, handle_PubmedFetch_Error);				
	}
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PROPERTIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	[Bindable] public var pubmedItems:CachingArrayCollection;
	
	[Bindable] public var isFetching:Boolean;
	
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// fetch
	public function fetch():void {
		if (isFetching) {
			return;
		}
		else {
			var fetchIDList:Array = generateFetchIDList();
			if (fetchIDList.length > 0) {
trace('fetch: ' + fetchIDList.join(','));	
				pubmedFetchDelegate.fetch(fetchIDList.join(','));
				isFetching = true;
			}
		}
	}
	
	// process fetch
	protected function processFetch(pubmedArray:Array):void {
		isFetching = false;
		
trace('processFetch: ' + pubmedArray.length);		
		for each (var o:Object in pubmedArray) {
				
			var currentPubmed:Pubmed = pubmedItems.getItemByID(o.pmID) as Pubmed;
			
			if (currentPubmed) {
				var newPubmed:Pubmed = new Pubmed();
				newPubmed.id = currentPubmed.id;
				newPubmed.description = currentPubmed.description;
				newPubmed.url = currentPubmed.url;
				newPubmed.keywords = currentPubmed.keywords;
				
				newPubmed.articleTitle = StringUtil.cleanExtraWhiteSpace(o.articleTitle);
				newPubmed.journalTitle = StringUtil.cleanExtraWhiteSpace(o.journalTitle);
				newPubmed.year = int(o.year);
				newPubmed.abstract = StringUtil.cleanExtraWhiteSpace(o.abstract);
				newPubmed.authors = StringUtil.cleanExtraWhiteSpace(o.authors);
				newPubmed.isFullyPopulated = true;
				
				pubmedItems.setItemAt(newPubmed, pubmedItems.getIndexByID(o.pmID));
			}
		}
		
		fetch();
		/*
		fetchGreenThread.pubmedItems = pubmedItems;
		fetchGreenThread.pendingProcessFetches = pubmedArray;		
		fetchGreenThread.start(0.5);
		*/
	}
	
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * HANDLERS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// handle pubmed fetch
	protected function handle_PubmedFetch(e:DynamicEvent):void {
		processFetch(e.pubmedResult);
	}
	
	// handle pubmed fetch error
	protected function handle_PubmedFetch_Error(e:Event):void {
		trace('handle_PubmedFetch_Error: ' + e);		
		isFetching = false;	
	}
	
	// handle green thread complete
	protected function handle_greenThreadComplete(e:Event):void {
trace('handle_greenThreadComplete: ' + e);		
		fetch();
	}	
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * BABY METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	

	protected function generateFetchIDList():Array {
		var fetchIDList:Array = [];
		for each (var o:Object in pubmedItems) {
			if (!o.isFullyPopulated) {
				fetchIDList.push(o.id);
				o.isFullyPopulated = true;
			}
			if (fetchIDList.length >= 5) {
				break;
			}
		}
		
		return fetchIDList;
	}
}}