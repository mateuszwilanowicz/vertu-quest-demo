package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Sine;

	import com.asual.swfaddress.SWFAddress;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.FooterViewEvent;
	import com.groovytrain.vertu.quest.utils.FontFactory;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterView extends AbstractView {
		
		public static const THUMB_SCALE : Number = 0.9;
		private static const THUMBNAIL_OFF_ALPHA : Number = 0.35;
		
		private var _back : Sprite;
		private var _backGrad : Sprite;
		private var _buttons : Array;
		private var _thumbs : Array;
		
		private var _design : MovieClip;
		private var _lifestyle : MovieClip;
		private var _performance : MovieClip;
		
		private var _selectedCategory : MovieClip;
		private var _selectedThumb : ThumbWithReflection;
		
		private var _categoryNr : int;
		
		public var label : TextField;

		public function FooterView() {
			super();
			_thumbs = new Array();
			_buttons = new Array();
			init();
		}

		private function init() : void {
			
			_design = new MovieClip();
			_lifestyle = new MovieClip();
			_performance = new MovieClip();
						
			createDesignThums();
			createLifestyleThums();
			createPerformanceThums();

			_design.y = 67;
			_lifestyle.y = 67;
			_performance.y = 67;						
						
			_design.x = -115;
			_lifestyle.x = -115;
			_performance.x = -115;						
						
			_back = new AssetsManager.FOOTER_BG_3 as Sprite;
			_back.x = -115;
			
			addChild(_back);
			addChild(_design);
			addChild(_lifestyle);
			addChild(_performance);
			
			_design.alpha = 0;
			_lifestyle.alpha = 0;
			_performance.alpha = 0;					
			_back.alpha = 0;
		
		}
		
		
		

		private function thumbOut(event : MouseEvent) : void {
			var t : ThumbWithReflection = ThumbWithReflection(event.target);
			
			TweenLite.to(t.getChildByName("te"), .2, {alpha:0, ease:Quart.easeOut});
			
			if(_selectedThumb)TweenLite.to(_selectedThumb.getChildByName("te"), .5, {alpha:1, ease:Quart.easeOut, delay:.5});
			
			if(t != _selectedThumb) {			
				TweenLite.to(t, .5, { alpha:THUMBNAIL_OFF_ALPHA, scaleY: THUMB_SCALE, scaleX: THUMB_SCALE, ease:Quart.easeOut , delay: .2});
			}
		}

		private function thumbOver(event : MouseEvent) : void {
			
			var t : ThumbWithReflection = ThumbWithReflection(event.target);
			
			TweenLite.to(t.getChildByName("te"), .2, {alpha:1, ease:Quart.easeOut, delay: .2});
			
			if(t != _selectedThumb) {	
				if(_selectedThumb) TweenLite.to(_selectedThumb.getChildByName("te"), .2, {alpha:0, ease:Quart.easeOut});		
				TweenLite.to(t, .2, { alpha:1, scaleY: 1, scaleX: 1, ease:Quart.easeOut });
			}
		}

		private function thumbClick(event : MouseEvent) : void {
			var value : String = SWFAddress.getValue();
			var t : ThumbWithReflection = event.target as ThumbWithReflection;
			SWFAddress.setValue(cleanSwfAddressPath(AppController.getInstance().language + "/" + value.split("/")[2] + "/" + value.split("/")[3] + "/" + t.nr));
		}
		
		public function makeThumClick(n:Number):void {
			trace("MMMMMMMMMMMMMM makeThumClick( "+n+")");
			
			if(_selectedThumb)TweenLite.to(_selectedThumb.getChildByName("te"), .5, {alpha:0, ease:Quart.easeOut});
			if(_selectedThumb)TweenLite.to(_selectedThumb, .5, {alpha:THUMBNAIL_OFF_ALPHA, scaleY: THUMB_SCALE, scaleX: THUMB_SCALE, ease:Quart.easeOut});
			
			
			var t : ThumbWithReflection = _selectedCategory.getChildByName("thum"+n) as ThumbWithReflection;
			TweenLite.to(t, .5, { alpha:1, scaleY: 1, scaleX: 1, ease:Quart.easeOut, delay: 1.5 });
			TweenLite.to(t.getChildByName("te"), .5, {alpha:1, ease:Quart.easeOut, delay: 1.5});
			
			_selectedThumb = t;
		}
		
		private function cleanSwfAddressPath(valueStr : String) : String {
			while(valueStr.indexOf("/null") > -1) {
				valueStr = valueStr.split("/null").join("");
			}
			return valueStr;
		}
		
		public function hideAll():void {
			TweenLite.to(_design, 1, { alpha: 0, ease:Quart.easeOut}  );			TweenLite.to(_lifestyle, 1, { alpha: 0, ease:Quart.easeOut}  );			TweenLite.to(_performance, 1, { alpha: 0, ease:Quart.easeOut}  );			TweenLite.to(_back, 1, { alpha: 0, ease:Quart.easeOut}  );
		}
		
		public function showLifestyleThums() : void {
							
			_categoryNr = 1;
			_selectedCategory = _lifestyle;

			_design.alpha = 0;
			_lifestyle.alpha = 0;
			_performance.alpha = 0;					
			_back.alpha = 0;
			
			TweenLite.to(_back, 1, { alpha: 1, delay: 1, ease:Quart.easeOut}  );
			//TweenLite.to(_lifestyle, 1, { alpha: 1, delay: 1, ease:Quart.easeOut, onComplete: addressUpdate}  );
			
			_lifestyle.alpha = 1;
			
			for(var i:int = 0; i < AppController.getInstance().categories[1].modules.length; i++) {
				var t:ThumbWithReflection = _lifestyle.getChildByName("thum"+i) as ThumbWithReflection;
				t.alpha = 0;
				TweenLite.to(t, 1, { alpha: THUMBNAIL_OFF_ALPHA, delay: 1.5+(i*0.1), ease:Sine.easeInOut, onComplete: addressUpdate, onCompleteParams: [t]}  );
			}
			
			makeThumClick(Number(AppController.getInstance().moduleToLaunch));
			
			_design.y = 67;
			_lifestyle.y = 0;
			_performance.y = 67;
		}
		
		public function showDesignThums():void {
						
			_categoryNr = 0;
			_selectedCategory = _design;
			
			
			_design.alpha = 0;
			_lifestyle.alpha = 0;
			_performance.alpha = 0;					
			_back.alpha = 0;
			
			TweenLite.to(_back, 1, { alpha: 1, delay: 1, ease:Quart.easeOut}  );
			
			//TweenLite.to(_design, 1, { alpha: 1, delay: 1, ease:Quart.easeOut, onComplete: addressUpdate}  );
			
			_design.alpha = 1;
			
			for(var i:int = 0; i < AppController.getInstance().categories[0].modules.length; i++) {
				var t:ThumbWithReflection = _design.getChildByName("thum"+i) as ThumbWithReflection;
				t.alpha = 0;
				TweenLite.to(t, 1, { alpha: THUMBNAIL_OFF_ALPHA, delay: 1.5+(i*0.1), ease:Sine.easeInOut, onComplete: addressUpdate, onCompleteParams: [t]}  );
			}
			
			makeThumClick(Number(AppController.getInstance().moduleToLaunch));	
			
			_design.y = 0;
			_lifestyle.y = 67;
			_performance.y = 67;
		}
		
		
		public function showPerformanceThums():void {
			
			var value : String = SWFAddress.getValue();
			var end : String = value.split("/")[4];
			_categoryNr = 2;
			_selectedCategory = _performance;

			
			_design.alpha = 0;
			_lifestyle.alpha = 0;
			_performance.alpha = 0;					
			_back.alpha = 0;
			
			TweenLite.to(_back, 1, { alpha: 1, delay: 1, ease:Quart.easeOut}  );
			//TweenLite.to(_performance, 1, { alpha: 1, delay: 1, ease:Quart.easeOut, onComplete: addressUpdate}  );
			_performance.alpha = 1;
			
			for(var i:int = 0; i < AppController.getInstance().categories[2].modules.length; i++) {
				var t:ThumbWithReflection = _performance.getChildByName("thum"+i) as ThumbWithReflection;
				t.alpha = 0;
				TweenLite.to(t, 1, { alpha: THUMBNAIL_OFF_ALPHA, delay: 1.5+(i*0.1), ease:Sine.easeInOut, onComplete: addressUpdate, onCompleteParams: [t]}  );
			}

			makeThumClick(Number(AppController.getInstance().moduleToLaunch));
			
			_design.y = 67;
			_lifestyle.y = 67;
			_performance.y = 0;
			
		}
		
		private function addressUpdate(t:ThumbWithReflection = null):void {
//			dispatchEvent(new FooterViewEvent(FooterViewEvent.ENDADDRESSUPDAE,true,false));
//			
//			t.addEventListener(MouseEvent.CLICK, thumbClick);
//			t.addEventListener(MouseEvent.MOUSE_OVER, thumbOver);
//			t.addEventListener(MouseEvent.MOUSE_OUT, thumbOut);
			
		}
		
		// **************** LOOK OUT! A HACK *******************
		// CREATING CATEGORY MOVIECLIPS WITH ARRAY OF THUMBNAILS
		public function createLifestyleThums():void {
			
			var ar:Boolean = false;
			var positionHack:Number = 0;
			
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				positionHack = (AppController.getInstance().categories[1].modules.length+1) * 77;
				ar = true;
			}
			var className:String = AppController.getInstance().language + "_category_menu";
			var mylabel:TextField = FontFactory.generateTextField(AppController.getInstance().categoriesModels[1].title, className, 16, 0xD7D7D7, true, TextFieldAutoSize.CENTER);
		
			mylabel.y = 14;
			mylabel.width = 162;
			_lifestyle.addChild(mylabel);

			
			for(var i:int = 0; i < AppController.getInstance().categories[1].modules.length; i++) {
				var thum:ThumbWithReflection = new ThumbWithReflection();
				var image:MovieClip = thum.getChildByName("image") as MovieClip;
				image.gotoAndStop(i+AppController.getInstance().categories[0].modules.length+1);
				var ref:MovieClip = thum.getChildByName("toMask") as MovieClip;
				ref.gotoAndStop(i+1+AppController.getInstance().categories[0].modules.length);
				thum.nr = i;
				if(!ar) {
					thum.x = 115 + 162 + (i * 77) + 30;
				} else {
					thum.x = positionHack + 162 - (i * 77) - 30;
				}
				thum.y = 10;
				
				thum.alpha = THUMBNAIL_OFF_ALPHA;
								
				thum.scaleY = thum.scaleX = THUMB_SCALE;
				thum.name = "thum" + i;
				
				var s:String = AppController.getInstance().categories[1].modules[i].name;
				var h:MovieClip = thum.getChildByName("te") as MovieClip;
				
				h.alpha = 0;
				
				FontFactory.updateText(h.t, s, "footer_button");
				TextField(h.t).autoSize = TextFieldAutoSize.CENTER;				
				
				_lifestyle.addChild(thum);	
				
				thum.mouseChildren = false;
				thum.buttonMode = true;
				thum.addEventListener(MouseEvent.CLICK, thumbClick);
				thum.addEventListener(MouseEvent.MOUSE_OVER, thumbOver);
				thum.addEventListener(MouseEvent.MOUSE_OUT, thumbOut);
				if(ar) { h.t.y -= 6; }
			}
			if(!ar) {
				mylabel.x = 115 + 132 + (9 * 77);
			} else {
				mylabel.x = 115 ;
			}
		}
		
		public function createPerformanceThums():void {
			var ar:Boolean = false;
			var positionHack:Number = 0;
			
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				positionHack = (AppController.getInstance().categories[2].modules.length+1) * 77;
				ar = true;
			}
			var className:String = AppController.getInstance().language + "_category_menu";
			var mylabel:TextField = FontFactory.generateTextField(AppController.getInstance().categoriesModels[2].title, className, 16, 0xD7D7D7, true, TextFieldAutoSize.CENTER);
			mylabel.y = 14;
			mylabel.width = 162;
			_performance.addChild(mylabel);
			
			for(var i:int = 0; i < AppController.getInstance().categories[2].modules.length; i++) {
				var thum:ThumbWithReflection = new ThumbWithReflection();
				var image:MovieClip = thum.getChildByName("image") as MovieClip;
				image.gotoAndStop(1+i+AppController.getInstance().categories[0].modules.length+AppController.getInstance().categories[1].modules.length);
				var ref:MovieClip = thum.getChildByName("toMask") as MovieClip;
				ref.gotoAndStop(1+i+AppController.getInstance().categories[0].modules.length+AppController.getInstance().categories[1].modules.length);
				thum.nr = i;
				if(!ar) {
					thum.x = 115 + 162 + (i * 77) + 38 + 30;
				} else {
					thum.x = positionHack + 115 + 162 - (i * 77) - 38 - 55; 
				}
				thum.y = 10;
				
				thum.alpha = THUMBNAIL_OFF_ALPHA;
				
				thum.scaleY = thum.scaleX = THUMB_SCALE;
				thum.name = "thum" + i;
				
				
				var s:String = AppController.getInstance().categories[2].modules[i].name;
				var h:MovieClip = thum.getChildByName("te") as MovieClip;
				
				h.alpha = 0;
				
				FontFactory.updateText(h.t, s, "footer_button");	
				TextField(h.t).autoSize = TextFieldAutoSize.CENTER;
								
				_performance.addChild(thum);
				
				thum.mouseChildren = false;
				thum.buttonMode = true;
				thum.addEventListener(MouseEvent.CLICK, thumbClick);
				thum.addEventListener(MouseEvent.MOUSE_OVER, thumbOver);
				thum.addEventListener(MouseEvent.MOUSE_OUT, thumbOut);
				if(ar) { h.t.y -= 6; }
			}
			if(!ar) {
				mylabel.x = 115 + 132 + (9 * 77);
			} else {
				mylabel.x = 115;
			}
		}
		
		public function createDesignThums():void {
			var ar:Boolean = false;
			var positionHack:Number = 0;
			
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				positionHack = (AppController.getInstance().categories[0].modules.length+1) * 77;
				ar = true;
			}
			var className:String = AppController.getInstance().language + "_category_menu";
			
			var mylabel:TextField = FontFactory.generateTextField( AppController.getInstance().categoriesModels[0].title, className, 16, 0xD7D7D7, true, TextFieldAutoSize.CENTER);
			mylabel.y = 14;
			mylabel.width = 162;
			_design.addChild(mylabel);
			
			for(var i:int = 0; i < AppController.getInstance().categories[0].modules.length; i++) {
				
				var thum:ThumbWithReflection = new ThumbWithReflection();
				var image:MovieClip = thum.getChildByName("image") as MovieClip;
				image.gotoAndStop(i+1);
				var ref:MovieClip = thum.getChildByName("toMask") as MovieClip;
				ref.gotoAndStop(i+1);
				
				thum.nr = i;
				if(!ar) {
					thum.x = 115 + 162 + (i * 77) + 142 + 30;
				} else {
					thum.x = positionHack + 115 + 162 - (i * 77);
				}
				thum.y = 10;

				thum.alpha = THUMBNAIL_OFF_ALPHA;
				
				thum.scaleY = thum.scaleX = THUMB_SCALE;
				
				_design.addChild(thum);	
				
				thum.name = "thum" + i;
				
				var s:String = AppController.getInstance().categories[0].modules[i].name;
				var h:MovieClip = thum.getChildByName("te") as MovieClip;
				
				h.alpha = 0;

				FontFactory.updateText(h.t, s, "footer_button");
				TextField(h.t).autoSize = TextFieldAutoSize.CENTER;
				
				thum.mouseChildren = false;
				thum.buttonMode = true;
				thum.addEventListener(MouseEvent.CLICK, thumbClick);
				thum.addEventListener(MouseEvent.MOUSE_OVER, thumbOver);
				thum.addEventListener(MouseEvent.MOUSE_OUT, thumbOut);
				if(ar) { h.t.y -= 6; }
			}
			
			_selectedThumb = _design.getChildByName("thum0") as ThumbWithReflection;
			if(!ar) {
				mylabel.x = 115 + 132 + (9 * 77);
			} else {
				mylabel.x = 115;
			}
			
		}
		

		public function get back() : Sprite {
			return _back;
		}

		public function get backGrad() : Sprite {
			return _backGrad;
		}

		public function get buttons() : Array {
			return _buttons;
		}

		public function set buttons(buttons : Array) : void {
			_buttons = buttons;
		}

		public function get categoryNr() : int {
			return _categoryNr;
		}
	}
}
