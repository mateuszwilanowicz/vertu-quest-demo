package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AnimationEvent extends AbstractEvent {
		
		public static const ANIMATION_STARTED:String = "ANIMATION_STARTED";
		
		public function AnimationEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}