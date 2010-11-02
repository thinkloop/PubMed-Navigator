package com.pubmednavigator.model.fetch {

import com.pubmednavigator.model.pubmed.Pubmed;
import com.thinkloop.flex4components.CachingArrayCollection;
import com.thinkloop.flex4components.StringUtil;

import flash.events.Event;

import org.greenthreads.GreenThread;

public class FetchGreenThread_unused extends GreenThread {
	
	public var pubmedItems:CachingArrayCollection;
	public var pendingProcessFetches:Array = [];
	
	// constructor
	public function FetchGreenThread_unused() {
		
		// "true" turns on debug statisitics
		super(true);
		
		/* output statistics to console
		addEventListener(Event.COMPLETE, function(event:Event):void {
				trace(statistics.print());
			});
		*/
	}

	// initialize is invoked every time a greenthread is start()'ed
	override protected function initialize():void {
	}

	// run(): 
	override protected function run():Boolean {		
		var o:Object = pendingProcessFetches.shift();
		
		if (o) {			
			var currentPubmed:Pubmed = pubmedItems.getItemByID(o.pmID) as Pubmed;
			
			if (currentPubmed) {
trace('greenthread: ' + currentPubmed.id);				
				currentPubmed.articleTitle = StringUtil.cleanExtraWhiteSpace(o.articleTitle);
				currentPubmed.journalTitle = StringUtil.cleanExtraWhiteSpace(o.journalTitle);
				currentPubmed.year = int(o.year);
				currentPubmed.abstract = StringUtil.cleanExtraWhiteSpace(o.abstract);
				currentPubmed.authors = StringUtil.cleanExtraWhiteSpace(o.authors);
				currentPubmed.isFullyPopulated = true;
			}
		}
		
		
		if (pendingProcessFetches.length > 0) {
			return true;
		}
		else {
			return false;
		}
	}
}}