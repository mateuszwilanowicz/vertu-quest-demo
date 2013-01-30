package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ConfigModel extends AbstractModel {
		
		public function ConfigModel(target : IEventDispatcher = null) {
			super(target);
		}
		
		override public function setData(xmlData:XML) : void{
			_xml = xmlData;
			
			//trace(getValueByKey("bgcolour"));
		}
		
		public function getValueByKey(keyStr:String):String{
			return XML(_xml.setting.(@key == keyStr)[0]).@value;
		}
		
	}
}
