package com.groovytrain.vertu.quest.views {
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Sine;

	import com.akamai.net.AkamaiConnection;
	import com.akamai.net.AkamaiNetStream;
	import com.asual.swfaddress.SWFAddress;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.components.video.IVideoControls;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.controllers.LoaderController;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.generic.ResourceType;
	import com.groovytrain.vertu.quest.loadManager.Item;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.models.VideoModuleModel;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import org.openvideoplayer.events.OvpEvent;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;
	import flash.media.Video;
	
	/**
	 * @author mateuszw
	 */
	public class BgView extends AbstractView {
		 

		private var _content 						: Video;		private var _video	 						: MovieClip;
		private var _closeButton 					: Sprite;
		private var _origHeight 					: Number = 546;
		private var _origWidth 						: Number = 970;
		private var _model 									: VideoModuleModel;
		
		
		
		
		private var _netStream 								: AkamaiNetStream;
		private var _videoPath 								: String;
		private var _videoDuration 							: Number;
		private var _videoControls 							: IVideoControls;
		
		private var _origVideoWidth 						: Number;
		private var _origVideoHeight 						: Number;
		private var _first									: Boolean;
		private var _nc 									: AkamaiConnection;
		
				
		private var hostName:String = "cp112905.edgefcs.net/ondemand";
		private var streamName : String = "intro.en_quest";
		
		
		private var _skipIntro						: MovieClip;
		

		public function BgView() {
			super();
			init();
		}

		public function init():void {
			_content = new Video();
			_content.smoothing = true;
			
			_skipIntro = new AssetsManager.SKIP_INTRO() as MovieClip;
			
			_skipIntro.addEventListener(MouseEvent.CLICK , skipIntroClick );
			_skipIntro.addEventListener(MouseEvent.MOUSE_OVER , skipIntroOver );
			_skipIntro.addEventListener(MouseEvent.MOUSE_OUT , skipIntroOut );
			
			addChild(_content);
			
			addChild(_skipIntro);
			ButtonInjector.injectButtonDefaults(_skipIntro);

			_skipIntro.gotoAndStop(AppController.getInstance().language);
			
			var swfPath:String = LoadManager.getInstance().swfDirectory + AppController.getInstance().language +"/intro.swf";
//			LoadManager.getInstance().addItemToLoadQueue(swfPath, swfLoadedHandler, true);

			loadVideoFile();

			visible = true;
		}
		
		private function loadVideoFile() : void {
		
			// trace("NS.PLAY::" + videoDirectory + _model.videoPath);
			_nc = new AkamaiConnection();

		
			// _videoPath = videoDirectory + _model.videoPath;
			_videoPath = streamName;

			
			_nc.addEventListener("netStatus",onNetStreamStatusHandler);
			_nc.addEventListener("end",onEndDetectedHandler);
			
			
			_nc.connect(hostName,true,true,5,true);
			
			
		}

		private function onNetConnectionStatusHandler() : void {
		}

		private function onStreamLengthHandler() : void {
		}

		private function onEndDetectedHandler(event:OvpEvent) : void {
			trace("onEndDetectedHandler("+event+")");
			var valueStr : String = AppController.getInstance().language + "/" + ResourceType.EXPERIENCE;
			SWFAddress.setValue(AppController.getInstance().cleanSwfAddressPath(valueStr));
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

			_netStream.addEventListener(OvpEvent.COMPLETE, onEndDetectedHandler);
			_netStream.addEventListener(OvpEvent.NETSTREAM_METADATA, onMetaData);

			_content.attachNetStream(_netStream);
			
			_netStream.play(_videoPath);

			_content.alpha = 1;

			_content.x = 0;
			_content.y = 0;
		}

		private function onMetaData(event:OvpEvent):void
		{
			
			trace("MMMMMMMMMMMMMMMMMMMMMMM "+ event.data.width+", "+ event.data.height);
			
			SoundMixer.soundTransform = new SoundTransform(1);
			
			
			_origVideoWidth = event.data.width;
			_origVideoHeight = event.data.height;
			trace("orginalHeight: " + _origVideoHeight + " | orginalWidth: " + _origVideoWidth);
			_videoDuration = event.data.duration;

			scaleAndReposition();
		}

		private function skipIntroOut(event : MouseEvent) : void {
			TweenLite.to(_skipIntro.getChildByName("t"), .5, {tint:null});
		}

		private function skipIntroOver(event : MouseEvent) : void {
			TweenLite.to(_skipIntro.getChildByName("t"), .5, {tint:0xFFFFFF});			
		}

		private function skipIntroClick(event : MouseEvent) : void {
			trace("Skip CLICKED!");
			var valueStr : String = AppController.getInstance().language + "/" + ResourceType.EXPERIENCE;
			SWFAddress.setValue(AppController.getInstance().cleanSwfAddressPath(valueStr));
		}
		

		public function reveal() : void {
			_content.alpha = 1;
			visible = true;
			alpha = 1;
			TweenLite.to(this, AppController.TWEEN_IN_TIME, {alpha:1, ease:Sine.easeOut, onComplete:revealDone, delay:AppController.TWEEN_DELAY_TIME});
		}
		
		override public function scaleAndReposition():void {
			
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			if(stg) {
				var theStageWidth:Number = Number(stg.stageWidth + 0);
				var theStageHeight:Number = Number(stg.stageHeight + 0);
				
				var multiplyer : Number = Math.max(( theStageHeight - 67 ) / 546, theStageWidth / 970);
	
				x = 0;
				y = 0;
	
				if (_content) {
					
					_content.width = 970 * multiplyer;
					_content.height = 546 * multiplyer;
					_content.x = ((theStageWidth - _content.width) / 2);
					_content.y = ((theStageHeight - 67 - _content.height) / 2);
					
					
					if (AppController.getInstance().language != LanguageCodes.ARABIC) {
						_skipIntro.x = theStageWidth - _skipIntro.width;
					} else {
						_skipIntro.x = _skipIntro.width + 32;
					}
					_skipIntro.y = theStageHeight - _skipIntro.height - 67 - 30;
					
				}
			}
			
		}
		
		private function revealDone():void{
			if (_content) {
//				_netStream.resume();
			}
		}

		public function get content() : Video {
			return _content;
		}

		public function killVideo() : void {
			SoundMixer.soundTransform = new SoundTransform(0);
			_nc.close();
			TweenLite.to(this, AppController.TWEEN_OUT_TIME, {alpha:0, ease:Sine.easeOut});
		}

	}
}

