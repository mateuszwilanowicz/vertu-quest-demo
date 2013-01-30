package com.groovytrain.vertu.quest.materials {
	import org.papervision3d.core.render.command.RenderLine;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.materials.special.LineMaterial;

	import flash.display.Graphics;

	/**
	 * @author C4RL05
	 */
	public class LineMaterialPlus extends LineMaterial 
	{
		public var pixelHinting							:Boolean = false;
		public var scaleMode							:String = "normal";
		public var caps									:String = null;
		public var joints								:String = null;
		public var miterLimit							:Number = 3;

		public function LineMaterialPlus( color:Number = 0xFF0000, alpha:Number = 1)
		{
			super( color, alpha );
		}
		
		public override function drawLine( line:RenderLine, graphics:Graphics, renderSessionData:RenderSessionData ):void
		{	
			graphics.lineStyle( lineThickness, lineColor, lineAlpha, pixelHinting, scaleMode, caps, joints, miterLimit );

			graphics.moveTo( line.v0.x, line.v0.y );
			
			if(line.cV){
				graphics.curveTo(line.cV.x, line.cV.y, line.v1.x, line.v1.y);
			}else{
				graphics.lineTo( line.v1.x, line.v1.y );
			}
			
			graphics.moveTo(0,0);
			graphics.lineStyle();
		}
	}
}


