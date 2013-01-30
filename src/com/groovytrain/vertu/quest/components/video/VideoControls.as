package com.groovytrain.vertu.quest.components.video {
	import com.akamai.net.AkamaiNetStream;
	import com.groovytrain.vertu.quest.views.generic.BasicButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.media.Video;
	
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class VideoControls extends MovieClip implements IVideoControls {
		private static const FWD 						: String = "FWD";
		private static const RWD 						: String = "RWD";
		private var _video 								: Video;
		private var _netStream 							: AkamaiNetStream;
		private var _playBtn 							: BasicButton;
		private var _pauseBtn 							: BasicButton;
		private var _rwdBtn 							: BasicButton;
		private var _fwdBtn 							: BasicButton;
		private var _stopBtn							: BasicButton;
		private var _trackBar 							: MovieClip;
		private var _seekBar 							: MovieClip;
		private var _dragger 							: BasicButton;
		private var _playheadTimeTf 					: TextField;
		private var _totalTimeTf 						: TextField;
		private var _videoDuration 						: Number;
		private var _scrubKeyDown 						: String = "";
		private var _draggerRect 						: Rectangle;
		private var _netStreamStopped 					: Boolean = false;
		private var _videoPath 							: String;
		private var _updatePositionAfterRelease 		: Number;
		private var _timeLapse							: Number = 0;
		
		private var _repeat								: Boolean = false;

		public function VideoControls() {
			init();
		}
		
		public function gotoLang(val:Number):void {
			gotoAndStop(val);
		}

		private function init() : void {
			_video = getChildByName("videoObject") as Video;
			_playBtn = getChildByName("playButton") as BasicButton;
			_pauseBtn = getChildByName("pauseButton") as BasicButton;
			_rwdBtn = getChildByName("rwdButton") as BasicButton;
			_fwdBtn = getChildByName("fwdButton") as BasicButton;
			_stopBtn = getChildByName("stopButton") as BasicButton;
			_trackBar = getChildByName("trackMc") as MovieClip;
			_seekBar = getChildByName("seekbarMc") as MovieClip;
			_dragger = getChildByName("draggerMc") as BasicButton;
			_playheadTimeTf = getChildByName("playheadTime") as TextField;
			_totalTimeTf = getChildByName("totalTime") as TextField;
			_draggerRect = new Rectangle(_dragger.x, _dragger.y, (_trackBar.width-3), 0);
		}

		public function setData(vidObj : Video, nsObj : AkamaiNetStream, vidDuration : Number, vidPath : String):void {
			_netStream = nsObj;
			_video = vidObj;
			_videoDuration = vidDuration;
			_videoPath = videoPath = vidPath;

			updateControlsWithDuration();

			startTrackVideoTime();

			setupInterface();
		}
		
		public function stopVideo():void{
			stopClickedHandler(null);
		}
		
		private function startTrackVideoTime() : void {
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}

		private function startTrackDraggerMovement() : void {
			addEventListener(Event.ENTER_FRAME, draggerTrackerHandler);
		}

		private function draggerTrackerHandler(event : Event) : void {
			var timePos : Number = 0;
			timePos = ((_dragger.x - _trackBar.x) / (_trackBar.width)) * _videoDuration;
//			trace("timePos: " + timePos + " | _videoDuration: " + _videoDuration);
			if(timePos < _videoDuration - 0.05 )	{
				_updatePositionAfterRelease = timePos;
				_netStream.seek(timePos);
				
			}
		}

		private function setupInterface() : void {
			_stopBtn.addEventListener(MouseEvent.CLICK, stopClickedHandler);
			_playBtn.addEventListener(MouseEvent.CLICK, playClickedHandler);
			_pauseBtn.addEventListener(MouseEvent.CLICK, pauseClickedHandler);

			_rwdBtn.addEventListener(MouseEvent.MOUSE_DOWN, rwdMouseDownHandler);
			_fwdBtn.addEventListener(MouseEvent.MOUSE_DOWN, fwdMouseDownHandler);

			_rwdBtn.addEventListener(MouseEvent.MOUSE_UP, scrubKeyMouseUpHandler);
			_fwdBtn.addEventListener(MouseEvent.MOUSE_UP, scrubKeyMouseUpHandler);

			_dragger.addEventListener(MouseEvent.MOUSE_DOWN, draggerMouseDownHandler);

			_netStreamStopped = false;
			disableThis(_playBtn);
		}

		private function stopClickedHandler(event : MouseEvent = null) : void {
			_netStreamStopped = true;
			_netStream.close();

			_dragger.x = _trackBar.x;

			if(this.hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			if(this.hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, draggerTrackerHandler);
			}

			disableThis(_pauseBtn);

			disableThis(_rwdBtn);
			disableThis(_stopBtn);

			enableThis(_fwdBtn);
			enableThis(_playBtn);
		}

		private function draggerMouseDownHandler(event : MouseEvent) : void {
			removeEventListener(Event.ENTER_FRAME, enterFrameHandler);

			// _draggerRect.width =
			_dragger.startDrag(false, _draggerRect);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUpHandler);
			startTrackDraggerMovement();
		}

		private function stageMouseUpHandler(event : MouseEvent) : void {
			_dragger.stopDrag();
			removeEventListener(Event.ENTER_FRAME, draggerTrackerHandler);
			startTrackVideoTime();
		}

		private function scrubKeyMouseUpHandler(event : MouseEvent) : void {
			_scrubKeyDown = "";
			_netStream.resume();
		}

		private function fwdMouseDownHandler(event : MouseEvent) : void {
			_netStream.pause();
			_scrubKeyDown = FWD;
		}

		private function rwdMouseDownHandler(event : MouseEvent) : void {
			_netStream.pause();
			_scrubKeyDown = RWD;
		}

		private function disableThis(btn : BasicButton) : void {
			btn.enabled = false;
			btn.alpha = .5;
		}

		private function enableThis(btn : BasicButton) : void {
			btn.enabled = true;
			btn.alpha = 1;
		}

		private function pauseClickedHandler(event : MouseEvent) : void {
			if(_pauseBtn.enabled) {
				_netStream.pause();

				enableThis(_playBtn);
				disableThis(_pauseBtn);
			}
		}

		private function playClickedHandler(event : MouseEvent) : void {
			if(_playBtn.enabled) {
//				trace("resuming playback.....");
				if(_netStreamStopped) {
					_netStream.play(_videoPath);
					trace("VVVVVVVVVVVVVVVVVVVVVVVVVV _videoPath:" + _videoPath);
				} else {
					_netStream.resume();
				}
				enableThis(_pauseBtn);
				disableThis(_playBtn);

				enableThis(_rwdBtn);
				enableThis(_fwdBtn);
			}
		}

		private function zeroPad(dirtyTime : Number):String {
			var cleanTimeStr : String = String(dirtyTime);
			(cleanTimeStr.indexOf(".") == -1) ? cleanTimeStr = cleanTimeStr + ".00" : "" ;

			var cleanStrArr : Array = cleanTimeStr.split(".");
			if(cleanStrArr[1].length <= 1) {
				cleanStrArr[1] = cleanStrArr[1] + "0";
				cleanTimeStr = cleanStrArr.join(".");
			} else if (cleanStrArr[1].length > 2 ) {
				cleanStrArr[1] = String(cleanStrArr[1]).substr(0,2);
				cleanTimeStr = cleanStrArr.join(".");
			}

			if(dirtyTime < 10) {
				cleanTimeStr = "0" + cleanTimeStr;
			}
			return cleanTimeStr;
		}

		private function enterFrameHandler(event : Event) : void {
			var sTime : Number;

			if(_scrubKeyDown == RWD) {
				sTime = _netStream.time - 0.3;
				(sTime < 0) ? sTime = 0 : "";
				_netStream.seek(sTime);
			} else if(_scrubKeyDown == FWD) {
				sTime = _netStream.time + 0.3;
				(sTime > _videoDuration - 1) ? sTime = _videoDuration - 1 : "";
				_netStream.seek(sTime);
			}
			
			var phtf:TextFormat = new TextFormat();
			
			phtf.letterSpacing = 3;
			_playheadTimeTf.defaultTextFormat = phtf;
			_playheadTimeTf.text = zeroPad(_netStream.time);
			
			var xPos : Number = _netStream.time / _videoDuration;
			// trace("_netStream.time: " + _netStream.time + " | _videoDuration: " + _videoDuration + " | xPos: "+ xPos);
			if (_netStream.time >= _videoDuration - 0.05 - _timeLapse) {
				_dragger.x =(xPos * (_trackBar.width-3) ) + _trackBar.x;
				replayContent();
			} else {
				_dragger.x =(xPos * (_trackBar.width-3) ) + _trackBar.x;
				_seekBar.x = ((_trackBar.x + (_trackBar.width)) - ((1 - (_netStream.bytesLoaded / _netStream.bytesTotal)) * _trackBar.width));
			}
		}
		
		private function replayContent() : void {
			trace("timeLapse: " + _timeLapse);
			if (_repeat) {
				_netStream.close();
				_netStream.play(_videoPath);
				trace("VVVVVVVVVVVVVVVVVVVVVVVVVV _videoPath:" + _videoPath);
				trace("repeat true");
			} else {
				trace("repeat false");
				stopClickedHandler();
				dispatchEvent(new Event("loadEndFile",false,false));
			}
		}

		private function updateControlsWithDuration() : void {
			var phtf:TextFormat = new TextFormat();
			phtf.letterSpacing = 3;
			_totalTimeTf.defaultTextFormat = phtf;
			_totalTimeTf.text = String(_videoDuration);
			_playheadTimeTf.text = "00:00";
		}

		public function set videoPath(videoPath : String) : void {
			_videoPath = videoPath;
		}

		public function get repeat() : Boolean {
			return _repeat;
		}

		public function set repeat(repeat : Boolean) : void {
			_repeat = repeat;
		}

		public function get timeLapse() : Number {
			return _timeLapse;
		}

		public function set timeLapse(timeLapse : Number) : void {
			_timeLapse = timeLapse;
		}
	}
}
