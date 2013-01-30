package com.groovytrain.vertu.quest.models {
	import flash.display.MovieClip;
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ModuleModel extends AbstractModel {

		private var _nr 					: int = 0;		
		private var _id 					: String;
		private var _title 					: String;		private var _name 					: String;
		private var _type 					: String = "";
		private var _category 				: String = "";
		private var _showPopup 				: Boolean = true;
		private var _showControlls 			: Boolean = true;
		private var _repeat 				: Boolean = false;
		private var _popupBtn				: MovieClip;
		
		protected var _copy : String = "";
		
		public function ModuleModel(target : IEventDispatcher = null) {
			super(target);
		}
		
		override public function setData(xmlData : XML) : void {
			_xml = xmlData;
//			_id = _xml.@id;
			_nr = _xml.@id;
			_title = _xml.title.text();
			_name = _xml.name.text();
			_category = _xml.category.text();
			_type = _xml.@type;
			_copy = _xml.copy.text();
			_showPopup = _xml.@showpopup == "true" ? true : false;			_showControlls = new Boolean(_xml.@controlls == "true");			_repeat = new Boolean(_xml.@repeat == "true");
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

		public function get category() : String {
			return _category;
		}

		public function get nr() : int {
			return _nr;
		}

		public function set nr(nr : int) : void {
			_nr = nr;
		}

		public function get copy() : String {
			return _copy;
		}

		public function get showPopup() : Boolean {
			return _showPopup;
		}

		public function get showControlls() : Boolean {
			return _showControlls;
		}

		public function get name() : String {
			return _name;
		}

		public function get repeat() : Boolean {
			return _repeat;
		}

		public function set id(myid : String) : void {
			_id = myid;
		}

		public function get popupBtn() : MovieClip {
			return _popupBtn;
		}

		public function set popupBtn(popupBtn : MovieClip) : void {
			_popupBtn = popupBtn;
		}
	}
}
