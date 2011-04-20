package com.pubmednavigator.presenters {

import com.pubmednavigator.model.Model;
import com.pubmednavigator.events.SubmitEvent;
import com.thinkloop.flex4.utils.StringUtil;

import mx.collections.IList;

public class SearchPresenter {
	
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
	
	[Inject] public var model:Model;
	[Dispatcher] public var dispatcher:IEventDispatcher;
	
//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------
	
	public function SearchPresenter() {
		
	}
	
	[PostConstruct]
	public function init():void {
		pubmedItems = model.pubmedItems;
		searchBoxText = '';
		
		isSearching = false;
		isTextTyped = false;
		isVisibleSearchResult = false;
		isVisibleNoResult = false;
	}
	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------
	
	[Bindable] public var pubmedItems:IList;
	
	[Bindable] public var isSearching:Boolean;
	[Bindable] public var isTextTyped:Boolean;
	[Bindable] public var isVisibleSearchResult:Boolean;
	[Bindable] public var isVisibleNoResult:Boolean;

	protected var _searchBoxText:String;
	protected var _cleanSearchBoxText:String;
	protected var _keywords:Array;
	[Bindable]
	public function set searchBoxText(value:String):void {
		if(_searchBoxText != value) {
			_searchBoxText = value;
			_cleanSearchBoxText = StringUtil.cleanAllWhiteSpace(value);
			_keywords = _cleanSearchBoxText.split(' ');
			dispatchSubmitEvent();
			updateVisibility();
		}
	}
	public function get searchBoxText():String {
		return _searchBoxText;
	}
	public function get keywords():Array {
		return _keywords;
	}	
	
//--------------------------------------------------------------------------
//
// METHODS
//
//--------------------------------------------------------------------------

	[Mediate(event="SearchEvent.SEARCH_COMPLETE")]
	public function updateVisibility():void {	
		isVisibleSearchResult = isTextTyped && pubmedItems.length > 0;
		isVisibleNoResult = isTextTyped && pubmedItems.length <= 0;
	}
	
//--------------------------------------------------------------------------
//
// DISPATCHERS
//
//--------------------------------------------------------------------------

	public function dispatchSubmitEvent():void {
		dispatcher.dispatchEvent(new SubmitEvent(SubmitEvent.SUBMIT, _searchBoxText, _cleanSearchBoxText, _keywords));
	}	
}}