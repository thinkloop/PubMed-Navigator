package com.pubmednavigator.search.business {

import com.alphasense.fse.common.util.LogUtil;
import com.alphasense.fse.filtercolumn.business.delegates.FilterColumnTreeDelegate;
import com.alphasense.fse.filtercolumn.models.FilterColumnPresentationModel;
import com.alphasense.fse.filtercolumn.models.FilterColumnTreeData;

import flash.events.IEventDispatcher;

import mx.logging.ILogger;

public class SearchMediator {
	
	[Inject] public var model:SearchPresentation;
	[Inject] public var webSearchService:WebSearchService;
	[Inject] public var fetchService:FetchService;
	
	[Dispatcher] public var dispatcher:IEventDispatcher;
	
	[PostConstruct]
	public function pc():void {
	}
	
	/*
	[Mediate(event="FilterColumnDataEvent.DATA_LOADED", properties="filterColumnTreeData")]
	public function setFilterColumnTreeData(filterColumnTreeData:FilterColumnTreeData):void {
trace('*** model.filterColumnTreeData = filterColumnTreeData');
		model.filterColumnTreeData = filterColumnTreeData;
	}
	*/

}}