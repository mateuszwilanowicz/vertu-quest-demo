package com.groovytrain.vertu.quest.modules {
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.controllers.FooterViewController;
	import com.groovytrain.vertu.quest.controllers.ModuleController;
	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.models.CopyModuleModel;
	import com.groovytrain.vertu.quest.models.ModuleModel;
	import com.groovytrain.vertu.quest.utils.FontFactory;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	// import com.groovytrain.vertu.quest.controllers.GlobeController;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class CopyModule2 extends AbstractModule {

		private var _model : CopyModuleModel;
		private var _copyBg : Sprite;
		private var _blackBg : Sprite;
		private var _bitmap: Bitmap;
		
		private var _imageOrginalWidth : Number;

		public function CopyModule2() {
			super();
		}

		override public function injectDataModel(moduleModel : ModuleModel) : void {
			
			
			addChild(_contentMc);
			

			
			_model = moduleModel as CopyModuleModel;
//			
//			trace("injectDataModel::::: COPYMODULE 2 :::::::::::");
//			trace('_model.imagePath: ' + (_model.imagePath));
//			trace('_model.copy: ' + (_model.copy)); 
			
			var titlePlaceholder : TextField = _contentMc.getChildByName("titleTextField") as TextField;
			var textBg : Sprite = _contentMc.getChildByName("textBg") as Sprite;

			_titleTf = titlePlaceholder;
			_copyTf = copyPlaceholder;
			_copyTf.embedFonts = true;
			_copyBg = textBg;
			
			_imageSprite = _contentMc.getChildByName("imageClip") as Sprite;
			_imageOrginalWidth = 980;
			_imageOrginalHeight = 644;
			
			_blackBg = _contentMc.getChildByName("blackBg") as Sprite;
			
			var ctf : TextFormat = new TextFormat();
			ctf.letterSpacing = 3;
			
			var ccf : TextFormat = new TextFormat();
			ccf.letterSpacing = 0.2;
			ccf.leading = 7;

			titlePlaceholder.defaultTextFormat = ctf;
			copyPlaceholder.defaultTextFormat = ccf;
			
			titlePlaceholder.embedFonts = true;
			copyPlaceholder.embedFonts = true;
			
			titlePlaceholder.htmlText = _model.title;
			copyPlaceholder.htmlText = _model.copy;
			
			FontFactory.updateText(copyPlaceholder, _model.copy);
			FontFactory.updateText(titlePlaceholder, _model.title, "title");

			textBg.height = 50 + copyPlaceholder.textHeight + titlePlaceholder.textHeight;			
			
			addEventListener(ModuleEvent.CLOSE_CLICKED, closeBtnClickedHandlerAddress);
			addEventListener(ModuleEvent.HIDE_MODULE, hideModuleHandler);
			
			loadImage();
		}

		private function closeBtnClickedHandlerAddress(event : ModuleEvent) : void {
			AppController.getInstance().closeLevelTwo();
		}

		private function loadImage() : void {

			var imgDir : String = AppController.getInstance().configModel.getValueByKey("baseDirectory");
			imgDir += AppController.getInstance().configModel.getValueByKey("imageDirectory");
			
			var fullImgPath : String = imgDir + _model.imagePath;
			
			trace("LOADING THIS:"+fullImgPath);
			
			var request : URLRequest = new URLRequest(fullImgPath);
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, swfErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, swfErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.INIT, swfLoadedHandler);
			loader.load(request);
		}

		private function swfLoadedHandler(event : Event) : void {
			var info : LoaderInfo = LoaderInfo(event.target);
			info.loader.removeEventListener(IOErrorEvent.IO_ERROR, swfErrorHandler);
			info.loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, swfErrorHandler);
			info.loader.removeEventListener(Event.COMPLETE, swfLoadedHandler);
			
			while(_imageSprite.numChildren > 0){
				_imageSprite.removeChildAt(0);
			}
			
			_bitmap = info.content as Bitmap;
			_bitmap.smoothing = true;
			
			var loadedImage:Bitmap = info.content as Bitmap;

			_imageOrginalHeight = loadedImage.height;
			
			_imageSprite.addChild(info.content);
			_imageSprite.alpha = 0;
			
			TweenLite.to(_imageSprite, 1.5, {alpha:1, ease:Sine.easeOut});
			
			ModuleController.getInstance().reposition();	
			scaleAndReposition();
			show();

			addChild(_closeBtn);
		}

		private function closeClickedHandler(event : ModuleEvent) : void {
			
		}

		private function hideModuleHandler(event : ModuleEvent) : void {
			if(contains(_contentMc)) {
				removeChild(_contentMc);
//				trace("22222222222 hideModule2Handler() removeChild(_contentMc)");
			}
		}
		
		public override function scaleAndReposition():void {
			
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			var theStageWidth:Number = Number(stg.stageWidth + 0);
			var theStageHeight : Number = Number(stg.stageHeight + 0);
			var multiplyer : Number = Math.max(( theStageHeight - 67 ) / _imageOrginalHeight, theStageWidth / _imageOrginalWidth);
			
			x = 0;
			y = 0;
			
			//BLACK BACKGROUND
			_blackBg.width = theStageWidth;
			_blackBg.height = theStageHeight;


			// IMAGE
			_imageSprite.width = _imageOrginalWidth * multiplyer;
			_imageSprite.height = _imageOrginalHeight * multiplyer;
			
		
			if (_model.scaling) {
				_imageSprite.x = (theStageWidth - _imageSprite.width) / 2;
				_imageSprite.y = ((theStageHeight - 67) - _imageSprite.height) / 2;
			} else {
				_imageSprite.x = (theStageWidth - _imageSprite.width) / 2;
				_imageSprite.y = theStageHeight - 67 - _imageSprite.height;
				
			}
			
			//MAGIC HERE!
			_copyBg.x = ((_imageSprite.width - theStageWidth ) / 2 ) + 20;
			if (AppController.getInstance().language != LanguageCodes.ARABIC) {
				_copyBg.x = FooterViewController.getInstance().vertuLogo.x + FooterViewController.getInstance().view.x - 20;				
			}
			
			_copyBg.y = ((theStageHeight - 67) - _copyBg.height) / 2;
							
			_titleTf.x = _copyBg.x + 20;
			_titleTf.y = _copyBg.y + 17;
				
			_copyTf.x = _copyBg.x + 20;
			_copyTf.y = _titleTf.y + _titleTf.textHeight + 10;

			_closeBtn.y = 35;
			
			if (AppController.getInstance().language != LanguageCodes.ARABIC) {
				_closeBtn.x = theStageWidth - 47; 
			} else {
				_closeBtn.x = 47; 
			}
			 
		}
		
		override public function reveal():void {
			
			_imageSprite.alpha = 0;			
			_copyBg.alpha = 0;
			_titleTf.alpha = 0;
			_copyTf.alpha = 0;

			TweenLite.to(_imageSprite, .5, { alpha: 1, ease: Sine.easeInOut, delay: 0 });
			TweenLite.to(_copyBg, .5, { alpha: 1, ease: Sine.easeInOut, delay: 1 });
			TweenLite.to(_titleTf, .5, { alpha: 1, ease: Sine.easeInOut, delay: 1.2 });
			TweenLite.to(_copyTf, .5, { alpha: 1, ease: Sine.easeInOut, delay: 1.4 });
			
					
		}

		override public function getDimention():Object {
			return {width:this.width, height:this.height, x:this.x, y:this.y};
		}
		
		private function swfErrorHandler(event : ErrorEvent) : void {
			trace("ERROR:" + event.type + ":" + event.text);
		}

		
	}
}