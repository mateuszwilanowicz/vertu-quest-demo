package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author mateuszw
	 */
	public class CategoryModel extends AbstractModel {
		private var _id : String;
		private var _title : String;
		private var _type : String = "";
		
		public function CategoryModel(target : IEventDispatcher = null) {
			super(target);
		}
		
		override public function setData(xmlData : XML) : void {
			_xml = xmlData;
			
			_id = _xml.@id;
			_title = _xml.title.text();
			_type = _xml.@type;
			
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
	}
}
