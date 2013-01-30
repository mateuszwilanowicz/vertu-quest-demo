package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class GlobeEvent extends AbstractEvent {
		
		public static const GLOBE_READY:String = "GLOBE_READY";
		public static const DEACTIVATE_GLOBE : String = "DEACTIVATE_GLOBE";
		public static const REACTIVATE_GLOBE : String = "REACTIVATE_GLOBE";

		public function GlobeEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
