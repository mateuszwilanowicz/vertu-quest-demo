package com.groovytrain.vertu.quest.components.contentswfs {
	import gs.TweenLite;
	import gs.easing.Quart;

	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author mateuszw
	 */
	public class GalleryScroller extends MovieClip implements IGalleryScrollerView {
		
		private var _minY						:Number;
		private var _maxY						:Number;
		//
		private var _scrollContent				:Sprite;
		private var _scrollMask					:Sprite;
		private var _upArrow					:Sprite;
		private var _dnArrow					:Sprite;
		private var _track						:Sprite;
		private var _dragger 					: Sprite;
		
		private var _draggerMin					: Number = 0;
		private var _draggerMax					: Number = 0;
		
		private var _scrollDirection 			: Number = 0;
		private var _scrollMagnitude 			: Number = 10;
		
		private var _phones 					: Array;
		
		public function GalleryScroller() {
			init();
		}

		private function init() : void {
			_phones = new Array();
			_scrollContent = getChildByName("scrollContentSprite") as Sprite;
			_scrollMask = getChildByName("scrollMaskSprite") as Sprite;	
			_scrollContent.mask = _scrollMask;
			
						
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
			
			
			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerDownHandler);
			
			_scrollContent.mask = _scrollMask;
			
			_phones.push(_scrollContent.getChildByName("p1"));			_phones.push(_scrollContent.getChildByName("p2"));			_phones.push(_scrollContent.getChildByName("p3"));			_phones.push(_scrollContent.getChildByName("p4"));			_phones.push(_scrollContent.getChildByName("p5"));			_phones.push(_scrollContent.getChildByName("p6"));			
			_scrollContent.getChildByName("p1").addEventListener(MouseEvent.MOUSE_OVER, phoneMouseOver);
			_scrollContent.getChildByName("p1").addEventListener(MouseEvent.MOUSE_OUT, phoneMouseOut);
			_scrollContent.getChildByName("p2").addEventListener(MouseEvent.MOUSE_OVER, phoneMouseOver);
			_scrollContent.getChildByName("p2").addEventListener(MouseEvent.MOUSE_OUT, phoneMouseOut);
			_scrollContent.getChildByName("p3").addEventListener(MouseEvent.MOUSE_OVER, phoneMouseOver);
			_scrollContent.getChildByName("p3").addEventListener(MouseEvent.MOUSE_OUT, phoneMouseOut);
			_scrollContent.getChildByName("p4").addEventListener(MouseEvent.MOUSE_OVER, phoneMouseOver);
			_scrollContent.getChildByName("p4").addEventListener(MouseEvent.MOUSE_OUT, phoneMouseOut);
			_scrollContent.getChildByName("p5").addEventListener(MouseEvent.MOUSE_OVER, phoneMouseOver);
			_scrollContent.getChildByName("p5").addEventListener(MouseEvent.MOUSE_OUT, phoneMouseOut);
			_scrollContent.getChildByName("p6").addEventListener(MouseEvent.MOUSE_OVER, phoneMouseOver);
			_scrollContent.getChildByName("p6").addEventListener(MouseEvent.MOUSE_OUT, phoneMouseOut);

			_scrollContent.y = 1200;
			
			
			_upArrow.alpha = 0;
			_dnArrow.alpha = 0;
		}
		
		private function showArrows():void {
			
			TweenLite.to(_dnArrow, .5, { alpha: 0.5 });
			
			_upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upDownHandler);
			_dnArrow.addEventListener(MouseEvent.MOUSE_DOWN, dnDownHandler);
			
			_upArrow.addEventListener(MouseEvent.MOUSE_OVER, upOverHandler);
			_dnArrow.addEventListener(MouseEvent.MOUSE_OVER, dnOverHandler);
			
			_upArrow.addEventListener(MouseEvent.MOUSE_OUT, upDnMouseUpHandler);
			_dnArrow.addEventListener(MouseEvent.MOUSE_OUT, upDnMouseUpHandler);
			
			
			
			
		}

		private function phoneMouseOut(event : MouseEvent) : void {
			var d:Sprite = Sprite(event.target).getChildByName("desc") as Sprite;
			TweenLite.to(d, .5, { alpha: 0, ease: Quart.easeOut });
			for (var i : int = 0; i < _phones.length ; i++ ) {
				TweenLite.to(_phones[i],1.5,{ alpha:1, ease: Quart.easeOut} );					 
			}
			
		}

		private function phoneMouseOver(event : MouseEvent) : void {
			var d:Sprite = Sprite(event.target).getChildByName("desc") as Sprite;
			TweenLite.to(d, .5, {alpha:1, ease:Quart.easeOut});
			for (var i : int = 0; i < _phones.length ; i++ ) {
				if(event.target != _phones[i]) {
					TweenLite.to(_phones[i],1.5,{ alpha:0.1, ease: Quart.easeOut} );					 
				}
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
			TweenLite.to(_dnArrow, .5 , { alpha: .5, ease:Quart.easeOut } );
			TweenLite.to(_upArrow, .5 , { alpha: .5, ease:Quart.easeOut } );
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
		
		private function upOverHandler(event : MouseEvent) : void {
			trace("upOverHandler");
			TweenLite.to(_upArrow, .5 , { alpha: 1, ease:Quart.easeOut } );
			_scrollDirection = 1;
			addEventListener(Event.ENTER_FRAME, arrowTrackingHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, upDnMouseUpHandler);
		}

		private function dnOverHandler(event : MouseEvent) : void {
			TweenLite.to(_dnArrow, .5, {alpha:1, ease:Quart.easeOut});
			trace("dnOverHandler");
			_scrollDirection = -1;
			addEventListener(Event.ENTER_FRAME, arrowTrackingHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, upDnMouseUpHandler);
		}
		
		private function arrowTrackingHandler(event : Event) : void {
			var yPos : Number = _scrollContent.y + (_scrollDirection*_scrollMagnitude);

			if(yPos > _maxY){
				yPos = _maxY;
				_upArrow.visible = false;
			}else if(yPos< _minY){
				yPos = _minY;
				_dnArrow.visible = false;
			} else {
				_upArrow.visible = true;
				_dnArrow.visible = true;
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

		public function scrollOff(posY:Number=1200) : void {
			_upArrow.removeEventListener(MouseEvent.MOUSE_DOWN, upDownHandler);
			_dnArrow.removeEventListener(MouseEvent.MOUSE_DOWN, dnDownHandler);
			
			_upArrow.removeEventListener(MouseEvent.MOUSE_OVER, upOverHandler);
			_dnArrow.removeEventListener(MouseEvent.MOUSE_OVER, dnOverHandler);
			
			_upArrow.removeEventListener(MouseEvent.MOUSE_OUT, upDnMouseUpHandler);
			_dnArrow.removeEventListener(MouseEvent.MOUSE_OUT, upDnMouseUpHandler);	
		
			_upArrow.alpha = 0;
			_dnArrow.alpha = 0;
		
			_scrollContent.y = posY;
		}
		
		public function scrollToTop(animated : Boolean=true , time : Number = 0.4) : void {
			
			if (animated) {
				_scrollContent.y = 1200;
				TweenLite.to(_dnArrow, time, {alpha:.5, ease:Quart.easeOut, delay:2 });
				TweenLite.to(_scrollContent, time, {y:_maxY, onUpdate:trackScrollContentPos,ease:Quart.easeOut, onComplete:showArrows});
			}else{
				_scrollContent.y = _maxY;
				updateDragger(_scrollContent.y);
			}
		}
		
		public function scrollToTo(yPos:Number, animated : Boolean=true) : void {
			if(animated){
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
