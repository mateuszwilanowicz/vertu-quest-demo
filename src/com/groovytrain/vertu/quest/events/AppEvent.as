package com.groovytrain.vertu.quest.events {
	import com.groovytrain.vertu.quest.events.AbstractEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AppEvent extends AbstractEvent {
		
		public static const LANGUAGE_CHANGED : String = "LANGUAGE_CHANGED";
		public static const LANGUAGE_CHANGED_AR : String = "LANGUAGE_CHANGED_ARABIC";
		
		public function AppEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
