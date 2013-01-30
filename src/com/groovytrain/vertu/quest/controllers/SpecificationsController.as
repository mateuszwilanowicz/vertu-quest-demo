package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.views.SpecificationsView;

	/**
	 * @author mateuszw
	 */
	public class SpecificationsController extends AbstractViewController {

		
		private var _opened : Boolean = false;
		private var _spview : SpecificationsView;
		private static var _instance : SpecificationsController;
		
		private static function hidden() : void {
			
		}

		public static function getInstance() : SpecificationsController {
			if( _instance == null ) {
				_instance = new SpecificationsController(hidden);
			}
			return _instance;
		}

		public function SpecificationsController(h : Function) {
			if (h !== hidden) {
				throw new Error("SpecificationsController and can only be accessed through SpecificationsController.getInstance()");
			}
		}

		public function start() : void {
			
				var speView : SpecificationsView = view as SpecificationsView;
			
				speView.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
				speView.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandlerAddress);
				speView.alpha = 0;
				speView.reveal();
				speView.show();
				_opened = true;
			
		}

		private function pageCloseClickedHandlerAddress(event : PageEvent) : void {
			AppController.getInstance().closeLevelTwo();
		}
		
		public override function reposition() : void {
				var speView : SpecificationsView = view as SpecificationsView;
				speView.scaleAndReposition();
		} 

		private function puttingAwayViewHandler(event : ViewEvent) : void {
			trace("HHHHHHHHH puttingAwayViewHandler() :: SPECIFICATION");
			event.target.removeEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
			_opened = false;
		}

		private function pageCloseClickedHandler(event : PageEvent) : void {
			view.putAway();
			_opened = false;
		}
		
		

		public function close() : void {
			pageCloseClickedHandler(null);
		}

		
	}
}
