package com.groovytrain.vertu.quest.modules {
	import com.groovytrain.vertu.quest.controllers.ModuleController;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import gs.TweenLite;
	import gs.easing.Quart;

	import com.akamai.net.AkamaiConnection;
	import com.akamai.net.AkamaiNetStream;
	import com.groovytrain.vertu.quest.components.video.IVideoControls;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.models.ModuleModel;
	import com.groovytrain.vertu.quest.models.VideoModuleModel;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import org.openvideoplayer.events.OvpEvent;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.text.TextField;
	// import com.groovytrain.vertu.quest.controllers.GlobeController;
	// import com.groovytrain.vertu.quest.controllers.ModuleController;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	 
	public class VideoModule extends AbstractModule {
		private var _model 									: VideoModuleModel;
		private var _video 									: Video;
		private var _videoMask 								: Sprite;
		private var _blackBg 								: Sprite;
		private var _popupBtn 								: Sprite;
		private var _netStream 								: AkamaiNetStream;
		private var _videoPath 								: String;
		private var _videoDuration 							: Number;
		private var _videoControls 							: IVideoControls;
		private var _videoGradient 							: Sprite;
		private var _origVideoWidth 						: Number;
		private var _origVideoHeight 						: Number;
		private var _first									: Boolean;
		private var _nc 									: AkamaiConnection
		
		private var _title									:TextField;
		private var _copy									:TextField;
		private var _overlay								:Sprite;
		
		private var hostName:String = "cp112905.edgefcs.net/ondemand";
		private var streamName : String = "intro.en_quest";
		

		public function VideoModule() {
			super();
		}

		override public function injectDataModel(moduleModel : ModuleModel) : void {
			
			_first = true;
			addChild(_contentMc);
			
			_contentMc.visible = false;
			_type = ModuleTypes.VIDEO;
			_model = moduleModel as VideoModuleModel;
			_video = _contentMc.getChildByName("videoObject") as Video;
			_video.smoothing = true;
			_blackBg = _contentMc.getChildByName("blackBg") as Sprite;
			_videoMask = _contentMc.getChildByName("videoMask") as Sprite;
			_popupBtn = _contentMc.getChildByName("popupButton") as Sprite;
			_popupBtn.addEventListener(MouseEvent.CLICK, popupBtnClickedHandler);
			ButtonInjector.injectButtonDefaults(_popupBtn);
			_videoControls = _contentMc.getChildByName("videoControls") as IVideoControls;
			Sprite(_videoControls).addEventListener("loadEndFile", loadEndFile);
			_videoGradient = _contentMc.getChildByName("videoGradient") as Sprite;

			loadVideoFile();

			addEventListener(ModuleEvent.CLOSE_CLICKED, closeClickedHandler);
			addEventListener(ModuleEvent.HIDE_MODULE, hideModuleHandler);
			
			_overlay = new Sprite();
			
//			addChild(_overlay);

//			Artist.drawRect(_overlay, 0, 0, 120, 120, 0x00FF00, 1 , 0,0,0);
		}

		public function popupBtnClickedHandler(event : MouseEvent = null) : void {
			trace(_model.id);

			var moduleEvent : ModuleEvent = new ModuleEvent(ModuleEvent.POPUP_CLICKED);
			moduleEvent.data.model = _model;
			dispatchEvent(moduleEvent);
		}


		public function closeClickedHandler(event : ModuleEvent = null) : void {
			if(_videoControls) {
				_videoControls.stopVideo();
			}
			_netStream.receiveAudio(false);
			_nc.close();
		}

		private function hideModuleHandler(event : ModuleEvent) : void {
			if(contains(_contentMc)) {
				removeChild(_contentMc);
				trace("HHHHHHHHHHH hideModuleHandler() removeChild(_contentMc)");
			}
		}
	
		private function loadEndFile(e:Event = null) : void {
			if(_model.fileToLoadOnFinish.length > 2) {
			
				trace("loadEndFile");
				var swfDirectory : String = AppController.getInstance().configModel.getValueByKey("baseDirectory");
				swfDirectory += AppController.getInstance().configModel.getValueByKey("swfDirectory");
				
				var moduleSwfPath : String = swfDirectory + _model.fileToLoadOnFinish;
				LoadManager.getInstance().addItemToLoadQueue(moduleSwfPath, swfLoadedHandler);
				trace("Load: " + moduleSwfPath + " | " + swfLoadedHandler);
			}
			
		}

		private function swfLoadedHandler(event : Event) : void {
			
			var info : LoaderInfo = LoaderInfo(event.target);
			info.loader.removeEventListener(Event.COMPLETE, swfLoadedHandler);
			
			_overlay.alpha = 0;
			
			//image/jpeg
			//application/x-shockwave-flash
			
			if(info.contentType == "image/jpeg") {
				var b:Bitmap = Bitmap(info.content);
				b.smoothing = true;
				_overlay.addChild(b);
			} else {
				_overlay.addChild(info.content);
			}
			
			addChild(_closeBtn);
			scaleAndReposition();
			TweenLite.to(_overlay, 2, { alpha: 1 , onComplete: doScaleAndReposition} );
	
		}
		
		private function doScaleAndReposition():void {
			scaleAndReposition();
			popupBtnClickedHandler();
		}

		private function loadVideoFile() : void {
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				_videoControls.gotoLang(2);
			} else {
				_videoControls.gotoLang(1);	
			}
			var videoDirectory : String = AppController.getInstance().configModel.getValueByKey("baseDirectory");
			videoDirectory += AppController.getInstance().configModel.getValueByKey("videoDirectory");
			
			// trace("NS.PLAY::" + videoDirectory + _model.videoPath);
			_nc = new AkamaiConnection();

		
			// _videoPath = videoDirectory + _model.videoPath;			 _videoPath = _model.videoPath;
			
			_nc.addEventListener("netStatus",onNetStreamStatusHandler);
			_nc.addEventListener("onEndDetected",onEndDetectedHandler);
			
			
			_nc.connect(hostName,true,true,5,true);
			
			
		}

		private function onNetConnectionStatusHandler() : void {
		}

		private function onStreamLengthHandler() : void {
		}

		private function onEndDetectedHandler() : void {
		}

		private function onNetStreamStatusHandler(event:NetStatusEvent) : void {
			trace("VVVVVVVVVVVVVVVVVV onNetStreamStatusHandler("+event.info.code+")");
			
			_nc.removeEventListener("netStatus",onNetStreamStatusHandler);
			
			switch (event.info.code) 
			{
				case "NetConnection.Connect.Rejected":
					trace("Rejected by server. Reason is "+event.info.description);
					break;
				case "NetConnection.Connect.Success":
					initNetStream();
					break;
			}
		}

		private function initNetStream() : void {
			trace("VVVVVVVVVVVVVVVVVV initNetStream()");
			
			_netStream = new AkamaiNetStream(_nc);
			
			_netStream.addEventListener(OvpEvent.NETSTREAM_METADATA, onMetaData);
			
//			_netStream.client = {};
//			_netStream.client.onMetaData = onMetaDataHandler;
//			_netStream.client.onCuePoint = onCuePointHandler;
//			_netStream.bufferTime = 5;
			
			_video.attachNetStream(_netStream);
			
			_netStream.play(_videoPath);

			_video.alpha = 1;

			_video.x = 0;
			_video.y = 0;
		}

		private function onMetaData(event:OvpEvent):void
		{
			
			trace("MMMMMMMMMMMMMMMMMMMMMMM "+ event.data.width+", "+ event.data.height);
			if(_model.audio == true) {
				SoundMixer.soundTransform = new SoundTransform(1);
			} else {
				SoundMixer.soundTransform = new SoundTransform(0);
			}
			var videoControlsSprite : Sprite = _contentMc.getChildByName("videoControls") as Sprite;
			
			_origVideoWidth = event.data.width;
			_origVideoHeight = event.data.height;
			trace("orginalHeight: " + _origVideoHeight + " | orginalWidth: " + _origVideoWidth);
			_videoDuration = event.data.duration;
			_videoControls.setData(_video, _netStream, _videoDuration, _videoPath);
			_videoControls.repeat = _model.repeat;
			_videoControls.timeLapse = _model.timeLapse;
			
			

			scaleAndReposition();
			if(_first) _contentMc.addEventListener(Event.ENTER_FRAME, initialScaleAndPositionHandler);
			if (_model.showControlls) {
				TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 1, delay: 5, ease: Quart.easeOut });
				addEventListener(MouseEvent.MOUSE_MOVE, hideOnMouseMove);
				videoControlsSprite.addEventListener(MouseEvent.MOUSE_OVER, onVideoControlsOverHandler);
				videoControlsSprite.addEventListener(MouseEvent.MOUSE_OUT, onVideoControlsOutHandler);
			} else {
				_contentMc.getChildByName("videoControls").alpha = 0;
			}
			
			_first = false;
		}

		private function onConnectHandler() : void {
		}

		public override function scaleAndReposition():void {
			
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			var theStageWidth:Number = Number(stg.stageWidth + 0);			var theStageHeight:Number = Number(stg.stageHeight + 0);
			var videoControlsSprite : Sprite = _contentMc.getChildByName("videoControls") as Sprite;
			var multiplyer : Number = Math.max(( theStageHeight - 67 ) / _origVideoHeight, theStageWidth / _origVideoWidth);
						
			x = 0;
			y = 0;
			
			// VIDEO // OVERLAY // BLACKBG
			_blackBg.width = _overlay.width = _video.width = _origVideoWidth * multiplyer;
			_blackBg.height = _overlay.height = _video.height = _origVideoHeight * multiplyer;

			_video.x = (theStageWidth - _video.width) / 2;
			_video.y = ((theStageHeight - 67) - _video.height) / 2;
			
//			_overlay.x = _video.x = (theStageWidth - _video.width) / 2;
//			_overlay.y = _video.y = ((theStageHeight - 67) - _video.height) / 2;
						
			//VIDEO CONTROLS
			videoControlsSprite.visible = _videoGradient.visible = _video.visible = _popupBtn.visible = false;
			videoControlsSprite.x = _videoGradient.x = _video.x = _closeBtn.x = _popupBtn.x = 0;
			videoControlsSprite.y = _videoGradient.y = _video.y = _popupBtn.y = 0;
			videoControlsSprite.y = theStageHeight - 100;
			videoControlsSprite.x = ((theStageWidth - videoControlsSprite.width) / 2 ) + 100;
			videoControlsSprite.visible = _videoGradient.visible = _video.visible = _popupBtn.visible = true;
						
			//GRADIENT
			_videoGradient.width = theStageWidth;
			_videoGradient.x = 0;
			_videoGradient.y = _video.y + _video.height - _videoGradient.height + 5;
			
			//POPUP CONTENT
			if(popupContent) {
				
				_copy = popupContent.popupContent.getChildByName("copyTextField") as TextField;				_title = popupContent.popupContent.getChildByName("titleTextField") as TextField;				_bg = popupContent.popupContent.getChildByName("textBg") as Sprite;
				
				_contentMc.addChild(_overlay);
				_contentMc.addChild(popupContent);
				_contentMc.addChild(videoControlsSprite);
				_contentMc.addChild(_popupBtn);
				
				_bg.y = ((theStageHeight - 67) - _bg.height) / 2;
								
				_title.x = _bg.x + 20;
				_title.y = _bg.y + 17;
					
				_copy.x = _bg.x + 20;
				_copy.y = _title.y + _title.textHeight + 10;
				
				_popupBtn.y = popupContent.y + _bg.y + _bg.height - 35;
				
				if (AppController.getInstance().language != LanguageCodes.ARABIC) {
					popupContent.x = theStageWidth - popupContent.width - 25;
					_popupBtn.x = theStageWidth - _popupBtn.width - 30;
				} else {
					popupContent.x = theStageWidth - popupContent.width - 25;
					_popupBtn.x = theStageWidth - _popupBtn.width - 30;
//					popupContent.x = 30;
//					_popupBtn.x = -30;
				}
				
			} else {
				
				_popupBtn.x = theStageWidth - _popupBtn.width - 30;				if (AppController.getInstance().language != LanguageCodes.ARABIC) {
					if(theStageWidth - _popupBtn.width - 30 < videoControlsSprite.x + videoControlsSprite.width  ) {
						_popupBtn.x = videoControlsSprite.x + videoControlsSprite.width;
					} else {
						_popupBtn.x = theStageWidth - _popupBtn.width - 30;
					}
				} else {
					if(theStageWidth - _popupBtn.width - 30 < videoControlsSprite.x + videoControlsSprite.width  ) {
						_popupBtn.x = videoControlsSprite.x + videoControlsSprite.width;
					} else {
						_popupBtn.x = theStageWidth - _popupBtn.width - 30;
					}
//					_popupBtn.x = -30;
				}
				_popupBtn.y = theStageHeight - 100;
				
			}
			_closeBtn.y = 35;
			
			if (AppController.getInstance().language != LanguageCodes.ARABIC) {
				_closeBtn.x = theStageWidth - 47; 
			} else {
				_closeBtn.x = 47; 
			} 
			 
		}

		private function onMetaDataHandler(item : Object) : void {
			SoundMixer.soundTransform = new SoundTransform(1);
			var videoControlsSprite : Sprite = _contentMc.getChildByName("videoControls") as Sprite;
			
			_origVideoWidth = item.width;
			_origVideoHeight = item.height;
			trace("orginalHeight: " + _origVideoHeight + " | orginalWidth: " + _origVideoWidth);
			_videoDuration = item.duration;
			_videoControls.setData(_video, _netStream, _videoDuration, _videoPath);
			_videoControls.repeat = _model.repeat;
			_videoControls.timeLapse = _model.timeLapse;
			
			

			scaleAndReposition();
			if(_first) _contentMc.addEventListener(Event.ENTER_FRAME, initialScaleAndPositionHandler);
			if (_model.showControlls) {
				TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 1, delay: 5, ease: Quart.easeOut });
				addEventListener(MouseEvent.MOUSE_MOVE, hideOnMouseMove);
				videoControlsSprite.addEventListener(MouseEvent.MOUSE_OVER, onVideoControlsOverHandler);
				videoControlsSprite.addEventListener(MouseEvent.MOUSE_OUT, onVideoControlsOutHandler);
			} else {
				_contentMc.getChildByName("videoControls").alpha = 0;
			}
			
			_first = false;
		}

		private function onVideoControlsOutHandler(event : MouseEvent) : void {
			TweenLite.killTweensOf(_contentMc.getChildByName("videoControls"));
			TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 0, delay: 1, ease: Quart.easeOut });
		}

		private function onVideoControlsOverHandler(event : MouseEvent) : void {
			TweenLite.killTweensOf(_contentMc.getChildByName("videoControls"));
			TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 1, delay: 0, ease: Quart.easeOut });			
		}

		private function videoOnMouseOut(event : MouseEvent) : void {
			TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 0, delay: 0, ease: Quart.easeOut });			
		}

		private function hideOnMouseMove(event : MouseEvent) : void {
			removeEventListener(MouseEvent.MOUSE_MOVE, hideOnMouseMove);
			TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 0, delay: 1, ease: Quart.easeOut, onComplete: newMouseMove });
		}
		
		private function newMouseMove() : void {
//			addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			
		}

		private function onMouseMoveHandler(event : MouseEvent) : void {
			removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveHandler);
			TweenLite.to(_contentMc.getChildByName("videoControls"), .5 , { alpha: 1, delay: 0, ease: Quart.easeOut, onComplete: reasignMouseMovehandler });	
		}
		
		private function reasignMouseMovehandler() : void {
			addEventListener(MouseEvent.MOUSE_MOVE, hideOnMouseMove);
		}
		

		private function initialScaleAndPositionHandler(event : Event) : void {
			_first = false;
			_contentMc.removeEventListener(Event.ENTER_FRAME, initialScaleAndPositionHandler);
			scaleAndReposition();
			_contentMc.visible = true;
			show();
			TweenLite.to(_video, .5, { alpha: 1});
		}

		private function onCuePointHandler(item : Object) : void {
			trace("cuePoint");
			trace(item.name + "\t" + item.time);
		}

		public function get popupBtn() : Sprite {
			return _popupBtn;
		}
	}
}
