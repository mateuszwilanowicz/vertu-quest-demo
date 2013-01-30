package fonts {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.Font;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ru_fonts extends MovieClip {

		[Embed(source="/../assets/fonts/ARIALUNI.TTF", fontName="Arial Unicode MS", fontFamily="Arial Unicode MS",
		unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E")]
		public static var arialUnicodeTTF : Class;

		public function ru_fonts() {
			Font.registerFont(arialUnicodeTTF);
			
			dispatchEvent(new Event("FONT_REGISTERED"));
		}
	}
}
