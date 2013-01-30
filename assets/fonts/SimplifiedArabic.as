package
{
	import mx.core.FontAsset;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.describeType;

	public class SimplifiedArabic extends Sprite
	{
		[Embed(systemFont="Arial Unicode MS", mimeType="application/x-font", fontName="SimplifiedArabic",  unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+02C6,U+02DC,U+05B0-U+05FF,U+0600-U+06FF,U+2000-U+206F,U+20A0-U+20CF,U+2100-U+2183,U+FB1D-U+FB4F,U+FB50-U+FDFF,U+FE70-U+FEFF,U+0627,U+0644,U+0628,U+0635,U+064A,U+0631,U+0629", embedAsCFF="false")] // Uppercase [A..Z] ; Lowercase [a..z] ; Numerals [0..9] ; Punctuation [!@#%...] ; Basic Latin ; Hebrew ; Arabic ; chars="البصيرة"
		public var font0:Class;

		public function SimplifiedArabic()
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