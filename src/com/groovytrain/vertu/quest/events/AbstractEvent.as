package com.groovytrain.vertu.quest.events {
	import flash.events.Event;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AbstractEvent extends Event {
		
		public var data:Object = new Object();
		
		public function AbstractEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
