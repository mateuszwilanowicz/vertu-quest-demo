package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.views.AbstractView;
	import com.groovytrain.vertu.quest.views.ViewOrientation;

	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AbstractViewController extends EventDispatcher {

		protected var _view : AbstractView;

		public function AbstractViewController(target : IEventDispatcher = null) {
			super(target);
		}

		public function get view() : AbstractView {
			return _view;
		}

		public function set view(view : AbstractView) : void {
			_view = view;
			_view.addEventListener(ViewEvent.REPOSITION_VIEW, repositionViewHandler);
		}

		private function repositionViewHandler(event : ViewEvent) : void {
			reposition();
		}

		public function reposition() : void {
			/*
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			
			var xPos : Number = 0;
			var yPos : Number = 0;
			
			var viewWidth : Number = _view.width;
			var viewHeight : Number = _view.height;

			xPos = (theStage.stageWidth - viewWidth) / 2;
			yPos = (theStage.stageHeight - viewHeight) / 2;
			_view.y = yPos;
			_view.x = xPos;
			_view.show();
			*/
		}
	}
}
