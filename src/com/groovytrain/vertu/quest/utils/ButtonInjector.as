package com.groovytrain.vertu.quest.utils {
	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ButtonInjector {
		
		public static function injectButtonDefaults(sprite:Sprite):void{
			sprite.buttonMode = true;
			sprite.mouseChildren = false; 
			sprite.focusRect = false;

			
		}
	}
}
