package com.kode80.experiments.pvzbuffer
{
        import com.kode80.experiments.Experiment;
        
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.BitmapDataChannel;
        import flash.display.BlendMode;
        import flash.display.StageQuality;
        import flash.events.Event;
        import flash.events.MouseEvent;
        import flash.filters.BlurFilter;
        import flash.filters.DisplacementMapFilter;
        import flash.geom.ColorTransform;
        import flash.geom.Matrix;
        import flash.geom.Point;
        
        import org.papervision3d.cameras.Camera3D;
        import org.papervision3d.core.math.Plane3D;
        import org.papervision3d.core.proto.LightObject3D;
        import org.papervision3d.lights.PointLight3D;
        import org.papervision3d.materials.BitmapMaterial;
        import org.papervision3d.materials.shadematerials.GouraudMaterial;
        import org.papervision3d.materials.shadematerials.PhongMaterial;
		import org.papervision3d.materials.shaders.ShadedMaterial;
		import org.papervision3d.materials.shaders.DepthShader;
        import org.papervision3d.materials.utils.MaterialsList;
        import org.papervision3d.objects.DisplayObject3D;
        import org.papervision3d.objects.primitives.Cube;
        import org.papervision3d.objects.primitives.Plane;
        import org.papervision3d.objects.primitives.Sphere;
        import org.papervision3d.render.BasicRenderEngine;
        import org.papervision3d.scenes.Scene3D;
        import org.papervision3d.view.BitmapViewport3D;
        import org.papervision3d.view.Viewport3D;
        import org.papervision3d.view.layer.ViewportLayer;

        /**
        * ...
        * @author Ben Hopkins
        */
        
        public class PVZBuffer extends Experiment
        {
                [Embed(source="../../../../../assets/pvfur/TigerTexture.jpg")]
                private var _cubeTextureClass:Class;
                private var _cubeTexture:Bitmap;
                
                [Embed(source="../../../../../assets/pvzbuffer/Wall.jpg")]
                private var _wallTextureClass:Class;
                private var _wallTexture:Bitmap;
                
                [Embed(source="../../../../../assets/pvzbuffer/Floor.jpg")]
                private var _floorTextureClass:Class;
                private var _floorTexture:Bitmap;
                
                [Embed(source="../../../../../assets/pvzbuffer/Ceiling.jpg")]
                private var _ceilingTextureClass:Class;
                private var _ceilingTexture:Bitmap;
                
                private var _viewport:BitmapViewport3D;
                private var _renderer:BasicRenderEngine;
                private var _camera:Camera3D;
                private var _scene:Scene3D;
                private var _light:LightObject3D;
                private var _phong:PhongMaterial;
                
                private var _zBufferViewport:BitmapViewport3D;
                private var _zBufferScene:Scene3D;
                private var _zBufferCamera:Camera3D;
                private var _dofBitmap:Bitmap;
                
                private var _cube:Cube;
                private var _cubeZ:Cube;
                
                private var _cube2:Cube;
                private var _cube2Z:Cube;
                
                private var _count:Number;
                
                public function PVZBuffer()
                {
                        super();
                }
                
                override protected function _addedToStageListener(e:Event):void
                {
                        super._addedToStageListener( e);
                        stage.quality = StageQuality.LOW;
                        _cubeTexture = new _cubeTextureClass();
                        _wallTexture = new _wallTextureClass();
                        _floorTexture = new _floorTextureClass();
                        _ceilingTexture = new _ceilingTextureClass();
                        _count = 0;
                        
                        _viewport = new BitmapViewport3D( stage.stageWidth, stage.stageHeight, false, true);
                        _zBufferViewport = new BitmapViewport3D( stage.stageWidth * 0.5, stage.stageHeight * 0.5);
                        _zBufferViewport.scaleX = _zBufferViewport.scaleY = 0.5;
                        _dofBitmap = new Bitmap( new BitmapData( stage.stageWidth * 0.5, stage.stageHeight * 0.5), "auto", true);
                        _dofBitmap.scaleX = _dofBitmap.scaleY = 2;
                        
                        addChild( _viewport);
                        addChild( _dofBitmap);
                        addChild( _zBufferViewport);
                        
                        _renderer = new BasicRenderEngine();
                        
                        _scene = new Scene3D();
                        
                        _zBufferScene = new Scene3D();
                        
                        _camera = new Camera3D();
                        _camera.z = -1400;
                        
                        _zBufferCamera = new Camera3D( 99);             // fudged focus value to sync scaled Zbuffer with main viewport 
                        
                        _light = new LightObject3D();

                        var bitmapMaterial:BitmapMaterial = new BitmapMaterial( _cubeTexture.bitmapData);
                        bitmapMaterial.smooth = false;
                        var mlist:MaterialsList = new MaterialsList();
                        mlist.addMaterial( bitmapMaterial, "all");
                        _cube = new Cube( mlist, 300, 300, 300);
                        _cube2 = new Cube( mlist, 300, 300, 300);
                        
                        
                        mlist = new MaterialsList();
                        mlist.addMaterial( _createZBufferMaterial(), "all");
                        _cubeZ = new Cube( mlist, 300, 300, 300);

                        mlist = new MaterialsList();
                        mlist.addMaterial( _createZBufferMaterial(), "all");
                        _cube2Z = new Cube( mlist, 300, 300, 300);
                        
                        _scene.addChild( _cube);
                        _scene.addChild( _cube2);
                        _zBufferScene.addChild( _cubeZ);
                        _zBufferScene.addChild( _cube2Z);
                        
                        _scene.addChild( _createRoom( 5, 3, 6, 400, 400, 0, false));
                        _zBufferScene.addChild( _createRoom( 5, 3, 6, 400, 400, 0, true));
                        
                        addEventListener( Event.ENTER_FRAME, _enterFrameListener);
                }
                
                protected function _enterFrameListener( e:Event):void
                {
                        _light.x = (stage.mouseX - (stage.stageWidth * 0.5)) * 4;
                        _light.z = 1000 + ((stage.mouseY  - (stage.stageHeight * 0.5)) * -10);
                        
                        _camera.z = Math.sin( _count) * 100 - 1400;
                        _camera.x = Math.sin( _count * 0.25) * 100;
                        _camera.y = Math.cos( _count * 0.25) * 55;
                        
                        _zBufferCamera.x = _camera.x;
                        _zBufferCamera.y = _camera.y;
                        _zBufferCamera.z = _camera.z;
                        
                        _renderer.renderScene( _scene, _camera, _viewport);
                        _renderer.renderScene( _zBufferScene, _zBufferCamera, _zBufferViewport);
                        
                        _cube.z = Math.sin( _count) * 750;
                        _cube.x = -400;
                        _cube.y = Math.sin( _count) * 200;
                        _cube.rotationY += 1.5;
                        
                        _cube2.x = -_cube.x;
                        _cube2.y = -_cube.y;
                        _cube2.z = -_cube.z;
                        _cube2.rotationY -= 1.5;
                        _count += 0.15;
                        
                        _cubeZ.x = _cube.x;
                        _cubeZ.y = _cube.y;
                        _cubeZ.z = _cube.z;
                        _cubeZ.rotationY = _cube.rotationY;
                        
                        _cube2Z.x = _cube2.x;
                        _cube2Z.y = _cube2.y;
                        _cube2Z.z = _cube2.z;
                        _cube2Z.rotationY = _cube2.rotationY;
                        
                        
                        var ct:ColorTransform = new ColorTransform( 0.55, 0.55, 0.55);
                        var bd:BitmapData = new BitmapData( stage.stageWidth * 0.5, stage.stageHeight * 0.5);
                        var m:Matrix = new Matrix();
                        m.scale( 0.5, 0.5);
                        bd.draw( _viewport.bitmapData, m);
                        
                        _zBufferViewport.bitmapData.applyFilter( _zBufferViewport.bitmapData, bd.rect, new Point(), new BlurFilter( 10, 10, 1));
                        
                        
                        bd.applyFilter( bd, bd.rect, new Point(), new BlurFilter( 8, 8, 1));
                        bd.colorTransform( bd.rect, ct);
                        
                        bd.copyChannel( _zBufferViewport.bitmapData, _zBufferViewport.bitmapData.rect, new Point(), BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
                        _dofBitmap.bitmapData = bd;
                }
                
                /**
                 *      Creates a room composed of 3 walls, ceiling and floor.
                 */
                
                private function _createRoom( width:Number, height:Number, depth:Number, 
                                                                          tileWidth:Number, tileHeight:Number, 
                                                                          gapSize:Number, useZBufferMaterial:Boolean):DisplayObject3D
                {
                        var room:DisplayObject3D = new DisplayObject3D();
                        var back:DisplayObject3D = _createWall( width, height, tileWidth, tileHeight, gapSize, useZBufferMaterial, _wallTexture.bitmapData);
                        var left:DisplayObject3D = _createWall( depth, height, tileWidth, tileHeight, gapSize, useZBufferMaterial, _wallTexture.bitmapData);
                        var right:DisplayObject3D = _createWall( depth, height, tileWidth, tileHeight, gapSize, useZBufferMaterial, _wallTexture.bitmapData);
                        var top:DisplayObject3D = _createWall( width, depth, tileWidth, tileHeight, gapSize, useZBufferMaterial, _ceilingTexture.bitmapData);
                        var bottom:DisplayObject3D = _createWall( width, depth, tileWidth, tileHeight, gapSize, useZBufferMaterial, _floorTexture.bitmapData);
                        
                        back.z = ((depth * tileHeight) + ((depth - 1) * gapSize)) * 0.5;
                        left.x = ((width * tileWidth) + ((width - 1) * gapSize)) * -0.5;
                        right.x = ((width * tileWidth) + ((width - 1) * gapSize)) * 0.5;
                        top.y = ((height * tileHeight) + ((height - 1) * gapSize)) * 0.5;
                        bottom.y = ((height * tileHeight) + ((height - 1) * gapSize)) * -0.5;
                        
                        left.rotationY = 180+90;
                        right.rotationY = 90;
                        top.rotationX = 180+90;
                        bottom.rotationX = 90;
                        
                        room.addChild( back);
                        room.addChild( left);
                        room.addChild( right);
                        room.addChild( top);
                        room.addChild( bottom);
                                
                        return room;
                }
                
                /**
                 *      Creates a grid of planes to be used as a wall in the room. 
                 */
                 
                private function _createWall( width:Number, height:Number, 
                                                                          tileWidth:Number, tileHeight:Number,
                                                                          gapSize:Number, usesZBufferMaterial:Boolean, bmp:BitmapData=null):DisplayObject3D
                {
                        var wall:DisplayObject3D = new DisplayObject3D();
                        var plane:Plane;
                        var pWidth:Number = (tileWidth + gapSize) * (width - 1);
                        var pHeight:Number = (tileHeight + gapSize) * (height - 1);
                        var xOffset:Number = pWidth * -0.5;
                        var yOffset:Number = pHeight * -0.5;
                        var xStep:Number = tileWidth + gapSize;
                        var yStep:Number = tileHeight + gapSize;
                        var bitmapMaterial:BitmapMaterial;
                        
                        if( !usesZBufferMaterial)
                        {
                                bitmapMaterial = new BitmapMaterial( bmp);
                                bitmapMaterial.smooth = false;
                        }
                                        
                        for( var columns:uint=0; columns<width; columns++)
                        {
                                for( var rows:int=0; rows<height; rows++)
                                {
                                        if( usesZBufferMaterial)
                                        {
                                                plane = new Plane( _createZBufferMaterial(), tileWidth, tileHeight, 0, 0);
                                        }
                                        else
                                        {
                                                plane = new Plane( bitmapMaterial, tileWidth, tileHeight, 0, 0);
                                        }
                                                
                                        plane.x = xOffset;
                                        plane.y = yOffset;
                                        wall.addChild( plane);
                                        yOffset += yStep;
                                }
                                yOffset = pHeight * -0.5;
                                xOffset += xStep;
                        }
                        
                        return wall;
                }
                
                /**
                 *      Creates a depth shaded material to be used by objects in the zbuffer scene 
                 */
                 
                private function _createZBufferMaterial():ShadedMaterial
                {
                        var depth:DepthShader = new DepthShader( _light, 0xFFFFFF, 0x000000, 1000, 2500);
                        var bmp:BitmapData = new BitmapData( 1, 1, false, 0xffffff);
                        var material:ShadedMaterial = new ShadedMaterial( new BitmapMaterial( bmp), depth);
                        
                        return material;
                }
        }
}