package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ViewEvent extends AbstractEvent {
		
		public static const REPOSITION_VIEW:String = "REPOSITION_VIEW";
		public static const VIEW_REVEALED : String = "VIEW_REVEALED";
		public static const PUTTING_AWAY_VIEW : String = "PUTTING_AWAY_VIEW";
		public static const HIDDEN : String = "HIDDEN";
		
		public function ViewEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
