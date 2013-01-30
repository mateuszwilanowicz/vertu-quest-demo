package com.groovytrain.vertu.quest.controllers {
	import gs.TweenLite;
	import gs.easing.Quart;

	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.models.ModuleModel;
	import com.groovytrain.vertu.quest.modules.AbstractModule;
	import com.groovytrain.vertu.quest.modules.CopyModule;
	import com.groovytrain.vertu.quest.modules.CopyModule2;
	import com.groovytrain.vertu.quest.modules.CopyModule3;
	import com.groovytrain.vertu.quest.modules.ModuleTypes;
	import com.groovytrain.vertu.quest.modules.VideoModule;
	import com.groovytrain.vertu.quest.utils.FontFactory;
	import com.groovytrain.vertu.quest.views.ViewOrientation;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ModuleController extends AbstractViewController {
		private var _moduleModel : ModuleModel;
		private var _module : AbstractModule;
		private var _hiResFrame : MovieClip;
		private var _popupContent : MovieClip;
		private static var _instance : ModuleController;
		private static var _origWidth : Number = 970;		private static var _origHeight : Number = 570;
		
		//test

		private static function hidden() : void {
			
		}

		public static function getInstance() : ModuleController {
			if( _instance == null ) {
				_instance = new ModuleController(hidden);
			}
			return _instance;
		}

		public function ModuleController(h : Function) {
			if (h !== hidden) {
				throw new Error("ModuleController and can only be accessed through ModuleController.getInstance()");
			} else {
				init();
			}
		}

		private function init() : void {
			// if(!AppController.getInstance().base.stage.hasEventListener(Event.RESIZE)){
			// AppController.getInstance().base.stage.addEventListener(Event.RESIZE, repositionHandler);
			// }
		}

		public function loadModule(modModel : ModuleModel) : void {
//			trace("_module:" + _module);
			view.visible = true;
			view.alpha = 1;

			if(_module != null && view.contains(_module)) {
				if(_module.type == "video") {
					var vm:VideoModule = _module as VideoModule;
					vm.closeClickedHandler();	
				}
				view.removeChild(_module);
			}
			view.orientation = ViewOrientation.FULL_SCREEN;
			
			_moduleModel = modModel;

			if(_moduleModel.type == ModuleTypes.VIDEO) {
				_module = new VideoModule();
			} else if(_moduleModel.type == ModuleTypes.COPY_1 ) {
				_module = new CopyModule();
			} else if (_moduleModel.type == ModuleTypes.COPY_2 ) {
				_module = new CopyModule2();
			} else if (_moduleModel.type == ModuleTypes.COPY_3 ) {
				_module = new CopyModule3();
			}

			var swfDirectory : String = AppController.getInstance().configModel.getValueByKey("baseDirectory");
			swfDirectory += AppController.getInstance().configModel.getValueByKey("swfDirectory");

			var moduleSwfPath : String = swfDirectory + _moduleModel.type + "Module.swf";
			LoadManager.getInstance().addItemToLoadQueue(moduleSwfPath, swfLoadedHandler);

//			trace("LOADING::" + moduleSwfPath);
			_module.addEventListener(ModuleEvent.CLOSE_CLICKED, closeBtnClickedHandlerAddress);
			_module.addEventListener(ModuleEvent.POPUP_CLICKED, contentPopupClickedHandler);
			
		}

		private function closeBtnClickedHandlerAddress(event : ModuleEvent) : void {
//			trace("moduleModel.id: " + _moduleModel.id);
//			AppController.getInstance().closeLevelThree();			AppController.getInstance().closeLevelTwo();
		}

		private function loadPopupContent():void {
			var swfDirectory : String = AppController.getInstance().configModel.getValueByKey("baseDirectory");
			swfDirectory += AppController.getInstance().configModel.getValueByKey("swfDirectory");

			var contentSwfPath : String = swfDirectory + "module3.swf";
			LoadManager.getInstance().addItemToLoadQueue(contentSwfPath, popupContentLoadedHandler);
			
		}

		private function popupContentLoadedHandler(event : Event) : void {
			var info : LoaderInfo = LoaderInfo(event.target);
			info.loader.removeEventListener(IOErrorEvent.IO_ERROR, swfErrorHandler);
			info.loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, swfErrorHandler);
			info.loader.removeEventListener(Event.COMPLETE, popupContentLoadedHandler);
			
			_popupContent = info.content as MovieClip;
			_popupContent.alpha = 0;

			var tf:TextField = _popupContent.popupContent.titleTextField as TextField; 			var ct:TextField = _popupContent.popupContent.copyTextField as TextField; 
				

			var ctf : TextFormat = new TextFormat();
			ctf.letterSpacing = 3;
			var ccf : TextFormat = new TextFormat();
			ccf.letterSpacing = 0.2;
			ccf.leading = 7;

			tf.embedFonts = true;
			ct.embedFonts = true;
			
			tf.defaultTextFormat = ctf;
			ct.defaultTextFormat = ccf;
			
			tf.htmlText = _moduleModel.title;
			ct.htmlText = _moduleModel.copy;
			
			FontFactory.updateText(ct, _moduleModel.copy);
			FontFactory.updateText(tf, _moduleModel.title, "title");

			ct.y = tf.y + tf.textHeight + 10;			
			
			_popupContent.popupContent.textBg.height = 37 + ct.textHeight + tf.textHeight + 40;
			
			
			if(_moduleModel.showPopup) { 
				contentPopupClickedHandler(); 
			} else {
				TweenLite.to(_popupContent, 0.5, {alpha:0, onComplete:removepopupContent});
			}

		}

		public override function reposition() : void {
//			trace("ModuleController : reposition");
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			var theStageWidth:Number = theStage.stageWidth;
			var theStageHeight:Number = theStage.stageHeight;
			
			_module.scaleAndReposition();
		}

		public function doCloseButtonClick():void {
			closeBtnClickedHandler();
		}

		private function closeBtnClickedHandler(event : ModuleEvent = null) : void {
			trace("closeBtnClickedHandler: Tween on complete: hideModule()");
			TweenLite.to(_module, AppController.TWEEN_OUT_TIME, {alpha:0, ease:Quart.easeOut, onComplete:hideModule});
		}

		private function contentPopupClickedHandler(event : ModuleEvent = null) : void {
			if(_moduleModel.type == ModuleTypes.VIDEO) {
				if(_popupContent) {
					if(_module.contentMc) {
						if(_module.contentMc.contains(_popupContent)) {
							_module.popupContent = null;
							TweenLite.to(_popupContent, 0.5, {alpha:0, onComplete:removepopupContent});
							TweenLite.to(_module.contentMc.popupButton, 0.5, {alpha:0 });
							
						} else {
							_module.contentMc.popupButton.gotoAndStop(2);
							_module.contentMc.popupButton.hide.gotoAndStop(AppController.getInstance().language);
							_popupContent.alpha = 0;
							_module.popupContent = _popupContent;
							_module.contentMc.addChild(_popupContent);
							_module.scaleAndReposition();
							TweenLite.to(_popupContent, 1, {alpha:1});
							
							_module.scaleAndReposition();
						}
					}
				}
			}
		}

		private function removepopupContent() : void {
			try {
				_module.scaleAndReposition();
				_module.contentMc.popupButton.gotoAndStop(1);
				_module.contentMc.popupButton.readMore.gotoAndStop(AppController.getInstance().language);
				_module.contentMc.removeChild(_popupContent);
				TweenLite.to(_module.contentMc.popupButton, 0.5, {alpha:1 });
				
			} catch(e : Error) {
				trace(e.message);
			}
		}

		private function hideModule() : void {
			trace("hideModule: dispatchEvent: ModuleEvent.HIDE_MODULE");
			_module.dispatchEvent(new ModuleEvent(ModuleEvent.HIDE_MODULE));
			_module.alpha = 1;
			_module.hide();
		}

		private function swfErrorHandler(event : ErrorEvent) : void {
			trace("ERROR:" + event.type + ":" + event.text);
		}

		private function swfLoadedHandler(event : Event) : void {
			var info : LoaderInfo = LoaderInfo(event.target);
			info.loader.removeEventListener(IOErrorEvent.IO_ERROR, swfErrorHandler);
			info.loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, swfErrorHandler);
			info.loader.removeEventListener(Event.COMPLETE, swfLoadedHandler);

			_module.contentMc = info.content as MovieClip;
			_module.injectDataModel(_moduleModel);

//			_module.contentMc.alpha = 0;
//			TweenLite.to(_module.contentMc, AppController.FADE_TIME, {alpha:1, ease:Quart.easeOut,});

			_module.reveal();			
					
			view.orientation = ViewOrientation.FULL_SCREEN;
			view.addChild(_module);

			loadPopupContent();
		}

		public function get hiResFrame() : MovieClip {
			return _hiResFrame;
		}

		public function set hiResFrame(hiResFrame : MovieClip) : void {
			_hiResFrame = hiResFrame;
		}

		public function get popupContent() : MovieClip {
			return _popupContent;
		}
	}
}

