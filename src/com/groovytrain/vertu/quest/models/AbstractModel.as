package com.groovytrain.vertu.quest.models {
	import com.groovytrain.vertu.quest.modules.IModel;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AbstractModel extends EventDispatcher implements IModel {
		
		protected var _xml:XML;
		protected var _label:String;
		
		public function AbstractModel(target : IEventDispatcher = null) {
			super(target);
		}
		
		public function setData(xmlData:XML) : void{
			
		}
		
		public function dump() : String {
			
			return null;
		}

		public function get label() : String {
			return _label;
		}

		public function get xml() : XML {
			return _xml;
		}
	}
}
