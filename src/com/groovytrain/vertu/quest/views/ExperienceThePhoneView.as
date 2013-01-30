package com.groovytrain.vertu.quest.views {
	import gs.easing.Quart;
	import gs.TweenLite;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.controllers.AppController;

	import flash.display.Sprite;
	import flash.display.Stage;
	/**
	 * @author mateuszw
	 */
	public class ExperienceThePhoneView extends AbstractPageView {
		 

		private var _lpi : LandingPageImage;

		public function ExperienceThePhoneView() {
			super();
			init();
		}

		public function init():void {
			
			_lpi = new LandingPageImage();
			_bg = new Sprite();
			addChild(_bg);
			addChild(_lpi);
		}

		override public function show() : void {
			alpha = 0;
			_lpi.alpha = 1;
			visible = true;
			_lpi.gotoAndPlay(1);
			TweenLite.to(this, AppController.TWEEN_IN_TIME, { alpha: 1, ease:Sine.easeOut, delay: AppController.TWEEN_DELAY_TIME});
		}
		
		override public function scaleAndReposition():void {
		
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			if(stg) {
				var theStageWidth:Number = Number(stg.stageWidth + 0);
				var theStageHeight:Number = Number(stg.stageHeight + 0);
				var multiplyer : Number = Math.max(( theStageHeight - 67 ) / height, theStageWidth / width);
							
				x = (theStageWidth - width) / 2;
				y = Math.min(((theStageHeight - 67) - height) / 2, (theStageHeight - 67 - height));
			}				
			
		}

		public function get lpi() : LandingPageImage {
			return _lpi;
		}

	}
}
