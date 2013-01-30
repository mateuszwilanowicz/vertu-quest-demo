package com.groovytrain.vertu.quest.modules {
	import com.groovytrain.vertu.quest.controllers.AppController;
	import gs.TweenLite;
	import gs.easing.Quart;

	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.models.ModuleModel;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;
	import com.groovytrain.vertu.quest.views.AbstractView;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AbstractModule extends AbstractView implements IModule {
		
		protected var _contentMc:MovieClip;		protected var _closeBtn:MovieClip;		protected var _type:String;
		protected var _popupContent : MovieClip;
		
		public function AbstractModule() {
			
		}

		public function injectDataModel(moduleModel : ModuleModel) : void {
			// to be overriden
		}
		
		public function get contentMc() : MovieClip {
			return _contentMc;
		}
		
		public function set contentMc(contentMc : MovieClip) : void {
			_contentMc = contentMc;
			
			var cb : MovieClip = MovieClip(new AssetsManager.CLOSE_BUTTON());
			cb.name = "closeButton";
		
			_contentMc.addChild(cb);
			
			cb.gotoAndStop(AppController.getInstance().language);
			
			_closeBtn = cb;
			
			ButtonInjector.injectButtonDefaults(_closeBtn);
			
			_closeBtn.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler);
			_closeBtn.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler);
			_closeBtn.addEventListener(MouseEvent.CLICK, closeClickedHandler);
		}

		private function closeOutHandler(event : MouseEvent) : void {
			TweenLite.to(_closeBtn.getChildByName("closeText"), .5 , { tint: null, ease: Quart.easeOut });		
		}

		private function closeOverHandler(event : MouseEvent) : void {
			TweenLite.to(_closeBtn.getChildByName("closeText"), .5 , { tint: 0xFFFFFF, ease: Quart.easeOut });
		}
		
		private function closeClickedHandler(event : MouseEvent) : void {
			var mEvent : ModuleEvent = new ModuleEvent(ModuleEvent.CLOSE_CLICKED);
			dispatchEvent(mEvent);
		}
		
		override public function scaleAndReposition():void {
			
		}
		
		public function close() : void {
			var mEvent : ModuleEvent = new ModuleEvent(ModuleEvent.CLOSE_CLICKED);
			dispatchEvent(mEvent);			
		}

		public function reveal() : void {
			TweenLite.to(this, 1 , { alpha: 1, ease: Quart.easeOut });	
		}
		
		public function getDimention():Object {
			return null;
		}
		
		public function get type() : String {
			return _type;
		}

		public function get popupContent() : MovieClip {
			return _popupContent;
		}

		public function set popupContent(popupContent : MovieClip) : void {
			_popupContent = popupContent;
		}
		
	}
}
