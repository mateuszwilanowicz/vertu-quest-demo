package com.groovytrain.vertu.quest.materials {
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.GouraudMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.render.BasicRenderEngine;
	import org.papervision3d.view.BasicView;

	import flash.display.Sprite;
	import flash.events.Event;

	//To use GouraudMaterial you must import and instantiate a PointLight3D object
	//Import the GouraudMaterial Class

	
	public class gouraudMat extends Sprite
	{
		private var view:BasicView;
		//Declare a GouraudMaterial instance
		private var gouraud:GouraudMaterial;
		//Declare a PointLight3D instance
		private var light:PointLight3D;
		private var sphere:Sphere;
		private var angle:Number = new Number(0);

		public function gouraudMat()
		{
			view = new BasicView(300, 200, false, false, CameraType.FREE);
			view.renderer = new BasicRenderEngine(); addChild(view);
			//Instantiate your PointLight3D instance 
			//The parameter for PointLight3D = (showLight) 
			//I also set the z and y coordinates of the light up and to the back to give 
			//it some distance from the 3D object
			light = new PointLight3D(true); light.z = -800; light.y = 300;
			//Instantiate your GouraudMaterial instance 
			//GouraudMaterial parameters = (PointLight3D, Light Color, Ambient Color)
			gouraud = new GouraudMaterial(light, 0xFFFFFF, 0x222222);
			//Apply your CellMaterial to your object
			sphere = new Sphere(gouraud, 150, 8, 8);
			view.scene.addChild(sphere);

			addEventListener(Event.ENTER_FRAME, onRenderViewport);
		}
	
		private function onRenderViewport(e:Event):void
		{
			animateLight();
			view.singleRender();
		}
			
		private function animateLight():void
		{
			angle += 2 * (Math.PI/180);
			light.x = Math.cos(angle) * 800;
			light.z = Math.sin(angle) * 800;
		}
		
	}
	

}