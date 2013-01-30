package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.views.BgView;

	/**
	 * @author ins
	 */
	public class BackgroundViewController extends AbstractViewController {

		private var _opened : Boolean = false;
		private var _spview : BgView;
		
		private static var _instance : BackgroundViewController;

		private static function hidden() : void {

		}

		public static function getInstance() : BackgroundViewController {
			if( _instance == null ) {
				_instance = new BackgroundViewController(hidden);
			}
			return _instance;
		}

		public function BackgroundViewController(h : Function) {
			if (h !== hidden) {
				throw new Error("BackgroundViewController and can only be accessed through BackgroundViewController.getInstance()");
			}
		}
		
		
		public function start() : void {
			if(!_opened) {
				_spview = view as BgView;
				_spview.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
				_spview.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandler);
				_spview.reveal();
				_opened = true;
			}
		}
		
		public override function reposition() : void {

			var colView : BgView = view as BgView;
			colView.scaleAndReposition();
			
		} 

		private function puttingAwayViewHandler(event : ViewEvent) : void {
			event.target.removeEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
			trace("HHHHHHHHH puttingAwayViewHandler() :: BACKGROUND");
			_opened = false;
		}

		private function pageCloseClickedHandler(event : PageEvent) : void {
			if(view) {
				view.putAway();
				_spview = view as BgView;
				_spview.killVideo();
				_opened = false;
			}
			
		}

		public function close() : void {
			
			pageCloseClickedHandler(null);
			LoaderController.getInstance().view.visible = false;
			var swfPath : String = LoadManager.getInstance().swfDirectory + AppController.getInstance().language + "/intro.swf";
			LoadManager.getInstance().stopLoadingItem(swfPath);
			
		}
	}
}
