package com.kode80.experiments.pvfur
{
        import com.kode80.experiments.Experiment;
        
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.StageQuality;
        import flash.events.Event;
        import flash.events.MouseEvent;
        import flash.filters.BlurFilter;
        import flash.filters.GlowFilter;
        import flash.geom.ColorTransform;
        import flash.geom.Point;
        
        import org.papervision3d.cameras.Camera3D;
        import org.papervision3d.materials.BitmapMaterial;
        import org.papervision3d.objects.DisplayObject3D;
        import org.papervision3d.objects.primitives.Sphere;
        import org.papervision3d.render.BasicRenderEngine;
        import org.papervision3d.scenes.Scene3D;
        import org.papervision3d.view.Viewport3D;
        import org.papervision3d.view.layer.ViewportLayer;
        import org.papervision3d.view.layer.util.ViewportLayerSortMode;

        /**
        * ...
        * @author Ben Hopkins
        */
        
        public class PVFur extends Experiment
        {
                [Embed(source="../../../../../assets/pvfur/ground.jpg")]
                private var _groundTextureClass:Class;
                [Embed(source="../../../../../assets/pvfur/TigerTexture.jpg")]
                private var _tigerTextureClass:Class;
                private var _tigerTexture:Bitmap;
                
                private var _viewport:Viewport3D;
                private var _renderer:BasicRenderEngine;
                private var _camera:Camera3D;
                private var _scene:Scene3D;
                private var _spheres:Array;
                private var _sphereLayer:ViewportLayer;
                private var _object:DisplayObject3D;
                
                public function PVFur()
                {
                        super();
                }
                
                override protected function _addedToStageListener(e:Event):void
                {
                        super._addedToStageListener( e);
                        
                        stage.quality = StageQuality.LOW;
                        _tigerTexture = new _tigerTextureClass();
                        
                        
                        _viewport = new Viewport3D( stage.stageWidth, stage.stageHeight);
                        addChild( _viewport);
                        
                        _renderer = new BasicRenderEngine();
                        
                        _scene = new Scene3D();
                        
                        _camera = new Camera3D();
                        _camera.y = -200;
                        _camera.z = -1000;
                        
                        _createSpheres( 18, 500, 0, 5);
                        _scene.addChild( _object);
                        
                        addEventListener( Event.ENTER_FRAME, _enterFrameListener);
                        stage.addEventListener( MouseEvent.MOUSE_MOVE, _mouseMoveListener);
                }
                
                protected function _enterFrameListener( e:Event):void
                {
                        _object.x = (stage.mouseX - (stage.stageWidth * 0.5)) * 4;
                        _object.y = (stage.mouseY  - (stage.stageHeight * 0.5)) * -4;
                        _object.z = -200 + ((stage.mouseY  - (stage.stageHeight * 0.5)) * 4);
                        _object.rotationY+=2;
                        _object.rotationZ+=2;
                        
                        _renderer.renderScene( _scene, _camera, _viewport);
                }
                
                private function _mouseMoveListener( e:MouseEvent):void
                {
                }
                
                private function _createSpheres( layerCount:uint, radius:Number, color:uint, segment_distance:Number):void {
                        var sphere:Sphere;
                        _spheres = new Array( layerCount);
                        var material:BitmapMaterial;
                        var texture:BitmapData;
                        var textures:Array = new Array( layerCount);
                        var alphaD:Number = 1 / layerCount;
                        var alpha:Number = alphaD;
                        var ct:ColorTransform;
                        var dissolve:Number = 0.9;
                        
                        _object = new DisplayObject3D();
                        _sphereLayer = new ViewportLayer( _viewport, null);
                        _sphereLayer.sortMode = ViewportLayerSortMode.INDEX_SORT;
                        _sphereLayer.filters = [new BlurFilter( 2, 2)];
                        _viewport.containerSprite.addLayer( _sphereLayer);
                        
                        for( var i:Number=0; i<textures.length; i++) {
                                ct = new ColorTransform();
                                ct.redMultiplier = 1.5-alpha;
                                ct.greenMultiplier = 1.5-alpha;
                                ct.blueMultiplier = 1.5-alpha;
                                ct.alphaMultiplier = alpha;
                                
                                texture = new BitmapData( _tigerTexture.width, _tigerTexture.height, true, 0);
                                texture.draw( _tigerTexture);
                                texture.pixelDissolve( texture, texture.rect, new Point( 0, 0), 0, (texture.width*texture.height) * dissolve, 0);
                                texture.colorTransform( texture.rect, ct);                              
                                textures[i] = texture;
                                
                                alpha += alphaD;
                                dissolve -= 0.03;
                        }
                                        
                        for( i=0; i<_spheres.length; i++) {
                                material = new BitmapMaterial( textures[i]);
                                material.oneSide = true;
                                material.smooth = false;
                                
                                sphere = new Sphere( material, radius, 9, 6);
                                
                                radius -= segment_distance;
                                
                                _object.addChild( sphere);
                                _spheres[i] = sphere;
                        }
                        
                        var ground:Bitmap = new _groundTextureClass();
                        material = new BitmapMaterial( ground.bitmapData) ;
                        material.oneSide = true;
                        
                        var innerSphere:Sphere = new Sphere(material, radius, 9, 6);
                        _spheres.push( innerSphere);
                        
                        var layer:ViewportLayer;
                        for( i=0; i<_spheres.length; i++) 
                        {
                                layer = new ViewportLayer( _viewport, null);
                                layer.layerIndex = _spheres.length - i;
                                
                                layer.addDisplayObject3D( _spheres[i]);
                                _sphereLayer.addLayer( layer);
                                _object.addChild( _spheres[i]);
                        }
                }
        }
}