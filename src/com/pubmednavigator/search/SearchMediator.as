package com.pubmednavigator.search {

public class SearchMediator {
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * DEPENDENCIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	[Inject] public var presentation:Model;

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	public function SearchMediator() {
	}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * MEDIATORS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	

	/*
	[Mediate(event="SearchEvent.SEARCH_COMPLETE", properties="searchText,pageIndex")]
	public function fetch(searchText:String, pageIndex:int):void {	
		model.fetch();
	}	
	*/
}}