package com.kode80.experiments
{
        import flash.display.Sprite;
        import flash.display.StageAlign;
        import flash.display.StageScaleMode;
        import flash.events.Event;

        /**
        * ...
        * @author Ben Hopkins
        */
        
        public class Experiment extends Sprite
        {
                /**************************************************
                 *      Constructor 
                 **************************************************/
                 
                public function Experiment()
                {
                        super();
                        addEventListener( Event.ADDED_TO_STAGE, _addedToStageListener);
                }
                
                /**************************************************
                 *      Event listeners 
                 **************************************************/
                 
                protected function _addedToStageListener( e:Event):void
                {
                        stage.scaleMode = StageScaleMode.NO_SCALE;
                        stage.align = StageAlign.TOP_LEFT;
                }
                
        }
}