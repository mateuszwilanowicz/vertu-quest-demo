package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.controllers.AppController;
	import gs.easing.Quart;
	import com.groovytrain.vertu.quest.utils.Artist;
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.events.ViewEvent;

	import flash.display.Sprite;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AbstractView extends Sprite implements IView {

		protected var _orientation : String;		protected var _align : String;		protected var _id : String;
		protected var _bg : Sprite;

		public function AbstractView() {
			_bg = new Sprite();

			addChild(_bg);
		
			hide();
		}

		public function show() : void {
			alpha = 0;
			visible = true;
			TweenLite.to(this, AppController.TWEEN_IN_TIME, {alpha:1, ease:Sine.easeOut, delay:AppController.TWEEN_DELAY_TIME});
						
		}
		
		public function hide() : void {
			dispatchEvent(new ViewEvent(ViewEvent.HIDDEN));
			visible = false;
			
		}

		public function putAway() : void {
			dispatchEvent(new ViewEvent(ViewEvent.PUTTING_AWAY_VIEW));
			TweenLite.to(this, AppController.TWEEN_OUT_TIME, {alpha:0, ease:Sine.easeOut, onComplete:hide});
		}

		public function get id() : String {
			return _id;
		}

		public function set id(id : String) : void {
			_id = id;
		}

		public function get orientation() : String {
			return _orientation;
		}

		public function set orientation(orientation : String) : void {
			_orientation = orientation;
		}

		public function get align() : String {
			return _align;
		}

		public function set align(align : String) : void {
			_align = align;
		}

		public function scaleAndReposition() : void {
			
		}
	}
}
