package com.pubmednavigator.model.managers {

import com.pubmednavigator.model.objects.Pubmed;
import com.thinkloop.flex4.collections.CachingArrayCollection;
import com.thinkloop.flex4.utils.StringUtil;

import flash.events.Event;

import mx.events.DynamicEvent;
import com.pubmednavigator.model.delegates.FetchDelegate;

public class FetchManager {

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

	[Inject] public var pubmedFetchDelegate:FetchDelegate;
	
//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------

	public function FetchManager() {
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
	
//-------------------------------------------------------------------------- 
//
// PROPERTIES
//
//-------------------------------------------------------------------------- 


	[Bindable] public var pubmedItems:CachingArrayCollection;
	
	[Bindable] public var isFetching:Boolean;
	
	
//--------------------------------------------------------------------------
//
// METHODS
//
//--------------------------------------------------------------------------
	
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
		
		for each (var o:Object in pubmedArray) {
				
			var currentPubmed:Pubmed = pubmedItems.cacheGet(o.pmID) as Pubmed;
			
			if (currentPubmed) {
				var newPubmed:Pubmed = pubmedItems.cacheGet(o.pmID) as Pubmed;
				newPubmed.id = currentPubmed.id;
				newPubmed.description = currentPubmed.description;
				newPubmed.url = currentPubmed.url;
				newPubmed.keywords = currentPubmed.keywords;
				
				newPubmed.articleTitle = StringUtil.cleanAllWhiteSpace(o.articleTitle);
				newPubmed.journalTitle = StringUtil.cleanAllWhiteSpace(o.journalTitle);
				newPubmed.year = int(o.year);
				newPubmed.abstract = StringUtil.cleanAllWhiteSpace(o.abstract);
				newPubmed.authors = StringUtil.cleanAllWhiteSpace(o.authors);
				newPubmed.isFullyPopulated = true;
			}
		}
		
		fetch();
		/*
		fetchGreenThread.pubmedItems = pubmedItems;
		fetchGreenThread.pendingProcessFetches = pubmedArray;		
		fetchGreenThread.start(0.5);
		*/
	}
	
	
//--------------------------------------------------------------------------
//
// HANDLERS
//
//--------------------------------------------------------------------------
	
	// handle pubmed fetch
	protected function handle_PubmedFetch(e:DynamicEvent):void {
		processFetch(e.pubmedResult);
	}
	
	// handle pubmed fetch error
	protected function handle_PubmedFetch_Error(e:Event):void {
		trace('handle_PubmedFetch_Error: ' + e);		
		isFetching = false;	
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
			if (fetchIDList.length >= 4) {
				break;
			}
		}
		
		return fetchIDList;
	}
}}