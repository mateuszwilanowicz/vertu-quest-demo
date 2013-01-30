package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.models.FooterItemModel;

	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterButtonViewWithIcon extends FooterButtonView {
		
		public function FooterButtonViewWithIcon(fiModel : FooterItemModel) {
			super(fiModel);
			
			initWithIcon();
		}

		private function initWithIcon() : void {
			trace("FooterButtonViewWithIcon.init");
			var icon : Sprite = new AssetsManager.FOOTER_MAP_ICON() as Sprite;
			icon.x = _label.x + _label.width + 2;
			addChild(icon);
			
			_back.width = icon.width + _label.width + 4;
		}
	}
}
