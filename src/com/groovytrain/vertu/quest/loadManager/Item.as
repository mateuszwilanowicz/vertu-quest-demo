package com.groovytrain.vertu.quest.loadManager {
	import flash.display.Loader;
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class Item implements ILoadable {
		public static const XML_TYPE : String = "xml";		public static const SWF_TYPE : String = "swf";
		public static const CSS_TYPE : String = "css";

		private var _relativePath : String;		private var _type : String = SWF_TYPE;		private var _loaded : Boolean = false;
		private var _loader:Object;
		

		public function Item(relPath : String) {
			_relativePath = relPath;
			
			_type = _relativePath.substr(_relativePath.lastIndexOf(".")+1);
			
		}

		public function get relativePath() : String {
			return _relativePath;
		}

		public function set relativePath(relativePath : String) : void {
			_relativePath = relativePath;
		}

		public function get loaded() : Boolean {
			return _loaded;
		}

		public function set loaded(loaded : Boolean) : void {
			_loaded = loaded;
		}
		
		public function get type() : String {
			return _type;
		}

		public function get loader() : Object {
			return _loader;
		}

		public function set loader(myloader : Object) : void {
			_loader = myloader;
		}
	}
}
