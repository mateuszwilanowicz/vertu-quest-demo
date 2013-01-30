package com.groovytrain.vertu.quest.controllers {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;

	/**
	 * @author mateuszw
	 */
	public class LoaderController extends AbstractViewController {

		private static var _instance : LoaderController;
		public var vg : Sprite;
		public var vb : Sprite;
		public var vl : MovieClip;

		private static function hidden() : void {

		}

		public static function getInstance() : LoaderController {
			if( _instance == null ) {
				_instance = new LoaderController(hidden);
			}
			return _instance;
		}

		public function LoaderController(h : Function) {
			if (h !== hidden) {
				throw new Error("BackgroundViewController and can only be accessed through BackgroundViewController.getInstance()");
			}
		}

		override public function reposition() : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			
			var xPos : Number = 0;
			var yPos : Number = 0;

			if(vb && theStage) {							
				vb.width = theStage.stageWidth;
				vb.height = theStage.stageHeight;
							
				var viewWidth : Number = view.width;
				var viewHeight : Number = view.height;
	
				vg.x = viewWidth / 2;
				vg.y = viewHeight / 2;
			}
		}
	}
}
