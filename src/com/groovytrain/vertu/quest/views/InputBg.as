package com.groovytrain.vertu.quest.views {
	import flash.display.Sprite;

	/**
	 * @author mateuszw
	 */
	public class InputBg extends Sprite {
		public function InputBg() {
			graphics.beginFill(0xd0d0d0,1);
			graphics.drawRect(0,0, 250, 25);
			graphics.beginFill(0xFFFFFF,1);
			graphics.drawRect(1,1,248,23);
			graphics.endFill();
		}
	}
}
