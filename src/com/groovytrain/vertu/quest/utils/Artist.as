package com.groovytrain.vertu.quest.utils {
	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class Artist {
		
		public static function drawRect(parentObj:Sprite, x:Number, y:Number, w:Number, h:Number, 
										fillColour:int=0x000000, fillAlpha:Number=1, 
										lineThickness:Number=0, lineColour:int=0, lineAlpha:Number=1):void {
											
			parentObj.graphics.lineStyle(lineThickness, lineColour, lineAlpha, true);
			parentObj.graphics.beginFill(fillColour, fillAlpha);
			parentObj.graphics.drawRect(x, y, w, h);
			parentObj.graphics.endFill();
			
		}
		
		public static function drawLine(parentObj:Sprite, w:Number,
										lineThickness:Number=0.25, lineColour:int=0, lineAlpha:Number=1):void {
											
			parentObj.graphics.lineStyle(lineThickness, lineColour, lineAlpha, true);
			parentObj.graphics.lineTo(w, 0);
			
		}
	}
}
