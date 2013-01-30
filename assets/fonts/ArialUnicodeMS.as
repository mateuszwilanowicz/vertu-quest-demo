package
{
	import mx.core.FontAsset;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.describeType;

	public class ArialUnicodeMS extends Sprite
	{
		[Embed(systemFont="Arial Unicode MS", mimeType="application/x-font", fontName="ArialUnicodeMS",  unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+00A1-U+00FF,U+0100-U+024F,U+02C6,U+02DC,U+0400-U+04CE,U+1E00-U+1EFF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183", embedAsCFF="false")] // Latin I ; Uppercase [A..Z] ; Latin Extended B ; Lowercase [a..z] ; Latin Extended A ; Numerals [0..9] ; Punctuation [!@#%...] ; Latin Extended Add'l ; Basic Latin ; Cyrillic ; chars=""
		public var font0:Class;

		public function ArialUnicodeMS()
		{
			FontAsset;
			Security.allowDomain("*");
			var xml:XML = describeType(this);
			for (var i:uint = 0; i < xml.variable.length(); i++)
			{
				Font.registerFont(this[xml.variable[i].@name]);
			}
			
		}
	}
}