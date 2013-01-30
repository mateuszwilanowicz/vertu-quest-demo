package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class CopyModuleModel extends ModuleModel {
 		private var _imagePath : String = "";
		private var _scaling : Boolean = true;

		public function CopyModuleModel(target : IEventDispatcher = null) {
			super(target);
		}

		override public function setData(xmlData : XML) : void {
			super.setData(xmlData);
			
			_imagePath = _xml.image.@path;
			_copy = _xml.copy.text();
			_scaling = (_xml.@scale == "true") ? true : false; 
		}
		
		public function get imagePath() : String {
			return _imagePath;
		}

		public function get scaling() : Boolean {
			return _scaling;
		}
		
	}
}
