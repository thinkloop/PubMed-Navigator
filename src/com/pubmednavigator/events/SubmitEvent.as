package com.pubmednavigator.events {

import flash.events.Event;


public class SubmitEvent extends Event {
	
//--------------------------------------------------------------------------
//
// CONSTANTS
//
//--------------------------------------------------------------------------

	public static const SUBMIT:String = 'SubmitEvent.SUBMIT';

//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------

	public function SubmitEvent(type:String, searchText:String, cleanSearchText:String, keywords:Array) {
		this.searchText = searchText;
		this.cleanSearchText = cleanSearchText;
		this.keywords = keywords;
		super(type, true, true);
	}
	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------	
	
	public var searchText:String;
	public var cleanSearchText:String;
	public var keywords:Array;
}}