package com.groovytrain.vertu.quest {
	import gs.TweenLite;
	import com.groovytrain.vertu.quest.events.AppEvent;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	 
	[SWF(width = "970", height = "570", backgroundColor = "#FF6565", frameRate = "30")]
	 
	
	public class LoaderMain extends Sprite {
					
		private var _loader : Loader = new Loader();
		private var _appMain : Sprite;
		private var callbackvars : Boolean = true;
		
		public function LoaderMain() {
			Security.allowDomain("*");
			init();
		}
		
		private function init() : void {
			ExternalInterface.call("flashRedirect");
			stage.scaleMode = StageScaleMode.NO_SCALE;
			trace("CCCCCCCCCCCCCCCCCCCCCCCCCCC callbackvars: "+callbackvars);
			TweenLite.delayedCall(1, afterDelay);	
			
		}
		
		private function afterDelay():void {
			var request : URLRequest = new URLRequest("appmain.swf");	
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadedHandler);
			_loader.load(request);
			
		}
		
		private function loadedHandler(event : Event) : void {
			
			event.target.removeEventListener(Event.COMPLETE, loadedHandler);
			_appMain = event.target.content as Sprite;
			_appMain.addEventListener(AppEvent.LANGUAGE_CHANGED, languageChangedHandler);
			_appMain.addEventListener(AppEvent.LANGUAGE_CHANGED_AR, languageChangedHandlerAr);
			addChild(_appMain);
		 	
		}


		private function languageChangedHandler(event : AppEvent) : void {
			trace("RRRRRRRRRRRRRRRRRRRR Reload AppMain - appmain languageChangedHandler()")
			removeChild(_appMain);
			_loader.unload();
			init();
		}
		private function languageChangedHandlerAr(event : AppEvent) : void {
			trace("ARABIC EXCEPTION!");
			removeChild(_appMain);
			_loader.unload();
			ExternalInterface.call("arabicRedirect");
		}
	}
}
