package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class WtbComboRowModel extends AbstractModel {

		private var _data : XML;		private var _code : String = "";		private var _name : String = "";
		private var _value : String = "";
		private var _storeId : String = "";		private var _order : String = "";		private var _storeDisplayName : String = ""; 
		private var _address : String = "";
		private var _tel : String = "";
		private var _links : String = "";

		/*
		<?xml version="1.0" encoding="UTF-8"?>
		<countries language="en">
		<country code="ad" name="Andorra">
		<region code="" name="">
		<city name="Andorra">
       
		<store id="10001" order="0">
		<storeDisplayName>Mercat Del Diamant, Avda. Meritxell 18</storeDisplayName>
		<name>Mercat Del Diamant</name>
		<address1>Avda. Meritxell 18</address1>
		<address2>Andorra</address2>
		<address3></address3>
		<address4></address4>
		<pc>AD 500</pc>
		<state></state>
		<hours1></hours1>
		<hours2></hours2>
		<hours3></hours3>
		<hours4></hours4>
		<tel>+37 68 00 630</tel>
		<tel2></tel2>
		<fax></fax>
		<email></email>
		<url>http://www.mercatdeldiamant.com</url>
		<image>default.jpg</image>
		</store>
		
		</city>
		</region>
		</country>
		 */
		public function WtbComboRowModel(target : IEventDispatcher = null) {
			super(target);
		}

		override public function setData(xmlData : XML) : void {
			_xml = xmlData;
			
			if(_xml.name() == "store") {
				_storeId = xmlData.@id;				_order = xmlData.@order;
				_storeDisplayName = xmlData.storeDisplayName.text();
				_name = xmlData.name.text();
				_address = xmlData.address1.text();				_address += "<br>" + xmlData.address2.text();				_address += "<br>" + xmlData.address3.text();				_address += "<br>" + xmlData.address4.text();				_address += "<br>" + xmlData.pc.text();				_address += "<br>" + xmlData.state.text();
				
				_tel = xmlData.tel.text();
				if(xmlData.tel2.text()) {
					_tel += "<br>" + xmlData.tel2.text();
				}
				
				_links = xmlData.email.text();				
				if(xmlData.email.text()) {
					_links = '<a href="mailto:'+xmlData.email.text()+'" target="_blank">'+xmlData.email.text()+'</a><br/>';
				}
				if(xmlData.url.text()) {
					_links += '< a href="'+ xmlData.url.text()+'" target="_blank">'+xmlData.url.text()+'</a><br/>';
				}
				
				_label = _storeDisplayName;
			} else {
				trace("ELSE "+_xml.name())
				_code = xmlData.@code;				_name = xmlData.@name;
				_value = xmlData.@value;
				_label = _name;
			}
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
