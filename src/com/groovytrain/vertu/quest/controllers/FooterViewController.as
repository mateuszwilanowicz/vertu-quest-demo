package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.plugins.*;

	import com.groovytrain.vertu.quest.events.FooterComboViewEvent;
	import com.groovytrain.vertu.quest.events.FooterViewEvent;
	import com.groovytrain.vertu.quest.generic.LanguageDirection;
	import com.groovytrain.vertu.quest.generic.ResourceType;
	import com.groovytrain.vertu.quest.models.FooterItemModel;
	import com.groovytrain.vertu.quest.models.FooterModel;
	import com.groovytrain.vertu.quest.views.AbstractView;
	import com.groovytrain.vertu.quest.views.FooterButtonView;
	import com.groovytrain.vertu.quest.views.FooterComboView;
	import com.groovytrain.vertu.quest.views.FooterView;

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterViewController extends AbstractViewController {
		private var _model : FooterModel;
		private var _buttonViews : Array;
		private var _popupOpened : Boolean = false;
		private var _currentButtonView : FooterButtonView;
		private var _backGrad : AbstractView;
		private static var _instance : FooterViewController;
		private var _vertuLogo : VertuLogo;
		
		private static function hidden() : void {
		}

		public static function getInstance() : FooterViewController {
			TweenPlugin.activate([GlowFilterPlugin]);			
			if( _instance == null ) {
				_instance = new FooterViewController(hidden);
			}
			return _instance;
		}

		public function FooterViewController(h : Function) {
			
			if (h !== hidden) {
				throw new Error("FooterViewController and can only be accessed through FooterViewController.getInstance()");
			}
		}

		public function start() : void {
			_buttonViews = new Array();
			var itemModels : Array = _model.itemModels;
			var gutter : Number = 82;
			var xPos : Number = 0;
			var rtl : Boolean = (AppController.getInstance().languageDirection == LanguageDirection.RTL);

			for (var i : int = 0;i < itemModels.length;i++) {
				var itemModel : FooterItemModel = itemModels[i] as FooterItemModel;
				var buttonView : FooterButtonView;
				
				if(itemModel.type == FooterItemModel.POPUP_COMBO_BOX) {
					buttonView = new FooterComboView(itemModel);
					buttonView.addEventListener(FooterComboViewEvent.MOUSE_STRAYED_OUT, mouseStayedOutHandler);
				} else {
					buttonView = new FooterButtonView(itemModel);
				}

				if(rtl) {
					buttonView.x = 970 - itemModel.x;
					// - buttonView.width;				} else {
					buttonView.x = itemModel.x;
				}

				if(itemModel.y) {
					buttonView.y = itemModel.y;
				} else {
					buttonView.y = 0;
				}

				if ( itemModel.title != "bg" && itemModel.title != "bg2" && itemModel.title != "bg3" && itemModel.title != "I") {
					buttonView.addEventListener(MouseEvent.CLICK, buttonClickedHandler);
				}
				view.addChild(buttonView);
									
				_buttonViews.push(buttonView);

				buttonView.alpha = 1;
				TweenLite.to(buttonView, 1.0, {alpha:1.0, delay:i * 0.2});

				xPos = buttonView.x + buttonView.textWidth + gutter;
			}
			
			var fv:FooterView = view as FooterView;

			fv.buttons = _buttonViews;
			
			_vertuLogo = new VertuLogo();
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				_vertuLogo.x = 848;	
			} else {
				_vertuLogo.x = 16;
			}
			_vertuLogo.y = 16;
			
			view.addChild(_vertuLogo);
			view.show();
			reposition();
		}

	

		private function buttonClickedHandler(event : MouseEvent) : void {

			var buttonView : FooterButtonView = event.target as FooterButtonView;

			// UPDATE OF THE CURRENTLY CLICKED BUTTON IS DISPATCHED BY SWFADRESS ON CHANGE FUNCTION
			/*
			_currentButtonView = buttonView;
			updateButtonStates();
			*/
			
			var butEvent : FooterViewEvent;
			
			trace("KKKKKKKKK languages clicked! " + buttonView.id);
			
			if (buttonView.model.type == FooterItemModel.POPUP_COMBO_BOX) {
				
				showHidePopup(FooterComboView(buttonView));
			} else {
				switch(buttonView.id) {
					case ResourceType.EXPERIENCE:
						trace("KKKKKKKKK experience clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.EXPERIENCE_THE_PHONE);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.BOUTIQUES:
//						trace("KKKKKKKKK BOUTIQUES clicked!");
//						butEvent = new FooterViewEvent(FooterViewEvent.BOUTIQUES);
//						butEvent.data.model = buttonView.model;
//						dispatchEvent(butEvent);
						var url:String = "http://www.vertu.com/in-"+AppController.getInstance().language+"/#in-"+AppController.getInstance().language+"_where-to-buy";
					    var request:URLRequest = new URLRequest(url);
					    try {
					        navigateToURL(request, '_blank');
					    } catch (e:Error) {
					        trace("Error occurred!");
					    }
						break;
					case ResourceType.VERTUDOTCOM:
//						trace("KKKKKKKKK VERTUDOTCOM clicked!");
//						butEvent = new FooterViewEvent(FooterViewEvent.VERTUDOTCOM);
//						butEvent.data.model = buttonView.model;
//						dispatchEvent(butEvent);
						var url2:String = "http://www.vertu.com/in-"+AppController.getInstance().language+"/#in-"+AppController.getInstance().language+"_";
					    var request2:URLRequest = new URLRequest(url2);
					    try {
					        navigateToURL(request2, '_self');
					    } catch (e:Error) {
					        trace("Error occurred!");
					    }
						break;
					case ResourceType.SPECIFICATIONS:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.SPECIFICATIONS);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.COLLECTION:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.THE_COLLECTION);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.REGISTER:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.REGISTER);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.RANGE:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.RANGE);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.DESIGN:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.DESIGN);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.LIFESTYLE:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.LIFESTYLE);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					case ResourceType.PERFORMANCE:
//						trace("KKKKKKKKK specifications clicked!");
						butEvent = new FooterViewEvent(FooterViewEvent.PERFORMANCE);
						butEvent.data.model = buttonView.model;
						dispatchEvent(butEvent);
						break;
					default:
					break;
				} 	
			}
		}

		private function mouseStayedOutHandler(event : FooterComboViewEvent) : void {
			if(_popupOpened) {
				showHidePopup(event.target as FooterComboView);
			}
		}

		public function updateButtonStates() : void {
			for (var i : int = 0; i < _buttonViews.length; i++) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				if(btnVw.selected) {
					btnVw.glow.gotoAndPlay("off");
					btnVw.label.textColor = FooterButtonView.NORMAL_TEXT_COLOUR;
					btnVw.selected = false;
				}
			}
			if(_currentButtonView) {
				_currentButtonView.selected = true;
				_currentButtonView.glow.gotoAndStop(19);
				_currentButtonView.label.textColor = FooterButtonView.ROLLOVER_TEXT_COLOUR;
			}
		}

		private function showHidePopup(comboView : FooterComboView) : void {
			var popup : Sprite = comboView.popupSprite;
			if(_popupOpened) {
				comboView.hidePopup();
				_popupOpened = false;
			} else {
				view.addChild(comboView.popupSprite);
				comboView.showPopup();
				_popupOpened = true;
			}
		}
		
		public function fadeBackMenu():void {
			for (var i : int = 0; i < _buttonViews.length; i++) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				// buttonViewOn(btnVw);
				if(btnVw.type != FooterItemModel.LOGO_STATIC) TweenLite.to(btnVw, 1, {alpha:0, ease:Quart.easeOut});
			}
		}
		
		public function fadeInMenu():void {
			for (var i : int = 0; i < _buttonViews.length; i++) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				if(btnVw.type != FooterItemModel.LOGO_STATIC) TweenLite.to(btnVw, 1, {alpha:1, ease:Quart.easeOut});
			}
		}
		
		public function selectButtonById(id : String):void {
			for (var i : int = 0; i < _buttonViews.length; i++) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				if (btnVw.id == id) {
					_currentButtonView = btnVw;
					updateButtonStates();
				}
			}
		}
		
		public function showExMenu() : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			var fv:FooterView = view as FooterView;
			fv.hideAll();
			
			for (var i : int = 0 ; i < _buttonViews.length; i++ ) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				if (btnVw.model.type == FooterItemModel.EX_MENU_TYPE ) {
					 TweenLite.to(btnVw, 1, { y:-45, ease: Quart.easeInOut });
				} else if (btnVw.model.type == FooterItemModel.LOW_MENU_TYPE ) {
					TweenLite.to(btnVw, 1, { y: 45, ease: Quart.easeInOut });					 
				} else {
					TweenLite.to(btnVw, 1, { y: 0, ease: Quart.easeInOut });
				}
			}
//			TweenLite.to(view, 1, { y: theStage.stageHeight - 65,ease: Quart.easeOut});
//			_catMenuVisible = true;
		}
		
		public function showSpMenu() : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			
			var fv:FooterView = view as FooterView;
			fv.hideAll();
			
			for (var i : int = 0 ; i < _buttonViews.length; i++ ) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				
				if (btnVw.model.type == FooterItemModel.SP_MENU_TYPE ) {
					 TweenLite.to(btnVw, 1, { y:-45, ease: Quart.easeInOut });
				} else if (btnVw.model.type == FooterItemModel.LOW_MENU_TYPE ) {
					TweenLite.to(btnVw, 1, { y: 45, ease: Quart.easeInOut });					 
				} else {
					TweenLite.to(btnVw, 1, { y: 0, ease: Quart.easeInOut });
				}
			}
		}

		public function hideMenu() : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			
			for (var i : int = 0 ; i < _buttonViews.length; i++ ) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				if (btnVw.model.type == FooterItemModel.EX_MENU_TYPE || btnVw.model.type == FooterItemModel.SP_MENU_TYPE) {
					TweenLite.to(btnVw, 1, {y:67, ease:Quart.easeInOut});
				} else if (btnVw.model.type == FooterItemModel.LOW_MENU_TYPE ) {
					TweenLite.to(btnVw, 1, { y: 67, ease: Quart.easeInOut });					 
				} else {
					TweenLite.to(btnVw, 1, { y: 67, ease: Quart.easeInOut, delay: .3 });
				}
			}
		}
		
		public function hideSecondMenu() : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			
			for (var i : int = 0 ; i < _buttonViews.length; i++ ) {
				var btnVw : FooterButtonView = _buttonViews[i] as FooterButtonView;
				if (btnVw.model.type == FooterItemModel.EX_MENU_TYPE || btnVw.model.type == FooterItemModel.SP_MENU_TYPE) {
					TweenLite.to(btnVw, 1, {y:67, ease:Quart.easeInOut});
				} else if (btnVw.model.type == FooterItemModel.LOW_MENU_TYPE ) {
					TweenLite.to(btnVw, 1, { y: 45, ease: Quart.easeInOut });					 
				} else {
					TweenLite.to(btnVw, 1, { y: 0, ease: Quart.easeInOut, delay: .3 });
				}
			}
		}

		override public function reposition() : void {
			var theStage : Stage = AppController.getInstance().base.stage as Stage;
			if(theStage) {
				var xPos : Number = 0;
				var yPos : Number = 0;
	
				xPos = (theStage.stageWidth - 970) / 2;
				yPos = theStage.stageHeight - 67;
				view.x = Math.floor(xPos);
				view.y = Math.floor(yPos);
			}
		}

		public function get model() : FooterModel {
			return _model;
		}

		public function set model(model : FooterModel) : void {
			_model = model;
		}

		public function get backGrad() : AbstractView {
			return _backGrad;
		}

		public function set backGrad(backGrad : AbstractView) : void {
			_backGrad = backGrad;
		}

		public function get currentButtonView() : FooterButtonView {
			return _currentButtonView;
		}

		public function set currentButtonView(currentButtonView : FooterButtonView) : void {
			_currentButtonView = currentButtonView;
		}

		public function get vertuLogo() : VertuLogo {
			return _vertuLogo;
		}
	}
}
