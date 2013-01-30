package
{
	import mx.core.FontAsset;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.describeType;

	public class de_fonts extends Sprite
	{
		[Embed(systemFont="Arial", mimeType="application/x-font", fontName="Arial",  unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+02C6,U+02DC,U+2013-U+2014,U+2018-U+201A,U+201C-U+201E,U+2020-U+2022,U+2026,U+2030,U+2039-U+203A,U+20AC,U+2122,U+00C0,U+00E0,U+00C1,U+00E1,U+00C8,U+00E8,U+00C9,U+00E9,U+00CC,U+00EC,U+00CD,U+00ED,U+00D2,U+00F2,U+00D3,U+00F3,U+00D9,U+00F9,U+00DA,U+00FA,U+00AB,U+00BB,U+20AC,U+00A3,U+00C4,U+00E4,U+00D6,U+00F6,U+00DC,U+00FC,U+00DF,U+201E,U+201C,U+201D,U+00B0,U+00C2,U+00E2,U+00C6,U+00E6,U+00C7,U+00E7,U+00CA,U+00EA,U+00CB,U+00EB,U+00CE,U+00EE,U+00CF,U+00EF,U+00D4,U+00F4,U+0152,U+0153,U+00DB,U+00FB,U+20A3,U+00C5", embedAsCFF="false")] // Uppercase [A..Z] ; Lowercase [a..z] ; Numerals [0..9] ; Punctuation [!@#%...] ; Basic Latin ; chars="ÀàÁáÈèÉéÌìÍíÒòÓóÙùÚú«»€£ÄäÖöÜüß„“”°ÂâÆæÇçÊêËëÎîÏïÔôŒœÛû₣Å"
		public var font0:Class;

		public function de_fonts()
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