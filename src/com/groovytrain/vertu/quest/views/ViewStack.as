package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.events.ViewStackEvent;
	import com.groovytrain.vertu.quest.utils.Artist;

	import flash.display.Sprite;
	import flash.display.Stage;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class ViewStack extends Sprite {

		private var _stack : Array = new Array();

		public function ViewStack() {
			init();
		}

		private function init() : void {
			_stack = new Array();
			
			Artist.drawRect(this, 0, 0, 970, 570, 0x000000, 0, 0.25, 0xCDCDCD, 0);
			
			addEventListener(ViewStackEvent.STAGE_RESIZED, stageResizedHandler);
		}
		
		

		private function stageResizedHandler(event : ViewStackEvent) : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
						
			for (var i : int = 0;i < _stack.length;i++) {
				var layer : LayerSprite = _stack[i] as LayerSprite;
				for (var v : int = 0;v < layer.numChildren;v++) {
					var tmpView : AbstractView = layer.getChildAt(v) as AbstractView;
					if(tmpView.orientation != null) {
						positionViewOnStage(tmpView);
					}
				}
			}
			
		}

		private function positionViewOnStage(tmpView : AbstractView) : void {
//			trace("positionViewOnStage::" + tmpView);
			tmpView.dispatchEvent(new ViewEvent(ViewEvent.REPOSITION_VIEW));
		}

		public function createLayer(layerId : String) : void {
			var layer : LayerSprite = new LayerSprite(layerId);
			addChild(layer);
			_stack.push(layer);
		}

		public function getLayer(layerId : String) : LayerSprite {
			for (var i : int = 0;i < _stack.length;i++) {
				var layer : LayerSprite = _stack[i] as LayerSprite;
				if(layer.id == layerId) {
					return layer;
				}
			}
			return null;
		}

		public function addViewToLayer(newView : AbstractView, layerId : String) : void {
			var layer : LayerSprite = getLayer(layerId);
			layer.addView(newView);
//			positionViewOnStage(newView);
		}

		public function showViewById(viewId : String, layer : String) : void {
			var theView : AbstractView = getViewById(viewId);
			addChild(theView);
			theView.show();
//			trace("showViewById");
		}

		public function getViewById(viewId : String) : AbstractView {
			for (var i : int = 0;i < _stack.length;i++) {
				var theLayer : LayerSprite = _stack[i] as LayerSprite;
				var theView : AbstractView = theLayer.findView(viewId);
				if(theView != null) {
					return theView;
				}
			}
			return null;
		}

		public function getVisibleViewsFromLayer(layerId : String) : Array {
			var layer : LayerSprite = getLayer(layerId);
			return layer.findVisibleView();
		}
		
		public function removeViewFromLayer(layerId:String, viewId:String) : void {
			var layerSprite:LayerSprite = getLayer(layerId);
			var theView:AbstractView = getViewById(viewId);

			layerSprite.removeView(theView);
			
		}
		
		public function moveLayerToTop(layerId : String) : void {
			addChild(getLayer(layerId));
		}
		
		
		public function reportOrder():void {
			//addChild(getLayer(layerName));
			for (var i : int = 0;i < numChildren;i++) {
				var layer : LayerSprite = getChildAt(i) as LayerSprite;
				trace("LAYER:" + layer.id);
			}
		}

		public function report() : void {
			trace("===================================================");
			trace("VIEW_STACK_REPORT:");
			for (var i : int = 0;i < _stack.length;i++) {
				var layer : LayerSprite = _stack[i] as LayerSprite;
				trace("LAYER:" + layer.id);
			}
			trace("===================================================");
		}

	}
}
