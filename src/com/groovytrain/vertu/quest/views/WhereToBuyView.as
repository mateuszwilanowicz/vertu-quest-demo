package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import gs.TweenLite;
	import gs.easing.Quart;

	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.events.WtbComboBoxEvent;
	import com.groovytrain.vertu.quest.models.WtbComboRowModel;
	import com.groovytrain.vertu.quest.utils.Artist;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class WhereToBuyView extends AbstractPageView {
		private var _back 							: Sprite;
		private var _countriesComboBox 				: WtbComboBox;
		private var _citiesComboBox 				: WtbComboBox;
		private var _storesComboBox 				: WtbComboBox;
		private var _storeDetailView 				: WtbStoreDetailView;
		private var _closeButton 					: Sprite;
		
		public function WhereToBuyView() {
			super();
			
			init();
		}

		private function init() : void {
			_closeButton = new AssetsManager.CLOSE_BUTTON() as Sprite;
			
			_back = new Sprite();
			Artist.drawRect(_back, 0, 0, 970, 570, 0x000000, 1, 0, 0, 0);
			_back.alpha = 0;
			
			_countriesComboBox = new WtbComboBox();
			_countriesComboBox.name = "countriesComboBox";
			_countriesComboBox.y = 100;			
			_citiesComboBox = new WtbComboBox();
			_citiesComboBox.name = "citiesComboBox";			_citiesComboBox.y = 130;
			
			_storesComboBox = new WtbComboBox();
			_storesComboBox.name = "storesComboBox";
			_storesComboBox.y = 160;
			
			_countriesComboBox.x = _citiesComboBox.x = _storesComboBox.x = 60;
			
			_countriesComboBox.addEventListener(WtbComboBoxEvent.DROP_DOWN_OPENING, dropDownOpeningHandler);
			_citiesComboBox.addEventListener(WtbComboBoxEvent.DROP_DOWN_OPENING, dropDownOpeningHandler);
			_storesComboBox.addEventListener(WtbComboBoxEvent.DROP_DOWN_OPENING, dropDownOpeningHandler);
			
			_countriesComboBox.addEventListener(WtbComboBoxEvent.SELECTION_CHANGED, countriesSelectedHandler);
			_citiesComboBox.addEventListener(WtbComboBoxEvent.SELECTION_CHANGED, citiesSelectedHandler);
			_storesComboBox.addEventListener(WtbComboBoxEvent.SELECTION_CHANGED, storesSelectedHandler);
			
			_storeDetailView = new WtbStoreDetailView();
			_storeDetailView.x = 430;			_storeDetailView.y = 100;
			
			addChild(_back);
			addChild(_closeButton);
			
			addEventListener(ViewEvent.REPOSITION_VIEW, repositionViewHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler);
			_closeButton.addEventListener(MouseEvent.CLICK, closeClickedHandler);
		}

		private function closeClickedHandler(event : MouseEvent) : void {
			var mEvent : ModuleEvent = new ModuleEvent(ModuleEvent.CLOSE_CLICKED);
			dispatchEvent(mEvent);
		}
		private function closeOutHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5 , { tint: null, ease: Quart.easeOut });		
		}

		private function closeOverHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5 , { tint: 0xFFFFFF, ease: Quart.easeOut });
		}
		
		private function repositionViewHandler(event : ViewEvent) : void {
			scaleAndReposition();
		}

		
		private function dropDownOpeningHandler(event : WtbComboBoxEvent) : void {
			var combo : WtbComboBox = WtbComboBox(event.target);
			addChild(combo);
			
			if(combo.name == "countriesComboBox") {
				
				if(contains(_storesComboBox)) {
					_storesComboBox.destroy();
					removeChild(_storesComboBox);
				}
				
				if(contains(_citiesComboBox)) {
					_citiesComboBox.destroy();
					removeChild(_citiesComboBox);
				}
			}else if(combo.name == "citiesComboBox") {
				
				if(contains(_storesComboBox)) {
					_storesComboBox.destroy();
					removeChild(_storesComboBox);
				}
			}
		}

		private function storesSelectedHandler(event : WtbComboBoxEvent) : void {
			if(_storesComboBox.selectedModel() != null) {
				var storeNode : XML = WtbComboRowModel(_storesComboBox.selectedModel()).data as XML;
				var evt : WtbComboBoxEvent = new WtbComboBoxEvent(WtbComboBoxEvent.STORE_CHOSEN);
				evt.data.storeNode = storeNode;
				dispatchEvent(evt);
			}
		}

		private function citiesSelectedHandler(event : WtbComboBoxEvent) : void {
			if(_citiesComboBox.selectedModel() != null) {
				var cityNode : XML = WtbComboRowModel(_citiesComboBox.selectedModel()).data as XML;
			
				for each  (var store : XML in cityNode.store) {
				
					var rowModel : WtbComboRowModel = new WtbComboRowModel();
					rowModel.setData(store);
					_storesComboBox.addRow(rowModel);
				}
				addChild(_storesComboBox);
			}
		}

		private function countriesSelectedHandler(event : WtbComboBoxEvent) : void {
			if(_countriesComboBox.selectedModel() != null) {
				var countryNode : XML = WtbComboRowModel(_countriesComboBox.selectedModel()).data as XML;
				for each  (var city : XML in countryNode.region.city) {
					var rowModel : WtbComboRowModel = new WtbComboRowModel();
					rowModel.setData(city);
					_citiesComboBox.addRow(rowModel);
				}
				addChild(_citiesComboBox);
				trace("countriesSelectedHandler:::" + _citiesComboBox);
				trace(_citiesComboBox.visible);				trace(_citiesComboBox.alpha);				trace(_citiesComboBox.x);				trace(_citiesComboBox.y);				trace(contains(_citiesComboBox));
			}
		}

		public function reveal(countriesArr : Array) : void {
			alpha = 1;
			_back.alpha = 0;
			
			TweenLite.to(_back, 1, {alpha:1});
			
			for (var i : int = 0;i < countriesArr.length;i++) {
				var rowModel : WtbComboRowModel = new WtbComboRowModel();
				rowModel.setData(WtbComboRowModel(countriesArr[i]).data as XML);
				_countriesComboBox.addRow(rowModel);
				
				//trace(rowModel.label);
			}
			
			_countriesComboBox.alpha = 0;
			TweenLite.to(_countriesComboBox, 1.2, {alpha:1});
			addChild(_countriesComboBox);
			show();
		}

		public function displayStoreDetail(loadedImgSprite : Sprite) : void {
			addChild(_storeDetailView);
			_storeDetailView.displayDetail(_storesComboBox.selectedModel(), loadedImgSprite);
			
		}
		
		
		
		override public function scaleAndReposition():void {
					
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			var theStageWidth:Number = Number(stg.stageWidth + 0);
			var theStageHeight:Number = Number(stg.stageHeight + 0);
				 
			x = (theStageWidth - 970) / 2;
			y = (theStageHeight - 570) / 2;
			
			_bg.width = theStageWidth;
			_bg.height = theStageHeight;		 
			
			_bg.x = ((970 - theStageWidth) / 2) + ((theStageWidth - _bg.width) / 2);
			_bg.y = ((570 - theStageHeight) / 2) + ((theStageHeight - _bg.height) / 2);
			
		}
		
	}
}
