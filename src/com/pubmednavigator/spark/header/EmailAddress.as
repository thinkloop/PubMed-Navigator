package com.pubmednavigator.spark.header {
import flash.events.MouseEvent;
import flash.system.System;

import mx.controls.ToolTip;
import mx.core.IToolTip;
import mx.managers.ToolTipManager;

import spark.components.Button;

public class EmailAddress extends Button {
	
//--------------------------------------------------------------------------
//
// CONSTANTS
//
//--------------------------------------------------------------------------
	

//--------------------------------------------------------------------------
//
// CONSTRUCTOR
//
//--------------------------------------------------------------------------
	
	public function EmailAddress() {
		super();
		
		setStyle("skinClass", EmailAddressSkin);
		
		addEventListener(MouseEvent.ROLL_OVER, function():void { isClicked = false });
		addEventListener(MouseEvent.ROLL_OUT, function():void { isClicked = false });
		addEventListener(MouseEvent.CLICK, function():void { isClicked = true });
	}
	
//--------------------------------------------------------------------------
//
// PROPERTIES
//
//--------------------------------------------------------------------------
	
	[Bindable] public var upText:String;
	[Bindable] public var hoverText:String;
	
	public var customToolTip:IToolTip;
	
	[Bindable]
	protected var _isClicked:Boolean = false;
	public function set isClicked(value:Boolean):void {
		_isClicked = value;
		
		if (value == true) {
			System.setClipboard(hoverText);
			createToolTip2();
		}
		else {
			createToolTip1();
		}
		
		invalidateDisplayList();
	}
	public function get isClicked():Boolean {
		return _isClicked;
	}

//--------------------------------------------------------------------------
//
// METHODS
//
//--------------------------------------------------------------------------
	
	// create tooltip 1
	public function createToolTip1():void {
		destroyToolTip();
		customToolTip = ToolTipManager.createToolTip('Click to copy to clipboard.', this.x - (118 - this.width), this.y + this.height);
	}
	
	// create tooltip 2
	public function createToolTip2():void {
		destroyToolTip();
		customToolTip = ToolTipManager.createToolTip('Copied. Now paste it in your email program.', this.x - (199 - this.width), this.y + this.height);
	}
	
	// destroy tooltip
	public function destroyToolTip():void {
		try {
			ToolTipManager.destroyToolTip(customToolTip);
		} catch (error:Error) {
			// no need to do anything if there is no tooltip to destroy
		}
	}
	
//--------------------------------------------------------------------------
//
// OVERRIDES
//
//--------------------------------------------------------------------------
	
	// commit properties
	override protected function commitProperties():void { 
		super.commitProperties(); 
		
		// label
		if (getCurrentSkinState() == 'down' || getCurrentSkinState() == 'over') {
			label = hoverText;
		}
		else {
			label = upText;
		}
	}
	
	// update display list
	override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
		super.updateDisplayList(unscaledWidth, unscaledHeight);
		
		// tooltip
		if (getCurrentSkinState() == 'down' || getCurrentSkinState() == 'over') {
			if (isClicked) {
				createToolTip2();
			}
			else {
				createToolTip1();
			}
		}
		else {
			destroyToolTip();
		}
	}	
}}