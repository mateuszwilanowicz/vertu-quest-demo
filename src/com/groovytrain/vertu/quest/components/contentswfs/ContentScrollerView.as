package com.groovytrain.vertu.quest.components.contentswfs {
	
	import gs.TweenLite;

	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ContentScrollerView extends Sprite implements IContentScrollerView {
		
		private var _minY:Number;
		private var _maxY:Number;
		//
		private var _scrollContent:Sprite;
		private var _scrollMask:Sprite;
		private var _upArrow:Sprite;
		private var _dnArrow:Sprite;
		private var _track:Sprite;
		private var _dragger : Sprite;
		
		private var _draggerMin: Number = 0;
		private var _draggerMax: Number = 0;
		
		private var _scrollDirection : Number = 0;
		private var _scrollMagnitude : Number = 30;
		
		public function ContentScrollerView() {
			init();
		}

		private function init() : void {
			
			_scrollContent = getChildByName("scrollContentSprite") as Sprite;
			_scrollMask = getChildByName("scrollMaskSprite") as Sprite;
			_upArrow = getChildByName("upArrowSprite") as Sprite;
			_dnArrow = getChildByName("dnArrowSprite") as Sprite;
			_track = getChildByName("trackSprite") as Sprite;
			_dragger = getChildByName("draggerSprite") as Sprite;
			
			ButtonInjector.injectButtonDefaults(_upArrow);
			ButtonInjector.injectButtonDefaults(_dnArrow);
			ButtonInjector.injectButtonDefaults(_dragger);
            
			_maxY = _scrollMask.y;
			_minY = _maxY - _scrollContent.height + _scrollMask.height;

			_draggerMin = _track.y;
			_draggerMax = _track.y + _track.height - _dragger.height;
			
			_upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upDownHandler);
			_dnArrow.addEventListener(MouseEvent.MOUSE_DOWN, dnDownHandler);
						
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDownHandler);
			
			_scrollMask.cacheAsBitmap = true;
			_scrollContent.cacheAsBitmap = true;
			
			_scrollContent.mask = _scrollMask;
			
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelHandler);
			
			addEventListener("resetMinY",resetMinY);
			
			this.mouseEnabled = true;
			//TweenLite.delayedCall(5, scrollToTop);
			
			
			
		}
		
		public function resetMinY(e:Event = null):void {
			_minY = _maxY - _scrollContent.height + _scrollMask.height;
		}


		private function onMouseWheelHandler(event : MouseEvent) : void {
			if ( event.delta > 0 ) {
				_scrollDirection = 1;
				arrowTrackingHandler(event);
			} else if ( event.delta < 0 ) {
				_scrollDirection = -1;
				arrowTrackingHandler(event);
			}
		}

		private function draggerDownHandler(event : MouseEvent) : void {
			_dragger.startDrag(false, new Rectangle(_track.x, _track.y, 0, _track.height - _dragger.height));
			
			addEventListener(Event.ENTER_FRAME, draggerTrackingHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, draggerMouseUpHandler);
		}

		private function draggerMouseUpHandler(event : MouseEvent) : void {
			_dragger.stopDrag();
			removeEventListener(Event.ENTER_FRAME, draggerTrackingHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, draggerMouseUpHandler);
		}

		private function draggerTrackingHandler(event : Event) : void {
			updateScroll((_dragger.y - _draggerMin) / (_draggerMax - _draggerMin));
		}

		private function upDnMouseUpHandler(event : MouseEvent) : void {
			_scrollDirection = 0;
			removeEventListener(Event.ENTER_FRAME, arrowTrackingHandler);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, upDnMouseUpHandler);
		}

		private function upDownHandler(event : MouseEvent) : void {
			_scrollDirection = 1;
			addEventListener(Event.ENTER_FRAME, arrowTrackingHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, upDnMouseUpHandler);
		}

		private function dnDownHandler(event : MouseEvent) : void {
			_scrollDirection = -1;
			addEventListener(Event.ENTER_FRAME, arrowTrackingHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, upDnMouseUpHandler);
		}
				
		private function arrowTrackingHandler(event : Event) : void {
			
			var yPos : Number = _scrollContent.y + (_scrollDirection*_scrollMagnitude);

			if(yPos > _maxY){
				yPos = _maxY;
			}else if(yPos< _minY){
				yPos = _minY;
			}
			_scrollContent.y = yPos;
			
			updateDragger(yPos);
			
		}

		private function updateDragger(yPos : Number) : void {
			
			var range : Number = _draggerMax - _draggerMin;
			var ratio:Number = yPos / _minY;
			
			_dragger.y = _draggerMin + (range * ratio);
			
		}

		public function updateScroll(percentage : Number) : void {
			var range : Number = _maxY - _minY;
			_scrollContent.y = _maxY - ((percentage) * range);
		}

		public function scrollToTop(animated : Boolean=true , time : Number = 0.4) : void {
			if(animated){
				TweenLite.to(_scrollContent, time, {y:_maxY, onUpdate:trackScrollContentPos});
			}else{
				_scrollContent.y = _maxY;
				updateDragger(_scrollContent.y);
			}
		}
		
		public function scrollToTo(yPos:Number, animated : Boolean=true) : void {
			if(animated){
				yPos += 2;
				
				TweenLite.to(_scrollContent, 0.4, {y:yPos, onUpdate:trackScrollContentPos});
			}else{
				_scrollContent.y = yPos;
				updateDragger(_scrollContent.y);
			}
		}

		private function trackScrollContentPos() : void {
			updateDragger(_scrollContent.y);
		}

		public function get scrollContent() : Sprite {
			return _scrollContent;
		}
		//
	}
}
