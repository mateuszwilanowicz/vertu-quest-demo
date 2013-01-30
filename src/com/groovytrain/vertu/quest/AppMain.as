package com.groovytrain.vertu.quest {
	import flash.system.Security;
	import com.groovytrain.vertu.quest.controllers.AppController;

	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */

	public class AppMain extends Sprite {
		
		public function AppMain() {
				
			Security.allowDomain("*");
			init();
			
		}

		private function init() : void {
			
			var controller : AppController = AppController.getInstance();
			controller.base = this;
			controller.loadConfig("config.xml");
		
		}
	}
}
