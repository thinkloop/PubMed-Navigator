package com.pubmednavigator.model {
	
import com.pubmednavigator.model.managers.FetchManager;
import com.pubmednavigator.model.objects.Pubmed;
import com.pubmednavigator.model.managers.SearchManager;
import com.thinkloop.flex4.collections.CachingArrayCollection;

import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;

public class Model {
	
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
	
	[Inject] public var searchService:SearchManager;
	[Inject] public var fetchService:FetchManager;		
	[Dispatcher] public var dispatcher:IEventDispatcher;
	
	
//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------
	
	public function Model() {
	}

	
	[PostConstruct]
	public function pc():void {
		init();
	}
	
	public function init():void {
		pubmedItems = searchService.pubmedItems;
		fetchService.pubmedItems = searchService.pubmedItems;
	}
	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------	
	
	[Bindable] public var pubmedItems:CachingArrayCollection;
	[Bindable] public var searchText:String;
	
//--------------------------------------------------------------------------
//
// METHODS
//
//--------------------------------------------------------------------------
	
	// search
	public function search():void {
		searchService.search(searchText);
	}
	
	// fetch
	public function fetch():void {
		fetchService.fetch();
	}	
}}