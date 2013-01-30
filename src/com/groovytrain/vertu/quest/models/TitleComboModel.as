package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author mateuszw
	 */
	public class TitleComboModel extends AbstractModel {
		
		private var _data : XML;
		private var _code : String = "";
		private var _name : String = "";
		private var _value : String = "";
		private var _storeId : String = "";
		private var _order : String = "";
		private var _storeDisplayName : String = ""; 
		private var _address : String = "";
		private var _tel : String = "";
		private var _links : String = "";
		
		public function TitleComboModel(target : IEventDispatcher = null) {
			super(target);
		}
		
		override public function setData(xmlData : XML) : void {
			_xml = xmlData;
			_name = xmlData.@name;
			_label = _name;
			_data = xmlData;
		}

		public function get code() : String {
			return _code;
		}

		public function get name() : String {
			return _name;
		}

		public function get data() : XML {
			return _data;
		}

		public function get storeId() : String {
			return _storeId;
		}

		public function get order() : String {
			return _order;
		}

		public function get storeDisplayName() : String {
			return _storeDisplayName;
		}
		
		public function get address() : String {
			return _address;
		}
		
		public function get tel() : String {
			return _tel;
		}
		
		public function get links() : String {
			return _links;
		}

		public function get value() : String {
			return _value;
		}
	}
}
