package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.views.ExperienceThePhoneView;

	/**
	 * @author ins
	 */
	public class ExperienceThePhoneController extends AbstractViewController {

		private var _opened : Boolean = false;
		
		private static var _instance : ExperienceThePhoneController;
		
		private static function hidden() : void {
			
		}

		public static function getInstance() : ExperienceThePhoneController {
			if( _instance == null ) {
				_instance = new ExperienceThePhoneController(hidden);
			}
			return _instance;
		}

		public function ExperienceThePhoneController(h : Function) {
			if (h !== hidden) {
				throw new Error("ExperienceThePhoneController and can only be accessed through ExperienceThePhoneController.getInstance()");
			}
		}

		public function start() : void {
			if(!_opened) {
				view.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
				view.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandler);
				view.alpha = 0;
				view.visible = true;
				view.show();
				_opened = true;
			}
		}
		
		public override function reposition() : void {
				view = view as ExperienceThePhoneView;
				view.scaleAndReposition();
		} 

		private function puttingAwayViewHandler(event : ViewEvent) : void {
			trace("HHHHHHHHH puttingAwayViewHandler() :: SPECIFICATION");
			event.target.removeEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
		}

		private function pageCloseClickedHandler(event : PageEvent) : void {
//			trace("AAAAAAA ExperienceThePhone.putAway()");
			view.putAway();
			_opened = false;
		}
		
		

		public function close() : void {
			pageCloseClickedHandler(null);
		}

		
	}
}