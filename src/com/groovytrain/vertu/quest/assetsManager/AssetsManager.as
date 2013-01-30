package com.groovytrain.vertu.quest.assetsManager {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AssetsManager {
		
		[Embed(source = "/../assets/ui.swf", symbol = "SkipIntro")]
		public static const SKIP_INTRO:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "ErrorPopupBoxBg")]
		public static const ERROR_BG_SPRITE:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "SubmitButton")]
		public static const SUBMIT_BG:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "PrivacyPolicy")]
		public static const SUBMIT_HINT_BOX_BG:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "ComboBackSprite")]
		public static const COMBO_BACK_SPRITE:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "ArrowUp")]
		public static const ARROW_UP : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "ArrowDown")]
		public static const ARROW_DOWN : Class;

		[Embed(source = "/../assets/ui.swf", symbol = "VertuLoaderClip")]
		public static const V_LOADER:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "RegisterBg")]
		public static const REG_BG:Class;

		[Embed(source = "/../assets/movieclips.swf", symbol = "PhoneGraphic")]
		public static const PHONE_GRAPHIC:Class;

		[Embed(source = "/../assets/movieclips.swf", symbol = "BackIcon")]
		public static const BACK_ICON:Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "FooterBackground")]
		public static const FOOTER_BG : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "Footer2Background")]
		public static const FOOTER_BG_2 : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "FooterBackground3")]
		public static const FOOTER_BG_3 : Class;

		[Embed(source = "/../assets/ui.swf", symbol = "FooterWorldMapIcon")]
		public static const FOOTER_MAP_ICON : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "FooterBackGrad")]
		public static const FOOTER_BG_GRAD : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "VertuLoaderClip")]
		public static const VERTU_LOADER_CLIP : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "CloseButton")]
		public static const CLOSE_BUTTON : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionEn")]
		public static const LANG_OPTION_EN : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionFr")]
		public static const LANG_OPTION_FR : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionRu")]
		public static const LANG_OPTION_RU : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionDe")]
		public static const LANG_OPTION_DE : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionZh")]
		public static const LANG_OPTION_ZH : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionIt")]
		public static const LANG_OPTION_IT : Class;
		
		[Embed(source = "/../assets/ui.swf", symbol = "LanguageOptionAr")]
		public static const LANG_OPTION_AR : Class;

		
		public function AssetsManager() {
			//Font.registerFont(ENGRAVERS_GOTHIC_BT_FONT);
			//Font.registerFont(ARIAL_FONT);
		}
	}
}
