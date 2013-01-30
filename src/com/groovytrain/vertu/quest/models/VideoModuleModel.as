package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class VideoModuleModel extends ModuleModel {
		
		private var _videoPath : String = "";
		private var _fileToLoadOnFinish : String = "";
		private var _timeLapse : Number = 0;
		private var _audio : Boolean = false;
		
		public function VideoModuleModel(target : IEventDispatcher = null) {
			super(target);
		}
		
		override public function setData(xmlData : XML) : void {
			super.setData(xmlData);
			_fileToLoadOnFinish = _xml.video.@onfinish;
			_videoPath = _xml.video.@path;
			_audio = _xml.video.@audio == "true" ? true : false;
		}
		
		public function get videoPath() : String {
			return _videoPath;
		}

		public function get timeLapse() : Number {
			return _timeLapse;
		}

		public function set timeLapse(value : Number) : void {
			_timeLapse = value;
		}

		public function get fileToLoadOnFinish() : String {
			return _fileToLoadOnFinish;
		}

		public function get audio() : Boolean {
			return _audio;
		}
	}
}
