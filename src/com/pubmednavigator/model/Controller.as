package com.pubmednavigator.model {

public class Controller {
	
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * DEPENDENCIES
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
	[Inject] public var model:Model;

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * CONSTRUCTOR
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	public function Controller() {
	}

// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
// * MEDIATORS
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *	

	[Mediate(event="SubmitEvent.SUBMIT", properties="searchText, cleanSearchText, keywords")]
	public function search(searchText:String, cleanSearchText:String, keywords:Array):void {
		model.search(cleanSearchText);
	}
	
	[Mediate(event="SearchEvent.SEARCH_COMPLETE", properties="searchText,pageIndex")]
	public function fetch(searchText:String, pageIndex:int):void {	
		model.fetch();
	}
}}