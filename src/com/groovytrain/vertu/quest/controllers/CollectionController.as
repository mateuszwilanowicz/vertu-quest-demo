package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.views.CollectionView;

	/**
	 * @author mateuszw
	 */
	public class CollectionController extends AbstractViewController {
		
		private var _opened : Boolean = false;
		private var _spview : CollectionView;
		private static var _instance : CollectionController;
		
		private static function hidden() : void {
			
		}

		public static function getInstance() : CollectionController {
			if( _instance == null ) {
				_instance = new CollectionController(hidden);
			}
			return _instance;
		}

		public function CollectionController(h : Function) {
			if (h !== hidden) {
				throw new Error("SpecificationsController and can only be accessed through SpecificationsController.getInstance()");
			}
		}

		public function start() : void {
			var speView : CollectionView = view as CollectionView;
			_spview = view as CollectionView;
			view = speView;
			
			view.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
			view.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandler);
			view.alpha = 0;
			view.show();
			speView.reveal();
			
			_opened = true;
		}
		
		public override function reposition() : void {

			var colView : CollectionView = view as CollectionView;
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
