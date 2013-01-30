package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterItemModel extends AbstractModel {
		
		public static const LOGO_STATIC : String = "logo";
		
		private var _id : String;
		private var _x : Number;
		private var _y : Number;
		public function FooterItemModel(target : IEventDispatcher = null) {
			super(target);
		}

		override public function setData(xmlData : XML) : void {
			_xml = xmlData;
			
			_id = _xml.@id;
			_title = _xml.title.text();
			_type = _xml.@type;
			
			if(_xml.url) {
				if(_xml.url.@window) {
					_window = _xml.url.@window;
				}
			}
			
			if(_xml.@x) {
				_x = Number(_xml.@x);
			}
			if(_xml.@y) {
				_y = Number(_xml.@y);
			}
			for each (var option : XML in _xml.option) {
				_options.push({text:option.text(), font:option.@font, lang:String(option.@lang) });
			}
//			trace("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%");
		}

		public function get id() : String {
			return _id;
		}

		public function get title() : String {
			return _title;
		}

		public function get type() : String {
			return _type;
		}

		public function get url() : String {
			return _url;
		}

		public function get window() : String {
			return _window;
		}

		public function get options() : Array {
			return _options;
		}

		public function get x() : Number {
			return _x;
		}

		public function get y() : Number {
			return _y;
		}

	}
}