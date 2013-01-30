package org.papervision3d.materials.shaders
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	import org.papervision3d.core.geom.renderables.Triangle3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.core.proto.LightObject3D;
	import org.papervision3d.core.render.data.RenderSessionData;
	import org.papervision3d.core.render.shader.ShaderObjectData;
	import org.papervision3d.materials.shaders.ILightShader;
	import org.papervision3d.materials.shaders.IShader;
	import org.papervision3d.materials.shaders.LightShader;
	import org.papervision3d.materials.utils.LightMaps;
	
	/**
	 * @Author Andy Zupko
	 */
	public class DepthShader extends LightShader implements IShader, ILightShader
	{
		
		private static var triMatrix:Matrix = new Matrix();
		private static var currentGraphics:Graphics;
		private static var zAngle:Number;
		private static var currentColor:int;
		
		private static var vx:Number;
		private static var vy:Number;
		private static var vz:Number;
		
		public var lightColor:int;
		public var ambientColor:int;
		private var _colors:Array;
		private var _colorRamp:BitmapData;
		public var maxDistance:Number;
		public var minDistance:Number;
		
		public function DepthShader(light:LightObject3D, lightColor:int = 0xFFFFFF, ambientColor:int = 0, minDist:Number = 1000, maxDist:Number  = 5000)
		{
			super();
			
			this.light = light;
			this.lightColor = lightColor;
			this.ambientColor = ambientColor;
			this._colors = LightMaps.getFlatMapArray(lightColor, ambientColor,1);
			this._colorRamp = LightMaps.getFlatMap(lightColor, ambientColor,1);
			this.minDistance = minDist;
			this.maxDistance = maxDist;
		}
		
		/**
		 * Localized vars
		 */
		private static var zd:Number;
		private static var lightMatrix:Matrix3D;
		private static var sod:ShaderObjectData;
		private static var md:Number;
		private static var dd:Number;
		private static var dx:Number;
		private static var dy:Number;
		private static var dz:Number;
		private static var tMatrix:Matrix3D;
		
		override public function renderLayer(triangle:Triangle3D, renderSessionData:RenderSessionData, sod:ShaderObjectData):void
		{
			lightMatrix = Matrix3D(sod.lightMatrices[this]);
			tMatrix = Matrix3D.multiply(triangle.instance.world,lightMatrix );
			
			dx = tMatrix.n14 - light.x;
			dy = tMatrix.n24 - light.y;
			dz = tMatrix.n34 - light.z;
			dd = Math.sqrt(dx*dx+dy*dy+dz*dz);
			
			md = dd-minDistance;
			
			if(md < 1)
				md = 1;
			
			//to use with flat shading, uncomment the line below, and change the following line to zd -= (mx/...)
			//zd = triangle.faceNormal.x * lightMatrix.n31 + triangle.faceNormal.y * lightMatrix.n32 + triangle.faceNormal.z * lightMatrix.n33;
			
			zd = 1-(md/(maxDistance-minDistance));
				
			
			if(zd < 0)
				zd = 0;
			
			if(zd > 1)
				zd = 1;
			
			
			zd = zd*0xFF;
			
			triMatrix = sod.uvMatrices[triangle] ? sod.uvMatrices[triangle] : sod.getUVMatrixForTriangle(triangle);
			currentColor = _colors[int(zd)];
			
			currentGraphics = Sprite(layers[sod.object]).graphics;
			currentGraphics.beginFill(currentColor,1);
			currentGraphics.moveTo(triMatrix.tx, triMatrix.ty);
			currentGraphics.lineTo(triMatrix.a+triMatrix.tx, triMatrix.b+triMatrix.ty);
			currentGraphics.lineTo(triMatrix.c+triMatrix.tx, triMatrix.d+triMatrix.ty);
			currentGraphics.lineTo(triMatrix.tx, triMatrix.ty);
			currentGraphics.endFill();
		}
		
		/**
		 *Localized var
		 */
		public static var scaleMatrix:Matrix = new Matrix();
		override public function renderTri(triangle:Triangle3D, renderSessionData:RenderSessionData, sod:ShaderObjectData,bmp:BitmapData):void
		{
			lightMatrix = Matrix3D(sod.lightMatrices[this]);
			if(lightMatrix){
				
				tMatrix = Matrix3D.multiply(triangle.instance.world,lightMatrix );
			
				dx = tMatrix.n14 - light.x;
				dy = tMatrix.n24 - light.y;
				dz = tMatrix.n34 - light.z;
				dd = Math.sqrt(dx*dx+dy*dy+dz*dz);
				
				md = dd-minDistance;
				
				if(md < 1)
					md = 1;

				zd = 1-(md/(maxDistance-minDistance));
					
				
				if(zd < 0)
					zd = 0;
				
				if(zd > 1)
					zd = 1;
				
				
				zd = zd*0xFF;
				
				scaleMatrix.a = bmp.width;
				scaleMatrix.d = bmp.height;
				scaleMatrix.tx =-int(zd)*bmp.width;
				bmp.draw(_colorRamp, scaleMatrix,null,layerBlendMode, bmp.rect, false);
			}
		}
	}
}