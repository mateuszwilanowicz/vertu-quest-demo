package com.groovytrain.vertu.quest.components.contentswfs {
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class AnchorTrigger extends Sprite implements IAnchor {
		private var _scrollView : ContentScrollerView;		private var _anchorSprite : Sprite;
		private var _selected:Boolean = false;
		
		public function AnchorTrigger() {
			init();
		}

		private function init() : void {
			addEventListener("ALPHA_DONE", alphaDone);
			addEventListener("RESET_HANDLERS", resetHandlers);
		}
		
		public function alphaDone(e:Event = null):void {
			trace("AAAAAAAAAAAA alphaDone() "+this)	
			_selected = false;			
			var hitArea:Sprite = new Sprite();
			Artist.drawRect(hitArea, 0, 0, 188, 18, 0x000000, 1);
			hitArea.alpha = 0;
			addChild(hitArea);
			
			_scrollView = ContentScrollerView(parent.getChildByName("scrollContent"));
			_anchorSprite = (_scrollView.getChildByName("scrollContentSprite") as Sprite).getChildByName("anchor" + name.split("trigger")[1]) as Sprite;
			
			removeEventListener("ALPHA_DONE", alphaDone);
			
			ButtonInjector.injectButtonDefaults(this);
			
			addEventListener(MouseEvent.CLICK, clickHandler);
			addEventListener(MouseEvent.MOUSE_OVER, overHandler);
			addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		}
		
		private function resetHandlers(e:Event = null):void {
			
			if(hasEventListener(MouseEvent.CLICK))removeEventListener(MouseEvent.CLICK, clickHandler);
			if(hasEventListener(MouseEvent.MOUSE_OVER))removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
			if(hasEventListener(MouseEvent.MOUSE_OUT))removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
			
		}

		private function outHandler(e:MouseEvent) : void {
			visible = true;
			TweenLite.to(this, .5, { alpha: 1, tint: null, ease: Sine.easeOut } );

		}

		private function overHandler(e:MouseEvent) : void {
			visible = true;
			TweenLite.to(this, .2, { alpha: 1, tint: 0xFFFFFF, ease: Sine.easeOut } );
		}

		private function clickHandler(event : MouseEvent) : void {
			var yPos:Number = -1 * _anchorSprite.y;
			
			_scrollView.scrollToTo(yPos);

			_selected = true;			
			
		}
	}
}
