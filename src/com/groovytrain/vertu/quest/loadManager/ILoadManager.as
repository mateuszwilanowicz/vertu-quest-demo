package com.groovytrain.vertu.quest.loadManager {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public interface ILoadManager {
		
		/* This issues an Loader.load request and on successfull load, calls the callback function you provide */
		function loadItem(itemRelativePath:String, callback:Function, showLoader:Boolean = false):void
		
		/* This appends the load queue with the item's path if not already exists or is loaded. */
		function addItemToLoadQueue(itemRelativePath:String, callback:Function, showLoader:Boolean = false):void
		
	}
}
