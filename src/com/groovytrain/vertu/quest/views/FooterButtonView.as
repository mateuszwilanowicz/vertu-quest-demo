package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.generic.ResourceType;
	import com.groovytrain.vertu.quest.controllers.FooterViewController;
	import flash.events.Event;
	import org.papervision3d.materials.MovieAssetMaterial;
	import flash.display.MovieClip;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.models.FooterItemModel;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.FontFactory;
	import com.groovytrain.vertu.quest.views.generic.BasicButton;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterButtonView extends BasicButton {

		public static const NORMAL_TEXT_COLOUR : Number = 0xAAAAAA;		public static const NORMAL_TEXT_COLOUR2 : Number = 0xAAAAAA;		public static const ROLLOVER_TEXT_COLOUR2 : Number = 0xFFFFFF;
		public static const ROLLOVER_TEXT_COLOUR : Number = 0xFFFFFF;		public static const SELECTED_TEXT_COLOUR2 : Number = 0xFFFFFF;		public static const SELECTED_TEXT_COLOUR : Number = 0xFFFFFF;

		protected var _label : TextField;
		protected var _type : String;
		protected var _model : FooterItemModel;
		protected var _back : MovieClip;
		protected var _glow : MovieClip;		protected var _id : String;		protected var _textWidth : Number;		protected var _selected : Boolean = false;
		protected var _lower : Boolean = false;

		public function FooterButtonView(fiModel : FooterItemModel) {
			super();
			this.focusRect = false;
			_model = fiModel;
			_id = _model.id;
			_type = _model.type;
			init();
		}

		private function init() : void {
			
			_glow = new GlowAnimation();
			addChild(_glow);
				
			
			_back = new MovieClip();
			addChild(_back);
			
//			var fontName : String = FontFactory.ENGRAVERS_GOTHIC_BT_FONT_NAME;
//			trace("FooterButtonView _model.title:" + _model.title + ":"+fontName);
//			_label = FontFactory.generateTextField(_model.title.toUpperCase(), fontName, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.LEFT);
			
			var className : String;

			if (_model.id == ResourceType.VERTUDOTCOM ) { 
				className = AppController.getInstance().language + "_footer_button_low";
				
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 116;
				
				_lower = true;
								
				_glow.width = _back.width = _label.width + 4;
				_back.height = _label.textHeight + 4;
				
				_glow.alpha = 0;
				/*
			} else if (_model.id == ResourceType.EXPERIENCE ) { 
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				Artist.drawRect(_back, 162, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 162;
				_lower = false;
				_glow.myMask.x = 1;
				_glow.myMask.width = 161;
				addChild(_glow);			
				_glow.gotoAndPlay("on");
				_label.textColor = _lower ? ROLLOVER_TEXT_COLOUR : ROLLOVER_TEXT_COLOUR2;

				_selected = true;
				FooterViewController.getInstance().currentButtonView = this;
				
				
				_id = ResourceType.EXPERIENCE;
			} else if (_model.id == ResourceType.DESIGN ) {
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
												
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 162;
				_lower = false;
				_glow.myMask.x = 1;
				_glow.myMask.width = 243;
				_glow.myMask.x = -81;
				addChild(_glow);
				
				
				_id = ResourceType.DESIGN;				
				
			} else if (_model.id == ResourceType.LIFESTYLE ) {
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
								
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 162;
				_lower = false;
				_glow.myMask.x = 1;				
				_glow.myMask.width = 161;				
				_id = ResourceType.LIFESTYLE;
			} else if (_model.id == ResourceType.PERFORMANCE ) {
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 162;
				_lower = false;
				_glow.myMask.width = 243;
				_glow.myMask.x = 1;
//				_back.y = -13;
				addChild(_back);
				
				
				_id = ResourceType.PERFORMANCE;

			} else if (_model.id == ResourceType.RANGE ) {
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				Artist.drawRect(_back, 162, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 162;

				_glow.myMask.width = 243;
				_glow.myMask.x = -81;
				_lower = false;				
				addChild(_glow);
				_id = ResourceType.RANGE;
			} else if (_model.id == ResourceType.SPECIFICATIONS ) {
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				Artist.drawRect(_back, 162, 0, 1, 45, 0x000000, .3, 0, 0, 0);
								
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_label.width = 162;
				_glow.myMask.width = 243;
				_lower = false;
				_glow.myMask.x = 1;
				_id = ResourceType.SPECIFICATIONS;

			} else if (_model.id == ResourceType.EXPERIENCE ) {
				
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_lower = false;
				_label.width = 162;
				_glow.myMask.x = 1;
				
				_glow.myMask.width = 243;
				
				addChild(_back);
			*/
			} else if( _model.title == "bg"  ) {
				className = AppController.getInstance().language + "_footer_button";
				var _bg : Sprite = new AssetsManager.FOOTER_BG() as Sprite;
				addChild(_bg);
				_bg.x = -115;
				_bg.y = 0;
				_label = new TextField();
			
			} else if( _model.title == "bg2"  ) {
				className = AppController.getInstance().language + "_footer_button";
				var _bg2 : Sprite = new AssetsManager.FOOTER_BG_2() as Sprite;
				addChild(_bg2);
				_bg2.x = -115;
				_bg2.y = 0;
				_label = new TextField();
			
			} else if( _model.title == "bg3"  ) {
				className = AppController.getInstance().language + "_footer_button";
				var _bg3 : Sprite = new AssetsManager.FOOTER_BG_2() as Sprite;
				addChild(_bg3);
				_bg3.x = -115;
				_bg3.y = 0;
				_label = new TextField();
			} else {
				Artist.drawRect(_back, 0, 0, 162, 45, 0x00FF00, 0, 0, 0, 0);
				Artist.drawRect(_back, 0, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				Artist.drawRect(_back, 162, 0, 1, 45, 0x000000, .3, 0, 0, 0);
				
				className = AppController.getInstance().language + "_footer_button";
				_label = FontFactory.generateTextField(_model.title.toUpperCase(), className, 14, NORMAL_TEXT_COLOUR, true, TextFieldAutoSize.CENTER);
				_glow.myMask.width = _label.width = 161;
				_glow.myMask.x = 1;
				_lower = false;
			}

			if (AppController.getInstance().language == LanguageCodes.RUSSIAN && _model.id == ResourceType.EXPERIENCE) {
				_label.y += 8;
			} else if (AppController.getInstance().language == LanguageCodes.RUSSIAN && _model.id == ResourceType.VERTUDOTCOM ) {	
				_label.y += 8;
			} else if (AppController.getInstance().language == LanguageCodes.ARABIC ) {	
				_label.y += 8;
			} else {
				_label.y += 16;
				if (_model.id == ResourceType.VERTUDOTCOM ) { 
					_label.y -= 10;	
				}
			}
			
			addChild(_label);
			
			if( _model.title != "bg" && _model.title != "bg2" && _model.title != "bg3" ) {
			
				addChild(_back);
				
				addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);				addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
			}
			
			_label.textColor = _lower ? NORMAL_TEXT_COLOUR : NORMAL_TEXT_COLOUR2;
		}


		private function rollOutHandler(event : MouseEvent) : void {
			if(_selected) {
				_label.textColor = _lower ? SELECTED_TEXT_COLOUR : SELECTED_TEXT_COLOUR2;
			} else {
				_glow.gotoAndPlay("off");
				_label.textColor = _lower ? NORMAL_TEXT_COLOUR : NORMAL_TEXT_COLOUR2;
			}
		}

		private function rollOverHandler(event : MouseEvent) : void {
			if(!_selected) {
				_glow.gotoAndPlay("on");
				_label.textColor = _lower ? ROLLOVER_TEXT_COLOUR : ROLLOVER_TEXT_COLOUR2;
			}
		}

		public function get id() : String {
			return _id;
		}

		public function get model() : FooterItemModel {
			return _model;
		}

		public function get textWidth() : Number {
			_textWidth = _label.textWidth;
			return _textWidth;
		}

		public function get selected() : Boolean {
			return _selected;
		}

		public function set selected(selected : Boolean) : void {
			_selected = selected;
			rollOutHandler(null);
		}

		public function get glow() : MovieClip {
			return _glow;
		}

		public function get type() : String {
			return _type;
		}

		public function get label() : TextField {
			return _label;
		}
	}
}
