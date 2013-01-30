package com.groovytrain.vertu.quest.utils {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class StringCompressor {

		public static function compressXml(source : String, tagNameDictionary : Array, attributesDictionary : Array) : String {
			
			var output : String = source;
			 
			var long : String;
			var short : String;
			
			output = output.split("  ").join(" ");
			output = output.split("  ").join(" ");
			output = output.split("  ").join(" ");
			output = output.split("  ").join(" ");
			
			var escStr:String = escape(output);
			escStr = (escStr.split("%0A%20").join(""));
			escStr = (escStr.split("%0A").join(""));			escStr = (escStr.split("%0D").join(""));
			output = unescape(escStr);
			
			for (var i : int = 0;i < tagNameDictionary.length;i++) {
				long = tagNameDictionary[i][0];				short = tagNameDictionary[i][1];
				
				output = output.split("<" + long).join("<" + short);
				output = output.split("</"+long ).join("</"+short);
			}
			
			for (var a : int = 0;a < attributesDictionary.length;a++) {
				long = attributesDictionary[a][0];
				short = attributesDictionary[a][1];
				
				output = output.split(long + "=").join(short + "=");
			}
			return output;
		}

		
		public static function uncompressXml(source : String, tagNameDictionary : Array, attributesDictionary : Array) : String {
			
			var output : String = source;
			
			var long : String;
			var short : String;
				
			for (var i : int = 0;i < tagNameDictionary.length;i++) {
				long = tagNameDictionary[i][0];
				short = tagNameDictionary[i][1];
				 
				output = output.split("<" + short + ">").join("<" + long + ">");				output = output.split("<" + short + " ").join("<" + long + " ");				output = output.split("<" + short + "/>").join("<" + long + "/>");
				output = output.split("</" + short + ">").join("</" + long + ">");
			}
			
			for (var a : int = 0;a < attributesDictionary.length;a++) {
				long = attributesDictionary[a][0];
				short = attributesDictionary[a][1];
				output = output.split(" " + short + "=").join(" " + long + "=");
			}
			return output;
		}
	}
}
