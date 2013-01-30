package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.models.AbstractModel;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.models.WtbComboRowModel;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.FontFactory;

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class WtbStoreDetailView extends AbstractView {
		private var _image : Sprite;
		private var _titleTf : TextField;
		private var _addressTf : TextField;
		private var _telTf : TextField;
		private var _linksTf : TextField;
		private var 
			_lineSprite : Sprite;

		public function WtbStoreDetailView() {
			super();
			init();
		}

		private function init() : void {
			
			_image = new Sprite();
			_titleTf = FontFactory.generateTextField();
			_addressTf = FontFactory.generateTextField();
			_telTf = FontFactory.generateTextField();
			_linksTf = FontFactory.generateTextField();
			
			_lineSprite = new Sprite();
			Artist.drawLine(_lineSprite, 80, 0.25, 0xDCDCDC, 0.95);
			_lineSprite.rotation = 90;
		}

		public function displayDetail(abs : AbstractModel, loadedImgSprite : Sprite) : void {
			var selectedModel:WtbComboRowModel = abs as WtbComboRowModel;
			
			if(contains(_titleTf)) {
				removeChild(_titleTf);
				removeChild(_addressTf);
				removeChild(_telTf);
				removeChild(_linksTf);
			}
			if(_image.numChildren) {
				_image.removeChildAt(0);
			}
			_image.addChild(loadedImgSprite);
			addChild(_image);
			
			var fontName : String = AppController.getInstance().language+"_copy";//FontFactory.ENGRAVERS_GOTHIC_BT_FONT_NAME;
			_titleTf = FontFactory.generateTextField(selectedModel.name, fontName, 12, 0xDCDCFF, true);
			
			_titleTf.width = _addressTf.width = _telTf.width = _linksTf.width = 220;
			
//			var fmt:TextFormat = _titleTf.getTextFormat();
//			fmt.bold = true;
//			_titleTf.setTextFormat(fmt);
			
			_addressTf.y = _titleTf.y + 20 + 4;
			
			_lineSprite.x = 250;
			_telTf.x = _lineSprite.x + 10;
			
			_linksTf.x = _telTf.x;
			
			
			addChild(_titleTf);
			addChild(_addressTf);
			addChild(_lineSprite);
			
			alpha = 0;
			TweenLite.to(this, 1.2, {alpha:1, ease:Sine.easeOut});
			show();
		}
	}
}