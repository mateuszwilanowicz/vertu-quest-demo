package com.groovytrain.vertu.quest.views {
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.utils.Artist;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * @author mateuszw
	 */
	public class CollectionView extends AbstractView {
		
		private var _content 						: MovieClip;		private var _contentMovie					: MovieClip;
		private var _backSprite 					: Sprite;
		private var _scrollContent 					: Sprite;
		private var _scrollContentMask 				: Sprite;
		private var _closeButton 					: Sprite;
		private var _origHeight 					: Number = 570;
		private var _origWidth 						: Number = 970;
		
		public function CollectionView() {
			super();
			init();
		}

		private function init() : void {
			
			_content = new MovieClip();
			Artist.drawRect(_content, 0, 0, 970, 570, 0x000000, 0, 0, 0, 0);
			_content.alpha = 0;
			
			var swfPath:String = LoadManager.getInstance().swfDirectory + "collection.swf";
			
			LoadManager.getInstance().addItemToLoadQueue(swfPath, swfLoadedHandler);
			addChild(_content);
			
		}
		
		private function swfLoadedHandler(event:Event):void{
			_contentMovie =  LoaderInfo(event.target).content as MovieClip;
			_content.addChild(_contentMovie);
			_backSprite = _contentMovie.getChildByName("backSprite") as Sprite;
			reveal();
		}

		private function closeOutHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5 , { scaleX: 1, scaleY: 1, ease: Quart.easeOut });		
		}

		private function closeOverHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5 , { scaleX: 1.2, scaleY: 1.2, ease: Quart.easeOut });
		}
		
		private function closeClickedHandler(event : MouseEvent) : void {
			var pEvent : PageEvent = new PageEvent(PageEvent.CLOSE_CLICKED);
			dispatchEvent(pEvent);
		}

		public function reveal() : void {
			if(_contentMovie) {
				alpha = 1;
				_content.alpha = 1;
				_contentMovie.gotoAndPlay(2);
			}
			
		}
		
		override public function scaleAndReposition():void {
			
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			if(stg) {
				var theStageWidth:Number = Number(stg.stageWidth + 0);
				var theStageHeight:Number = Number(stg.stageHeight + 0);
				var multiplyer : Number = Math.min(( theStageHeight - 67 ) / 570, theStageWidth / 970);
	
				x = (theStageWidth - 970) / 2;
				y = (theStageHeight + 67 - 570) / 2;
				
				_bg.width = theStageWidth;
				_bg.height = theStageHeight;		 
				
				_bg.x = ((970 - theStageWidth) / 2) + ((theStageWidth - _bg.width) / 2);
				_bg.y = ((570 - theStageHeight) / 2) + ((theStageHeight - _bg.height) / 2);
			}
		}
		
		private function revealDone():void{
			trace("REVEAL DONE");
		}

		public function get content() : Sprite {
			return _content;
		}
	}
}
