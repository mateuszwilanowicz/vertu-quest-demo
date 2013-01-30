package com.groovytrain.vertu.quest.views {
	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class LayerSprite extends Sprite {

		private var _id : String;		private var _views : Array;

		public function LayerSprite(layerId : String) {
			_id = layerId;
			_views = new Array();
		}

		public function addView(newView : AbstractView) : void {
			_views.push(newView);
			addChild(newView);
		}

		public function removeView(theView : AbstractView) : void {
			
			for (var i : int = 0;i < _views.length;i++) {
				if(AbstractView(_views[i]).id == theView.id){
					_views.splice(i, 1);
				}
			}
			removeChild(theView);
		}
		
		public function findView(viewId : String) : AbstractView {
			
			for (var i : int = 0;i < _views.length;i++) {
				if(AbstractView(_views[i]).id == viewId){
					return AbstractView(_views[i]);
				}
			}
			return null;
		}
		
		public function findVisibleView() : Array{
			var visViews:Array = new Array();
			for (var i : int = 0;i < _views.length;i++) {
				if(AbstractView(_views[i]).visible){
					visViews.push(AbstractView(_views[i]));
				}
			}
			return visViews;
		}
		
		public function get id() : String {
			return _id;
		}

		public function set id(id : String) : void {
			_id = id;
		}

	}
}
