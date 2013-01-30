package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterComboViewEvent extends AbstractEvent {

		public static const MOUSE_STRAYED_OUT : String = "MOUSE_STRAYED_OUT";

		public function FooterComboViewEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
