package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.views.RangeView;

	/**
	 * @author mateuszw
	 */
	public class RangeController extends AbstractViewController {
		
		private var _opened : Boolean = false;
		private var _spview : RangeView;
		private static var _instance : RangeController;

		
		private static function hidden() : void {
			
		}

		public static function getInstance() : RangeController {
			if( _instance == null ) {
				_instance = new RangeController(hidden);
			}
			return _instance;
		}

		public function RangeController(h : Function) {
			if (h !== hidden) {
				throw new Error("SpecificationsController and can only be accessed through SpecificationsController.getInstance()");
			}
		}

		public function start() : void {
			if(!_opened) {
				var speView : RangeView = view as RangeView;
				_spview = view as RangeView;
				view = speView;
				
				view.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
				view.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandlerAddress);
				view.alpha = 0;
				view.show();
				
				speView.reveal();
				
				_opened = true;
			}
		}

		private function pageCloseClickedHandlerAddress(event : PageEvent) : void {
			AppController.getInstance().closeLevelTwo();
		}
		
		public override function reposition() : void {

			var colView : RangeView = view as RangeView;
			colView.scaleAndReposition();
			
		} 

		private function puttingAwayViewHandler(event : ViewEvent) : void {
			event.target.removeEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
			trace("HHHHHHHHH puttingAwayViewHandler() :: COLLECTION");
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
