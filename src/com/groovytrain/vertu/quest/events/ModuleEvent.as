package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ModuleEvent extends AbstractEvent {
		
		public static const CLOSE_CLICKED:String = "CLOSE_CLICKED";
		public static const CLOSE_DONE : String = "CLOSE_DONE";
		public static const HIDE_MODULE : String = "HIDE_MODULE";
		public static const POPUP_CLICKED : String = "POPUP_CLICKED";

		public function ModuleEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
