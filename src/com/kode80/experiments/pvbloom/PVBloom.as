package com.kode80.experiments.pvbloom
{
        import com.kode80.experiments.Experiment;
        
        import flash.events.Event;
        import flash.events.MouseEvent;
        
        import org.papervision3d.cameras.Camera3D;
        import org.papervision3d.core.math.Matrix3D;
        import org.papervision3d.core.math.Number3D;
        import org.papervision3d.core.proto.LightObject3D;
        import org.papervision3d.materials.ColorMaterial;
        import org.papervision3d.materials.shadematerials.GouraudMaterial;
        import org.papervision3d.materials.shadematerials.PhongMaterial;
        import org.papervision3d.materials.special.CompositeMaterial;
        import org.papervision3d.objects.DisplayObject3D;
        import org.papervision3d.objects.primitives.Sphere;
        import org.papervision3d.render.BasicRenderEngine;
        import org.papervision3d.scenes.Scene3D;
        import org.papervision3d.view.BasicView;
        import org.papervision3d.view.BitmapViewport3D;
        import org.papervision3d.view.Viewport3D;

        /**
        * ...
        * @author Ben Hopkins
        */
        
        public class PVBloom extends Experiment
        {
                private var _viewport:BitmapViewport3D;
                private var _renderer:BasicRenderEngine;
                private var _camera:Camera3D;
                private var _scene:Scene3D;
                private var _spheres:Array;
                private var _light:LightObject3D;
                private var _lightSphere:Sphere;
                private var _bloom:BloomFilter;
                private var _cameraPitch:Number;
                private var _cameraPitchTarget:Number;
                private var _counter:Number;
                
                /**************************************************
                 *      Constructor
                 **************************************************/
                 
                public function PVBloom()
                {
                        super();
                }
                
                /**************************************************
                 *      Event listeners 
                 **************************************************/
                 
                override protected function _addedToStageListener( e:Event):void
                {
                        super._addedToStageListener( e);
                        
                        _viewport = new BitmapViewport3D( stage.stageWidth, stage.stageHeight);
                        addChild( _viewport);
                        
                        _renderer = new BasicRenderEngine();
                        
                        _scene = new Scene3D();
                        _light = new LightObject3D();
                        
                        _lightSphere = new Sphere( new ColorMaterial( 0xffffff), 100, 3, 3);
                        _scene.addChild( _lightSphere);
                        
                        _camera = new Camera3D();
                        _camera.y = 600;
                        _camera.z = -900;
                        _cameraPitch = 70;
                        _cameraPitchTarget = _cameraPitch;
                        _counter = 45;
                        
                        _spheres = _createSpheres( 40);
                        
                        for( var i:uint=0; i<_spheres.length; i++)
                                _scene.addChild( _spheres[ i]);
                        
                        _bloom = new BloomFilter();
                                
                        addEventListener( Event.ENTER_FRAME, _enterFrameListener);
                        stage.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoveListener);
                }

                protected function _enterFrameListener( e:Event):void
                {
                        _light.z = (800 * Math.cos( _counter) ) * -1;
                        _light.x = 800 * Math.sin( _counter) * -1;
                        _light.y = 500;
                        
                        _lightSphere.x = _light.x;
                        _lightSphere.y = _light.y;
                        _lightSphere.z = _light.z;
                        _counter += 0.09;
                        
                        _cameraPitch += (_cameraPitchTarget - _cameraPitch) * 0.2;
                        _camera.orbit( _cameraPitch, _counter * 4);
                        
                        _renderer.renderScene( _scene, _camera, _viewport);
                        
                        _bloom.Process( _viewport.bitmapData);
                }
                
                private function _mouseMoveListener( e:MouseEvent):void
                {
                        if( e.buttonDown)
                                _cameraPitchTarget = stage.mouseY * 0.4;
                }
                
                private function _createSpheres( count:uint):Array
                {
                        var spheres:Array = new Array();
                        var sphere:Sphere;
                        var shade:GouraudMaterial;
                        var scaler:Number;
                        
                        for( var i:uint=0; i<count; i++)
                        {
                                shade = new GouraudMaterial( _light, Math.random() * 0xffffff);
                                shade.fillAlpha = 0.4;
                                
                                scaler = i / count;
                                sphere = new Sphere( shade, 80, 5, 5);
                                sphere.x = Math.sin( scaler * 24) * (scaler * 800 + 100);
                                sphere.y = (scaler * 1000) - 700;
                                sphere.z = Math.cos( scaler * 24) * (scaler * 800 + 100);
                                spheres.push( sphere);
                        }
                        
                        return spheres;
                }
        }
}