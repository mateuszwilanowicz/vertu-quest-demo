package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.models.AbstractModel;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import gs.TweenLite;

	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.WtbComboBoxEvent;
	import com.groovytrain.vertu.quest.models.WtbComboRowModel;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;
	import com.groovytrain.vertu.quest.utils.FontFactory;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class WtbComboRowSprite extends Sprite {

		private var _selected : Boolean = false;
		private var _backSprite : Sprite;
		private var _btn : Sprite;		private var _label : TextField;
		private var _model : AbstractModel;
		private var _hilighted : Boolean = false;
		private var _type : String;

		public function WtbComboRowSprite(t:String = "country") {
			_type = t;
			init();
		}

		private function init() : void {
			_btn = new Sprite();
			ButtonInjector.injectButtonDefaults(_btn);
			Artist.drawRect(_btn, 0, 0, 10, 10, 0x00FF00, 0.0, 0, 0, 0);

			_backSprite = new AssetsManager.COMBO_BACK_SPRITE() as Sprite;
			_backSprite.height = 25;

			_btn.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			_btn.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			_btn.addEventListener(MouseEvent.CLICK, clickedHandler);
			
			addChild(_backSprite);
			addChild(_btn);
		}

		private function clickedHandler(event : MouseEvent) : void {
			selected = !selected;
		}

		private function rollOutHandler(event : MouseEvent) : void {
			TweenLite.to(_backSprite, 0.3, {tint:null});
		}

		private function rollOverHandler(event : MouseEvent) : void {
			TweenLite.to(_backSprite, 0.3, {tint:0x333333});
		}

		public function setWidth(w : Number) : void {
			_backSprite.width = w;
			_backSprite.height = 25;
			_btn.width = w;
			_btn.height = 25;
		}

		public function hilight() : void {
			/*
			var fmt : TextFormat = _label.getTextFormat();
			fmt.color = 0xFFFFFF;
			_label.setTextFormat(fmt);
			 */
			trace(_label.text);
			_label.x = 20;
			_hilighted = true;
		}

		public function rollOut() : void {
			_hilighted = false;
			_label.x = 10;
			/*
			var fmt : TextFormat = _label.getTextFormat();
			fmt.color = 0x999999;
			_label.setTextFormat(fmt); 
			 */
			rollOutHandler(null);
		}

		public function setLabel(labelStr : String) : void {
			
			if(_label == null) {
				_label = FontFactory.generateTextField(labelStr.toUpperCase(), AppController.getInstance().language + "_dd", 12, 0x999999);
				
			} else {
				FontFactory.updateText(_label, labelStr.toUpperCase());
			}
			_label.x = 10;
			_label.y = 4;
			if (_type == "country" && AppController.getInstance().language == LanguageCodes.ARABIC) {
				_label.width = 230; 
			} else if(_type == "title" && AppController.getInstance().language == LanguageCodes.ARABIC) {
				_label.width = 135;	
			}
			_label.border = false;
			_label.borderColor = 0x00FF00;
			addChild(_label);
			addChild(_btn);
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set selected(selected : Boolean) : void {
			_selected = selected;
			if(_selected) {
				
				dispatchEvent(new WtbComboBoxEvent(WtbComboBoxEvent.SELECTION_CHANGED));
			} else {
				
			}
		}

		public function get label() : TextField {
			return _label;
		}

		public function get model() : AbstractModel {
			return _model;
		}

		public function set model(model : AbstractModel) : void {
			_model = model;
		}

		public function get hilighted() : Boolean {
			return _hilighted;
		}
	}
}
