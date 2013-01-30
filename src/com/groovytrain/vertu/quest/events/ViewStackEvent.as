package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ViewStackEvent extends AbstractEvent {
		
		public static const STAGE_RESIZED:String = "STAGE_RESIZED";		public static const VIEW_ADDED:String = "VIEW_ADDED";		public static const LAYER_ADDED:String = "LAYER_ADDED";
		
		public function ViewStackEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
