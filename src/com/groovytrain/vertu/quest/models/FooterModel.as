package com.groovytrain.vertu.quest.models {
	import flash.events.IEventDispatcher;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterModel extends AbstractModel {

		private var _itemModels : Array = new Array();

		public function FooterModel(target : IEventDispatcher = null) {
			super(target);
		}

		override public function setData(xmlData : XML) : void {
			_xml = xmlData;
			_itemModels = new Array();
			
			for each (var itemNode : XML in _xml.item) {
				var fiModel : FooterItemModel = new FooterItemModel();
				fiModel.setData(itemNode);
				_itemModels.push(fiModel);
			}
		}

		public function getItemNode(idStr : String) : XML {
			return _xml.item.(@id == idStr)[0] as XML;
		} 
		
		public function getItemModel(idStr : String) : FooterItemModel {
			var fiModel : FooterItemModel = new FooterItemModel();
			fiModel.setData(getItemNode(idStr));
			return fiModel;
		}
		
		public function get itemModels() : Array {
			return _itemModels;
		}
	}
}
