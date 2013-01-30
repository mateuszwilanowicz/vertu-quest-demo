package com.groovytrain.vertu.quest.utils {
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFieldType;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.controllers.AppController;

	import flash.text.AntiAliasType;
	import flash.text.TextField;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FontFactory {

		public static const ARIAL_FONT_NAME : String = "ArialFR";//		public static const DFP_HEI_FONT_NAME : String = "DFPHeiW7-GB";//"Arial";		public static const ENGRAVERS_GOTHIC_BT_FONT_NAME : String = "EngraversGothicBT";

		public static var fields : Array = new Array();

		public function FontFactory() {
			var n : String = FontFactory.ARIAL_FONT_NAME;
			//Font.registerFont(ArialFont);
		}

		public static function generateTextField(	str : String = "", fontName : String = ARIAL_FONT_NAME, 
													fSize : int = 12, colour : int = 0x000000, 
													multiline : Boolean = false,
													fAlign : String = "left" ) : TextField {
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				fAlign = TextFieldAutoSize.RIGHT;
			}
			
			var t : TextField = new TextField();
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.autoSize = fAlign;
			t.wordWrap = multiline;
			t.multiline = multiline;
			t.selectable = false;
			t.embedFonts = true;
			t.styleSheet = AppController.getInstance().cssStyleSheet;
			
			t.htmlText = '<span class="' + fontName + '">' + str + '</span>';
			trace("t.htmlText:" + t.htmlText + "::" + (t.styleSheet));
			fields.push(t);
			return t;
		}
		

		public static function generateInputField(str : String = "", fontName : String = ARIAL_FONT_NAME, 
													fSize : int = 10, colour : int = 0x000000, 
													multiline : Boolean = false,
													fAlign : String = "left" ) : TextField {
			
			var tf : TextFormat = new TextFormat();
			tf.letterSpacing = 0.8;
			tf.align = "left";
			if(AppController.getInstance().language == LanguageCodes.RUSSIAN) {
				fontName = "ArialMS";	
			} else if (AppController.getInstance().language == LanguageCodes.SIMPLIFIED_CHINESE) {
				fontName = "DFPHeiW7GB";	
			} else if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				fontName = "SimplifiedArabic";
				fAlign = "right";
				tf.align = "right";
				fSize = 10;
			}			   
			tf.font = fontName;
			tf.color = 0x666666;
			tf.leftMargin = 0;
			tf.rightMargin = 0;
			tf.leading = 0;
			tf.size = fSize;
			
			
			
			var t : TextField = new TextField();
			t.defaultTextFormat = tf;
			t.text = str;
			t.type = TextFieldType.INPUT;
			t.antiAliasType = AntiAliasType.ADVANCED;
			t.autoSize = TextFieldAutoSize.NONE;
			t.background = false;
			t.selectable = true;
			t.width = 235;
			t.height = 18;
			t.wordWrap = false;
			t.multiline = multiline;
			t.embedFonts = true;
			
			fields.push(t);
			return t;
		}

		public static function updateText(label : TextField, labelStr : String, type : String = "copy") : void {
			
			label.styleSheet = AppController.getInstance().cssStyleSheet;
			label.htmlText = '<span class="' + AppController.getInstance().language + '_'+ type +'">' + labelStr + '</span>';
			label.multiline = true;
			//label.setTextFormat(fmt);
			trace("label: " + label + " | htmlText: " + label.htmlText);
		}

		public static function refreshTextfields(language : String) : void {
			for (var i : int = 0;i < fields.length;i++) {
				if(fields[i] != null) {
					var t : TextField = fields[i] as TextField;
					var htmlStr : String = t.htmlText;
					var endStr : String = htmlStr.split('class="')[1].substr(2);
					t.styleSheet = AppController.getInstance().cssStyleSheet;
					t.htmlText = htmlStr.split('class="')[0] + 'class="' + language + endStr;
					
					if(language == LanguageCodes.RUSSIAN){// || language == LanguageCodes.SIMPLIFIED_CHINESE) {
						t.embedFonts = false;
					}
					trace("t.htmlText:"+t.htmlText);
				}
			}
		}
	}
}
