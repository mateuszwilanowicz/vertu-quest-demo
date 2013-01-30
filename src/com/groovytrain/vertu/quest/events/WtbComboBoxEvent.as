package com.groovytrain.vertu.quest.events {
	import com.groovytrain.vertu.quest.events.AbstractEvent;
	
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class WtbComboBoxEvent extends AbstractEvent {
		public static const SELECTION_CHANGED : String = "SELECTION_CHANGED";
		public static const DROP_DOWN_OPENING : String = "DROP_DOWN_OPENING";
		public static const STORE_CHOSEN : String = "STORE_CHOSEN";

		public function WtbComboBoxEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
