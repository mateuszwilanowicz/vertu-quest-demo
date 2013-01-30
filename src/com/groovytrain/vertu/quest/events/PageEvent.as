package com.groovytrain.vertu.quest.events {
	import com.groovytrain.vertu.quest.events.AbstractEvent;
	
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class PageEvent extends AbstractEvent {
		
		public static const CLOSE_CLICKED:String = "PAGE_CLOSE_CLICKED";
		public static const CLOSE_DONE : String = "PAGE_CLOSE_DONE";
		
		public function PageEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
