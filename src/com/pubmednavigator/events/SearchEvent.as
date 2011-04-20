package com.pubmednavigator.events {

import flash.events.Event;

public class SearchEvent extends Event {
	
//--------------------------------------------------------------------------
//
// CONSTANTS
//
//--------------------------------------------------------------------------

	public static const SEARCH_STARTED:String = 'SearchEvent.SEARCH_STARTED';
	public static const SEARCH_COMPLETE:String = 'SearchEvent.SEARCH_COMPLETE';

//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------

	public function SearchEvent(type:String, searchText:String, pageIndex:int, maxPageIndex:int) {
		this.searchText = searchText;
		this.pageIndex = pageIndex;
		
		super(type, true, true);
	}
	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------	
	
	public var searchText:String;
	public var pageIndex:int;
	public var maxPageIndex:int;
}}