package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.utils.FontFactory;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.asual.swfaddress.SWFAddress;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.models.FooterItemModel;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.views.generic.BasicButton;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterComboOptionsView extends Sprite {
		private var _rows : Array = new Array();		private var _optionsSprite : Sprite;
		private var _mask : Sprite;

		public function FooterComboOptionsView() {
			init();
		}

		private function init() : void {
			_optionsSprite = new Sprite();
			//Artist.drawRect(_optionsSprite, 0, 0, 212, 10, 0x333333);
			addChild(_optionsSprite);
				
			_mask = new Sprite();
			Artist.drawRect(_mask, 0, 0, 220, 300, 0xFF33DD, 0.6);
			addChild(_mask);
			
			_optionsSprite.y = _mask.y = 0;
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				_mask.x = -220;
			} else {
				_mask.x = 0;
			}
			_optionsSprite.mask = _mask;
		}

		public function showPopup(model : FooterItemModel) : void {
			
			var yPos : Number = 0;
			for (var i : int = 0;i < model.options.length;i++) {
//				trace("\t" + model.options[i]);
				var row : Sprite;
				if(_rows.length != model.options.length) {
//					trace("creating new ROW");
					
					row = new BasicButton();
					var lbl : MovieClip = new MovieClip();					var lblSprite : MovieClip = null;
					
//					trace("model.options[i].lang:" + model.options[i].lang + "-");
					switch(model.options[i].lang) {
						case "en":
							trace("en - here");
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_EN());
							break;
						case "fr":
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_FR());
							break;
						case "de":
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_DE());
							break;
						case "ru":
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_RU());
							break;
						case "zh":
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_ZH());
							break;
						case "it":
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_IT());
							break;
						case "ar":
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_AR());
							break;
						default:
							lblSprite = MovieClip(new AssetsManager.LANG_OPTION_EN());
							break;
					}
					lblSprite.name = "labelImage";
					if (AppController.getInstance().language == LanguageCodes.ARABIC) {
						lblSprite.gotoAndStop(3);
					} else {
						lblSprite.gotoAndStop(1);						
					}
					
					lbl.addChild(lblSprite);
					lbl.language = model.options[i].lang;
					lbl.name = "labelMc";
				
					lbl.x = 0;						
					lbl.y = 0; 
					row.addChild(lbl);
					
					yPos -= 45
					row.y = yPos;
					row.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);					row.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);					row.addEventListener(MouseEvent.CLICK, clickHandler);
					_optionsSprite.addChild(row);
					_rows.push(row);
					
					_mask.y = yPos;				
					_mask.height = Math.abs(_mask.y);
				} else {
					//trace("using old ROW");
					row = _rows[i] as BasicButton;
				}
				row.alpha = 0;
				TweenLite.to(row, 0.2, {alpha:0.9, delay:i * 0.18, ease:Sine.easeOut})
			}
		}

		private function clickHandler(event : MouseEvent) : void {
			var lbl : MovieClip = (event.target.getChildByName("labelMc") as MovieClip)
			trace("lbl:" + lbl.language);
			AppController.getInstance().language = lbl.language;
			
		}

		
		public function hidePopup() : void {
			for (var i : int = _rows.length - 1;i > -1;i--) {
				TweenLite.to(_rows[i], (_rows.length - i - 1) * 0.2, {alpha:0, ease:Sine.easeIn});
			}
			TweenLite.delayedCall(_rows.length * 0.1 + 0.2, removePopup);
		}

		private function removePopup() : void {
			try {
				parent.removeChild(this);
			}catch(e : Error) {
				trace("ERROR:" + e.message);
			}
		}

		private function rollOutHandler(event : MouseEvent) : void {
			var lm : MovieClip = BasicButton(event.target).getChildByName("labelMc") as MovieClip;
			var ls : MovieClip = lm.getChildByName("labelImage") as MovieClip;
			
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				ls.gotoAndStop(3);
			} else {
				ls.gotoAndStop(1);						
			}
		}

		private function rollOverHandler(event : MouseEvent) : void {
			var lm : MovieClip = BasicButton(event.target).getChildByName("labelMc") as MovieClip;
			var ls : MovieClip = lm.getChildByName("labelImage") as MovieClip;
			
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				ls.gotoAndStop(4);
			} else {
				ls.gotoAndStop(2);						
			}
		}
	}
}
