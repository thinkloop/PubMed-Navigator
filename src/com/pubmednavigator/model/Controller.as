package com.pubmednavigator.model {

public class Controller {
	
//--------------------------------------------------------------------------
//
// DEPENDENCIES
//
//--------------------------------------------------------------------------
	
	[Inject] public var model:Model;

//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------

	public function Controller() {
	}

//--------------------------------------------------------------------------
//
// MEDIATORS
//
//--------------------------------------------------------------------------	

	[Mediate(event="SubmitEvent.SUBMIT", properties="searchText, cleanSearchText, keywords")]
	public function search(searchText:String, cleanSearchText:String, keywords:Array):void {
		model.searchText = cleanSearchText;
		model.search();
	}
	
	[Mediate(event="SearchEvent.SEARCH_COMPLETE", properties="searchText,pageIndex,maxPageIndex")]
	public function fetch(searchText:String, pageIndex:int, maxPageIndex:int):void {
		if (pageIndex >= Math.min(5, maxPageIndex)) {
			model.fetch();
		}
		model.search();	
	}
}}