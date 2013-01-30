package com.kode80.experiments.pvbloom
{
        import flash.display.Bitmap;
        import flash.display.BitmapData;
        import flash.display.BlendMode;
        import flash.filters.BlurFilter;
        import flash.filters.ColorMatrixFilter;
        import flash.geom.ColorTransform;
        import flash.geom.Matrix;
        import flash.geom.Point;

        /**
        * ...
        * @author Ben Hopkins
        */
        
        public class BloomFilter 
        {               
                private var _downSampleWidth:Number;
                private var _downSampleHeight:Number;
                private var _buffer:BitmapData;
                public var _mul:Number;
                public var _mix:Number;
                public var _threshold:uint;
                
                public function BloomFilter() 
                {
                        _downSampleWidth = 0.25;
                        _downSampleHeight = 0.25;
                        _mul = 0.11;
                        _mix = 0.5;
                        _threshold = 100;
                }
                
                public function Process( source:BitmapData):void 
                {
                        var w:uint = source.width * _downSampleWidth;
                        var h:uint = source.height * _downSampleHeight;
                        var matrix:Matrix = new Matrix();
                        var point:Point = new Point( 0, 0);
                        var colorTransform:ColorTransform = new ColorTransform();
                        
                        // Color matrix for grayscale
                        var a:Array = [ 0.33, 0.59, 0.11, 0, 0,   
                                                        0.33, 0.59, 0.11, 0, 0,  
                                                        0.33, 0.59, 0.11, 0, 0,   
                                                        0,0,0,1,0 ]; 
                        var colorMatrix:ColorMatrixFilter = new ColorMatrixFilter( a);
                        var blur:BlurFilter = new BlurFilter( 10, 10, 3);
                        
                        
                        matrix.scale( _downSampleWidth, _downSampleHeight);
                        
                        var downSampled:BitmapData = new BitmapData( w, h, true, 0);    
                        
                        if( _buffer == null) 
                                _buffer = new BitmapData( w, h, false, 0);
                                
                        downSampled.draw( source, matrix);
                        
                        var grayscale:BitmapData = downSampled.clone();
                        grayscale.applyFilter( downSampled, downSampled.rect, point, colorMatrix);
                        
                        downSampled.threshold( grayscale, downSampled.rect, point, "<", _threshold, 0, 0x000000ff);
                        downSampled.applyFilter( downSampled, _buffer.rect, point, blur);               
                        
                        colorTransform.alphaMultiplier = _mul;
                        colorTransform.redMultiplier = _mul;
                        colorTransform.greenMultiplier = _mul;
                        colorTransform.blueMultiplier = _mul;   
                        
                        _buffer.draw( _buffer, null, colorTransform);           
                        
                        colorTransform.alphaMultiplier = _mix;
                        colorTransform.redMultiplier = 1;
                        colorTransform.greenMultiplier = 1;
                        colorTransform.blueMultiplier = 1;
                        _buffer.draw( downSampled, null, colorTransform);
                        
                        matrix.invert();
                        source.draw( _buffer, matrix, null, BlendMode.ADD, null, true);
                }
        }
}