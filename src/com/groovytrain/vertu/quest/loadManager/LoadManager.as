package com.groovytrain.vertu.quest.loadManager {
	import com.groovytrain.vertu.quest.controllers.LoaderController;
	import com.groovytrain.vertu.quest.controllers.AppController;

	import gs.easing.Quart;
	import gs.TweenLite;

	import com.groovytrain.vertu.quest.LoaderMain;

	import flash.display.MovieClip;
	import flash.events.ProgressEvent;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class LoadManager extends EventDispatcher implements ILoadManager {
		private var _loadQueue : Array = new Array();
		private var _loader : Loader;
		private var _baseDirectory : String = "";
		private var _swfDirectory : String = "";
		private var _imageDirectory : String = "";
		private var _xmlDirectory : String = "";
		private var _videoDirectory : String = "";
		private static var _instance : LoadManager;

		private static function hidden() : void {
		}

		public static function getInstance() : LoadManager {
			if ( _instance == null ) {
				_instance = new LoadManager(hidden);
			}
			return _instance;
		}

		public function LoadManager(h : Function) {
			if (h !== hidden) {
				throw new Error("LoadManager and can only be accessed through LoadManager.getInstance()");
			} else {
				init();
			}
		}

		private function init() : void {
			_loader = new Loader();
		}

		public function loadItem(itemRelativePath : String, callback : Function, showLoader : Boolean = false) : void {
		}

		public function addItemToLoadQueue(itemRelativePath : String, callback : Function, showLoader : Boolean = false) : void {
			var existingItem : Item = existsInQueue(itemRelativePath) as Item;
			if (existingItem == null) {
				// item exists
				existingItem = new Item(itemRelativePath);
				_loadQueue.push(existingItem);
			}

			if (!existingItem.loaded) {
				loadThisItem(existingItem, callback, showLoader);
			}
		}

		public function existsInQueue(itemRelativePath : String) : Item {
			for (var i : int = 0;i < _loadQueue.length;i++) {
				var item : Item = _loadQueue[i] as Item;
//				if (item.relativePath == itemRelativePath && item.loaded) {				if (item.relativePath == itemRelativePath ) {
					return item;
				}
			}
			return null;
		}

		private function loadThisItem(existingItem : Item, callback : Function, showLoader : Boolean = false) : void {
			var request : URLRequest = new URLRequest(_baseDirectory + existingItem.relativePath);

			if (existingItem.type == Item.XML_TYPE || existingItem.type == Item.CSS_TYPE) {
				var urlLoader : URLLoader = new URLLoader();
				urlLoader.addEventListener(Event.COMPLETE, callback);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, itemErrorHandler);
				urlLoader.addEventListener(ErrorEvent.ERROR, itemErrorHandler);
				urlLoader.load(request);
				existingItem.loader = urlLoader;
			} else {
				var loader : Loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callback);
				if ( showLoader ) {
					loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
				}
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, itemErrorHandler);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, itemErrorHandler);
				loader.load(request);
				existingItem.loader = loader;
			}

			if ( showLoader ) {
				LoaderController.getInstance().view.visible = true;
				TweenLite.to(LoaderController.getInstance().vl, 1, {alpha:1, ease:Quart.easeOut, delay:1});
			}
		}

		public function stopLoadingItem(itemRelativePath : String) : void {
			trace("SSSSSSSSSSSSSSS stopLoadingItem(" + itemRelativePath + ")");

			var existingItem : Item = existsInQueue(itemRelativePath) as Item;
			if (existingItem != null) {
				trace("EEEEEEEEEEE existingItem == true");
				if (existingItem.loaded) {
					trace("LLLLLLLLLLL existingItem.loaded == true");
					Loader(existingItem.loader).unload();
				} else {
					trace("LLLLLLLLLLL existingItem.loaded == false");
					Loader(existingItem.loader).close();
				}
			}
		}

		private function progressHandler(e : ProgressEvent) : void {
			var frame : int = Math.floor(e.bytesLoaded / e.bytesTotal * 100);
			MovieClip(LoaderController.getInstance().vg.getChildByName("v")).p.text = "" + frame;
			MovieClip(LoaderController.getInstance().vg.getChildByName("v")).gotoAndStop(frame);
		}

		private function itemErrorHandler(event : ErrorEvent) : void {
			trace("ERROR:" + event.text);
		}

		public function get baseDirectory() : String {
			return _baseDirectory;
		}

		public function set baseDirectory(baseDirectory : String) : void {
			_baseDirectory = baseDirectory;
		}

		public function get swfDirectory() : String {
			return _swfDirectory;
		}

		public function set swfDirectory(swfDirectory : String) : void {
			_swfDirectory = swfDirectory;
		}

		public function get imageDirectory() : String {
			return _imageDirectory;
		}

		public function set imageDirectory(imageDirectory : String) : void {
			_imageDirectory = imageDirectory;
		}

		public function get xmlDirectory() : String {
			return _xmlDirectory;
		}

		public function set xmlDirectory(xmlDirectory : String) : void {
			_xmlDirectory = xmlDirectory;
		}

		public function get videoDirectory() : String {
			return _videoDirectory;
		}

		public function set videoDirectory(videoDirectory : String) : void {
			_videoDirectory = videoDirectory;
		}
	}
}