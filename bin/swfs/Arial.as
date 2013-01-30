package
{
	import mx.core.FontAsset;
	import flash.display.Sprite;
	import flash.system.Security;
	import flash.text.Font;
	import flash.utils.describeType;

	public class Arial extends Sprite
	{
		[Embed(systemFont="Arial", mimeType="application/x-font", fontName="font1",  unicodeRange="U+0020-U+002F,U+0030-U+0039,U+003A-U+0040,U+0041-U+005A,U+005B-U+0060,U+0061-U+007A,U+007B-U+007E,U+02C6,U+02DC,U+2013-U+2014,U+2018-U+201A,U+201C-U+201E,U+2020-U+2022,U+2026,U+2030,U+2039-U+203A,U+20AC,U+2122,U+00C0,U+00E0,U+00C1,U+00E1,U+00C8,U+00E8,U+00C9,U+00E9,U+00CC,U+00EC,U+00CD,U+00ED,U+00D2,U+00F2,U+00D3,U+00F3,U+00D9,U+00F9,U+00DA,U+00FA,U+00AB,U+00BB,U+20AC,U+00A3,U+00C4,U+00E4,U+00D6,U+00F6,U+00DC,U+00FC,U+00DF,U+201E,U+201C,U+201D,U+00B0,U+00C2,U+00E2,U+00C6,U+00E6,U+00C7,U+00E7,U+00CA,U+00EA,U+00CB,U+00EB,U+00CE,U+00EE,U+00CF,U+00EF,U+00D4,U+00F4,U+0152,U+0153,U+00DB,U+00FB,U+20A3,U+0410,U+0430,U+0411,U+0431,U+0412,U+0432,U+0413,U+0433,U+0414,U+0434,U+0415,U+0435,U+0416,U+0436,U+0417,U+0437,U+0418,U+0438,U+0419,U+0439,U+041A,U+043A,U+041B,U+043B,U+041C,U+043C,U+041D,U+043D,U+041E,U+043E,U+041F,U+043F,U+0420,U+0440,U+0421,U+0441,U+0422,U+0442,U+0423,U+0443,U+0424,U+0444,U+0425,U+0445,U+0426,U+0446,U+0427,U+0447,U+0428,U+0448,U+0429,U+0449,U+042A,U+044A,U+042B,U+044B,U+042C,U+044C,U+042D,U+044D,U+042E,U+044E,U+042F,U+044F", embedAsCFF="false")] // Uppercase [A..Z] ; Lowercase [a..z] ; Numerals [0..9] ; Punctuation [!@#%...] ; Basic Latin ; chars="ÀàÁáÈèÉéÌìÍíÒòÓóÙùÚú«»€£ÄäÖöÜüß„“”°ÂâÆæÇçÊêËëÎîÏïÔôŒœÛû₣АаБбВвГгДдЕеЖжЗзИиЙйКкЛлМмНнОоПпРрСсТтУуФфХхЦцЧчШшЩщЪъЫыЬьЭэЮюЯя"
		public var font0:Class;

		public function Arial()
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