package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;

	import flash.display.Sprite;
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterBackGradView extends AbstractView {
		
		private var _backGrad : Sprite;
		
		public function FooterBackGradView() {
			super();
			
			_backGrad = new AssetsManager.FOOTER_BG_GRAD() as Sprite;
			
			addChild(_backGrad);
		}
	}
}
