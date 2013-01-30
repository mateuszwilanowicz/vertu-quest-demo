package com.groovytrain.vertu.quest.views.generic {
	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class BasicButton extends Sprite {
		
		private var _enabled:Boolean = true;
		
		public function BasicButton() {
			buttonMode = true;
			mouseChildren = false;
		}

		public function get enabled() : Boolean {
			return _enabled;
		}

		public function set enabled(enabled : Boolean) : void {
			_enabled = enabled;
			
			buttonMode = _enabled;
		}
	}
}
