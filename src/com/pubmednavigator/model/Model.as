package com.pubmednavigator.model {
	
import com.pubmednavigator.model.fetch.FetchService;
import com.pubmednavigator.model.pubmed.Pubmed;
import com.pubmednavigator.model.search.SearchService;
import com.thinkloop.flex4components.CachingArrayCollection;

import flash.events.IEventDispatcher;

import mx.collections.ArrayCollection;
import mx.collections.ICollectionView;
import mx.collections.IList;

public class Model {
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTANTS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * DEPENDENCIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	[Inject] public var searchService:SearchService;
	[Inject] public var fetchService:FetchService;		
	[Dispatcher] public var dispatcher:IEventDispatcher;
	
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
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
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * PROPERTIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	
	
	[Bindable] public var pubmedItems:CachingArrayCollection;
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * METHODS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	// search
	public function search(searchText:String):void {
		searchService.search(searchText);
	}
	
	// fetch
	public function fetch():void {
		fetchService.fetch();
	}	
}}