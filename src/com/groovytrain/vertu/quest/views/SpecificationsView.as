package com.groovytrain.vertu.quest.views {
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.components.contentswfs.IAnchor;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class SpecificationsView extends AbstractPageView {
		
		private var _content 						: Sprite;
		private var _triggers 						: Array;
		private var _backSprite 					: Sprite;
		private var _scrollContent 					: Sprite;		private var _scrollContentMask 				: Sprite;
		private var _title 							: TextField;
		private var _closeButton 					: Sprite;
		private var _origHeight 					: Number = 506;
		private var _origWidth 						: Number = 1094;
		private var _visible 						: Boolean;
		
		public function SpecificationsView() {
			super();
			init();
		}

		private function init() : void {
						
			_triggers = new Array();
			
			_content = new Sprite();
			_content.alpha = 0;
			
			var swfPath:String = LoadManager.getInstance().swfDirectory + AppController.getInstance().language +"/specifications.swf";
			
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
			
			_triggers.push(loadedSwf.getChildByName("trigger0") as Sprite);			_triggers.push(loadedSwf.getChildByName("trigger1") as Sprite);			_triggers.push(loadedSwf.getChildByName("trigger2") as Sprite);			_triggers.push(loadedSwf.getChildByName("trigger3") as Sprite);			_triggers.push(loadedSwf.getChildByName("trigger4") as Sprite);			_triggers.push(loadedSwf.getChildByName("trigger5") as Sprite);			_triggers.push(loadedSwf.getChildByName("trigger6") as Sprite);
			
//			_triggers.push(loadedSwf.getChildByName("trigger7") as Sprite);
			
			_title = loadedSwf.getChildByName("titleTextField") as TextField;
			_closeButton = loadedSwf.getChildByName("closeButton") as Sprite;
			scaleAndReposition();
			
			ButtonInjector.injectButtonDefaults(_closeButton);
			
			_closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler);
			_closeButton.addEventListener(MouseEvent.CLICK, closeClickedHandler);
			
			if(!_visible)reveal();
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

		public function reveal() : void {
			if(_backSprite != null) {
				_visible = true;
				alpha = 0;
				_content.alpha = 1;
				
				_scrollContent.alpha = 0;
				_title.alpha = 0;
				TweenLite.to(_title ,.5,{alpha:1, ease:Sine.easeInOut, delay:1.2 });
				TweenLite.to(_scrollContent,.5,{alpha:1, ease:Sine.easeInOut, delay:1.3 });
				
				for (var i : int = 0; i < _triggers.length; i++) {
					Sprite(_triggers[i]).dispatchEvent(new Event("RESET_HANDLERS", false, false));
					Sprite(_triggers[i]).alpha = 0;
					TweenLite.to(Sprite(_triggers[i]),.5,{alpha:1, ease:Sine.easeInOut, delay:1.5+(i*0.1),onComplete:dispatchAlphaDone, onCompleteParams:[Sprite(_triggers[i])] });
						
				}
				
				TweenLite.to(this, AppController.TWEEN_IN_TIME, {alpha:1, ease:Sine.easeOut, onComplete:revealDone, delay:AppController.TWEEN_DELAY_TIME});
				
			}
		}
		
		private function dispatchAlphaDone(s:Sprite):void {
			//s.dispatchEvent(new Event("ALPHA_DONE", false, false));
			IAnchor(s).alphaDone();
		}
		
		private function revealDone():void{
			trace("REVEAL DONE");
		}

		public function get content() : Sprite {
			return _content;
		}
		
		override public function scaleAndReposition():void {

			var stg : Stage = AppController.getInstance().base.stage as Stage;
			if(stg) {
				var theStageWidth:Number = Number(stg.stageWidth + 0);
				var theStageHeight:Number = Number(stg.stageHeight + 0);
					
				var multiplyer : Number = Math.max(( theStageHeight - 67 ) / _origHeight, theStageWidth / _origWidth);
					
				if(_backSprite != null) {
					
					
					// VIDEO
					_backSprite.width = _origWidth * multiplyer;
					_backSprite.height = _origHeight * multiplyer;
					
					x = 0;
					y = 0;
					
					
					_backSprite.y = theStageHeight - 67 - _backSprite.height;
					if (AppController.getInstance().language != LanguageCodes.ARABIC) {
						_scrollContent.x = ( theStageWidth / 2 ) + 50;
						_title.x = _scrollContent.x;
						_backSprite.x = _scrollContent.x - (_backSprite.width / 2 ) - 100;
						
					} else {
						_scrollContent.x = ( theStageWidth / 2 ) -430;
						_title.x = _scrollContent.x + 63;
						_backSprite.x = _scrollContent.x - (_backSprite.width / 2 ) - 100 + 550;
					}
					_scrollContent.y = (((theStageHeight-(67+45)) / 2 ) - ((_scrollContentMask.height / 2)-54));
	
					
					_title.y = _scrollContent.y - 54;
				
					for(var t:int=0; t<_triggers.length; t++){
						var sp : Sprite = Sprite(_triggers[t]);
						if (AppController.getInstance().language != LanguageCodes.ARABIC) {
							sp.x = _scrollContent.x - 228;
						} else {
							sp.x = _scrollContent.x + 450;
						}
						if(t ==0){
							sp.y = _scrollContent.y;
						}else{
							trace(Sprite(_triggers[t-1]).height);
							sp.y = Sprite(_triggers[t-1]).y + Sprite(_triggers[t-1]).height + 20;
						}
					}
					
					_closeButton.y = 35;
					
					if (AppController.getInstance().language != LanguageCodes.ARABIC) {
						_closeButton.x = theStageWidth - 47; 
					} else {
						_closeButton.x = 47; 
					}
				} 
			}
			
			_bg.width = theStageWidth;
			_bg.height = theStageHeight;		 
			
			_bg.x = ((970 - theStageWidth) / 2) + ((theStageWidth - _bg.width) / 2);
			_bg.y = ((570 - theStageHeight) / 2) + ((theStageHeight - _bg.height) / 2);
			
		}

		public function get triggers() : Array {
			return _triggers;
		}
	}
}
