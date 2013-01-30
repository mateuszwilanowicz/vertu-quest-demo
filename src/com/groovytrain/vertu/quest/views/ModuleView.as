package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ModuleView extends AbstractView {

		public function ModuleView() {
			
			super();
			init();
			
		}

		private function init() : void {

		
		}

		public function reveal(moduleId : String) : void {

			dispatchEvent(new ViewEvent(ViewEvent.VIEW_REVEALED));
			
		}

		
		public function close() : void {
			
			closeDone();
			
		}

		private function closeDone() : void {
			
			dispatchEvent(new ModuleEvent(ModuleEvent.CLOSE_DONE));
			
		}
	}
}
