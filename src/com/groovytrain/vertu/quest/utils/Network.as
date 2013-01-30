package com.groovytrain.vertu.quest.utils {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class Network {

		public static function launchUrl(urlStr : String, window : String = "_self") : void {
			var request : URLRequest = new URLRequest(urlStr);
			try {
				navigateToURL(request, window);
			}catch(e : Error) {
				trace(e.message);
			}
		}
	}
}
