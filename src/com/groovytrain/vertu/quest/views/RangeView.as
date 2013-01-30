package com.groovytrain.vertu.quest.views {
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.components.contentswfs.IGalleryScrollerView;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author mateuszw
	 */
	public class RangeView extends AbstractView {
		
		private var _content 				: MovieClip;
		private var _backSprite 			: Sprite;
		private var _scrollContent 			: Sprite;		private var _scrollContentMask		: Sprite;
		private var _closeButton			: Sprite;
		private var _origHeight				: Number = 570;
		private var _origWidth				: Number = 970;
		private var _gallery				: IGalleryScrollerView;
		

		
		public function RangeView() {
			super();
			init();
		}

		private function init() : void {
			
						
			_content = new MovieClip();
			Artist.drawRect(_content, 0, 0, 970, 570, 0x000000, 0, 0, 0, 0);
			_content.alpha = 0;
			
			var swfPath:String =  LoadManager.getInstance().swfDirectory + AppController.getInstance().language +"/range.swf";
			
			LoadManager.getInstance().addItemToLoadQueue(swfPath, swfLoadedHandler);
			
			addChild(_content);
			
		}
		
		private function swfLoadedHandler(event:Event):void{
			
			var loadedSwf : Sprite = LoaderInfo(event.target).content as Sprite;

			var cb : MovieClip = MovieClip(new AssetsManager.CLOSE_BUTTON());
			cb.name = "closeButton";
			cb.gotoAndStop(AppController.getInstance().language);
			
			loadedSwf.addChild(cb);
			
			_content.addChild(loadedSwf);

			_backSprite = loadedSwf.getChildByName("backSprite") as Sprite;
			_scrollContent = loadedSwf.getChildByName("scrollContent") as Sprite;			_scrollContentMask = _scrollContent.getChildByName("scrollMaskSprite") as Sprite;

			_scrollContent.mask = _scrollContentMask;

			_closeButton = loadedSwf.getChildByName("closeButton") as Sprite;

			_gallery = loadedSwf.getChildByName("scrollContent") as IGalleryScrollerView;
			
			scaleAndReposition();
			
			ButtonInjector.injectButtonDefaults(_closeButton);
			
			_closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler);
			_closeButton.addEventListener(MouseEvent.CLICK, closeClickedHandler);
		}

		private function closeClickedHandler(event : MouseEvent) : void {
			AppController.getInstance().closeLevelTwo();
//			var mEvent : ModuleEvent = new ModuleEvent(ModuleEvent.CLOSE_CLICKED);
//			dispatchEvent(mEvent);
		}
		private function closeOutHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5 , { tint: null, ease: Quart.easeOut });		
		}

		private function closeOverHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5 , { tint: 0xFFFFFF, ease: Quart.easeOut });
		}
		
		override public function putAway() : void {
			dispatchEvent(new ViewEvent(ViewEvent.PUTTING_AWAY_VIEW));
			TweenLite.to(this, AppController.TWEEN_OUT_TIME, {alpha:0, ease:Sine.easeOut, onComplete:hide});
		}
		override public function hide():void {
			dispatchEvent(new ViewEvent(ViewEvent.HIDDEN));
			visible = false;
			if(_gallery) {
				_gallery.scrollOff(1200);
			}
			
		}

		public function reveal() : void {
			alpha = 0;
			_content.alpha = 1;
			if(_gallery) {
				_gallery.scrollOff(1200);
			}
			TweenLite.to(this, AppController.TWEEN_IN_TIME, {alpha:1, ease:Sine.easeOut, onComplete:revealDone, delay:AppController.TWEEN_DELAY_TIME});
			
		}
		
		override public function scaleAndReposition():void {
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			if(stg) {
				var theStageWidth:Number = Number(stg.stageWidth + 0);
				var theStageHeight:Number = Number(stg.stageHeight + 0);
				
				var multiplyer : Number = Math.max( theStageHeight  / _origHeight, theStageWidth / _origWidth);
				
				if(_backSprite != null) {
					
					_backSprite.width = _origWidth * multiplyer;
					_backSprite.height = _origHeight * multiplyer;
					
					x = 0;
					y = 0;
					
					_backSprite.x = (theStageWidth - _backSprite.width) / 2;
					_backSprite.y = (theStageHeight  - _backSprite.height) / 2;
	
					_scrollContent.x = (theStageWidth - _origWidth) / 2;
					_scrollContent.y = (theStageHeight - _origHeight) / 2;
	
					if (AppController.getInstance().language != LanguageCodes.ARABIC) {
						_closeButton.x = theStageWidth - 47; 
					} else {
						_closeButton.x = 47; 
					}
					_closeButton.y = 35;
					
					 
				}	
				
				_bg.width = theStageWidth;
				_bg.height = theStageHeight;		 
				
				_bg.x = ((970 - theStageWidth) / 2) + ((theStageWidth - _bg.width) / 2);
				_bg.y = ((570 - theStageHeight) / 2) + ((theStageHeight - _bg.height) / 2);
			}
		}
		
		private function revealDone() : void {
			trace("RRRRRRRRRRRR revealDone()");
			
			_gallery.scrollToTop(true,3);
			
//			if (_scrollContentSprite) {
//				_scrollContentSprite.y = 1200;
//				TweenLite.to(_scrollContentSprite, AppController.TWEEN_IN_TIME * 2, {y:226, ease:Quart.easeOut });	
//			}
		}

		public function get content() : Sprite {
			return _content;
		}
	}
}
