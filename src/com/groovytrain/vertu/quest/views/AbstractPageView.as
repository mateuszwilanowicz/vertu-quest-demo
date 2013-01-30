package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AbstractPageView extends AbstractView {
		
		public function AbstractPageView() {
			super();
		}
		
		private function closeClickedHandler(event : MouseEvent) : void {
			var pEvent : PageEvent = new PageEvent(PageEvent.CLOSE_CLICKED);
			dispatchEvent(pEvent);
		}
	}
}
