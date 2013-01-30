package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AnimationEvent extends AbstractEvent {
		
		public static const ANIMATION_STARTED:String = "ANIMATION_STARTED";		public static const ANIMATION_FINISHED:String = "ANIMATION_FINISHED";		public static const REVEAL_MODULE_BACKGROUND : String = "REVEAL_MODULE_BACKGROUND";
		
		public function AnimationEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
