package com.groovytrain.vertu.quest.events {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterViewEvent extends AbstractEvent {

		public static const WHERE_TO_BUY_CLICKED : String = "WHERE_TO_BUY_CLICKED";
		public static const EXPERIENCE_THE_PHONE : String = "EXPERIENCE_THE_PHONE";
		public static const REGISTER : String = "REGISTER_YOUR_INTEREST";		public static const THE_COLLECTION : String = "THE_COLLECTION";		public static const SPECIFICATIONS : String = "SPECIFICATIONS";		public static const RANGE : String = "RANGE";
		public static const DESIGN : String = "DESIGN_MODULES";
		public static const LIFESTYLE : String = "LIFESTYLE_MODULES";
		public static const PERFORMANCE : String = "PERFORMANCE_MODULES";
		public static const BOUTIQUES : String = "BOUTIQUES";
		public static const ENDADDRESSUPDAE : String = "END_ADDRESS_UPDATE";
		
		public static const FOOTER_THUMB_CLICK : String = "FILTER_THUMB_CLICK";

		public function FooterViewEvent(type : String, bubbles : Boolean = false, cancelable : Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
