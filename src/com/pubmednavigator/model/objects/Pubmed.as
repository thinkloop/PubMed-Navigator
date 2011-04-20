package com.pubmednavigator.model.objects {
	
import com.adobe.fiber.core.model_internal;
import com.adobe.fiber.services.IFiberManagingService;
import com.adobe.fiber.valueobjects.AvailablePropertyIterator;
import com.adobe.fiber.valueobjects.IPropertyIterator;
import com.adobe.fiber.valueobjects.IValueObject;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.getClassByAlias;
import flash.net.registerClassAlias;

import mx.events.PropertyChangeEvent;


[Bindable]
public class Pubmed {
	
//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------

	public function Pubmed() {
		
	}
	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------	
	
	public var id:int = 0;
	public var articleTitle:String = '';
	public var url:String = '';
	public var description:String = '';
	public var keywords:Array = [];
	
	public var year:int = 0;
	public var journalTitle:String = '';
	public var authors:String = '';
	public var abstract:String = '';
	
	// true when populated from pubmed
	public var isFullyPopulated:Boolean = false;
	
}}