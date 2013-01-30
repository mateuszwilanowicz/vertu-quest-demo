package com.groovytrain.vertu.quest.views {
	import gs.TweenLite;
	import gs.easing.Quart;
	import gs.easing.Sine;

	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.controllers.RegisterController;
	import com.groovytrain.vertu.quest.events.ModuleEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.events.WtbComboBoxEvent;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.models.CountryComboModel;
	import com.groovytrain.vertu.quest.models.TitleComboModel;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;
	import com.groovytrain.vertu.quest.utils.FontFactory;

	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	/**
	 * @author mateuszw
	 */
	public class RegisterView extends AbstractPageView {
		private static const BASE_LINE : Number = 70;
		private static const FN : String = "FIRST NAME";
		private static const LN : String = "LAST NAME";
		private static const AD : String = "EMAIL ADDRESS";
		private static const CD : String = "CONFIRM EMAIL ADDRESS";
		private var _formBg : Sprite;
		private var _back : Sprite;
		private var _countriesComboBox : RegisterComboBox;
		private var _titleComboBox : TitleComboBox;
		private var _closeButton : Sprite;
		private var _titleText : TextField;
		private var _copyText : TextField;
		private var _formTitle : TextField;
		private var _firstName : TextField;
		private var _seccondName : TextField;
		private var _emailAddress : TextField;
		private var _confirmAddress : TextField;
		private var _firstNameBg : InputBg = new InputBg();
		private var _seccondNameBg : InputBg = new InputBg();
		private var _emailAddressBg : InputBg = new InputBg();
		private var _confirmAddressBg : InputBg = new InputBg();
		private var _submitBtn : Sprite;
		private var _submitHintBox : Sprite;
		private var _errorPlane : MovieClip;
		private var _errorPlane2 : MovieClip;
		private var _errorPlane3 : MovieClip;
		private var _register : Sprite;
		private var _emailRegExp : RegExp = /^[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))$/ ;
		private var _submited : Boolean;
		private var _privacyLink : String;
		private var _one : Number;		private var _two : Number;
		private var _ar : Boolean = false;

		public function RegisterView() {
			super();

			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				_one = 450;
				_two = 0;
				_ar = true;
			} else {
				_one = 0;
				_two = 650;
			}

			// trace( _emailRegExp.test( "flepstudio@gmail.com" ) );
			
			// init();
		}

		public function drawContent() : void {
			// trace(Font.enumerateFonts(false)[0].fontName);

			var regXml : XML = RegisterController.getInstance().countriesXml;

			alpha = 0;

			_errorPlane = new AssetsManager.ERROR_BG_SPRITE() as MovieClip;
			_errorPlane.gotoAndStop(Number(_ar?2:1));
			var t : TextField = _errorPlane.getChildByName("label") as TextField;
			// "Invalid email address!";
			t.embedFonts = true;
			FontFactory.updateText(t, regXml.errorinvalidemail.text());

			_errorPlane2 = new AssetsManager.ERROR_BG_SPRITE() as MovieClip;
			_errorPlane2.gotoAndStop(Number(_ar?2:1));
			var t2 : TextField = _errorPlane2.getChildByName("label") as TextField;
			t2.embedFonts = true;
			FontFactory.updateText(t2, regXml.errorinvalidemail.text());
			// "Emails do not match!";

			_errorPlane3 = new AssetsManager.ERROR_BG_SPRITE() as MovieClip;
			_errorPlane3.gotoAndStop(Number(_ar?2:1));
			var t3 : TextField = _errorPlane3.getChildByName("label") as TextField;
			
			t3.embedFonts = true;
			FontFactory.updateText(t3, regXml.errorfillallfields.text());
			// "Please fill all the fields!";

			_submitBtn = new AssetsManager.SUBMIT_BG() as Sprite;
			ButtonInjector.injectButtonDefaults(_submitBtn);
			_submitHintBox = new AssetsManager.SUBMIT_HINT_BOX_BG() as Sprite;
			_closeButton = new AssetsManager.CLOSE_BUTTON() as Sprite;
			_back = new Sprite();
			Artist.drawRect(_back, 0, 0, 970, 570, 0x000000, 1, 0, 0, 0);

			_back.addChild(new AssetsManager.REG_BG() as Sprite);
			_back.alpha = 0;

			// TweenLite.to(_back,.5,{tint:0x999999});

			_formBg = new Sprite();
			Artist.drawRect(_formBg, 0, 0, 290, 490, 0x000000, .5, 0, 0, 0);

			_formBg.x = _two;
			_formBg.y = BASE_LINE;

			// arial font
			trace("RRRRRRRRRRRRRRRRRRRRRRRRRRRR Register View Title");
			
			_titleText = FontFactory.generateTextField(regXml.title.text(), AppController.getInstance().language + "_title", 16, 0xD7D7D7);
			_titleText.x = _one + 20;
			_titleText.y = _formBg.y + 20;
			_titleText.width = 363;

			var copyText : String = regXml.copy.text();
			// "Vertu invites you to be the first to find out more about the new Constellation Quest Collection including special store previews, <br/>as well as other select Vertu handsets and services.";
			_copyText = FontFactory.generateTextField(copyText, AppController.getInstance().language + "_copy", 11, 0xFEFEFE, true);
			_copyText.width = 360;
			_copyText.x = _one + 20;
			_copyText.y = _titleText.y + 30;

			// _formTitle = FontFactory.generateTextField("Please complete your personal details.", AppController.getInstance().language + "_copy", 11, 0xFEFEFE);
			_formTitle = FontFactory.generateTextField(regXml.formtitle.text(), AppController.getInstance().language + "_copy", 11, 0xFEFEFE);
			_formTitle.x = _two + 20;
			_formTitle.y = _formBg.y + 20;

			_titleComboBox = new TitleComboBox();
			_titleComboBox.name = "titleComboBox";
			_titleComboBox.y = _formTitle.y + 40;

			_firstName = FontFactory.generateInputField(regXml.firstname.text());
//			_firstName.border = true;
			_firstName.name = regXml.firstname.text();
			_firstName.x = _two + 20 + 10;
			_firstName.y = _titleComboBox.y + 40 + 4;
			_firstNameBg.x = _two + 20;
			_firstNameBg.y = _titleComboBox.y + 40;

			_seccondName = FontFactory.generateInputField(regXml.lastname.text());
			_seccondName.name = regXml.lastname.text();
			_seccondName.x = _two + 20 + 10;
			_seccondName.y = _firstName.y + 40 + 4;
			_seccondNameBg.x = _two + 20;
			_seccondNameBg.y = _firstName.y + 40;

			_emailAddress = FontFactory.generateInputField(regXml.email.text());
			_emailAddress.name = regXml.email.text();
			_emailAddress.x = _two + 20 + 10;
			_emailAddress.y = _seccondName.y + 40 + 4;
			_emailAddressBg.x = _two + 20;
			_emailAddressBg.y = _seccondName.y + 40;

			_confirmAddress = FontFactory.generateInputField(regXml.confirmemail.text());
			_confirmAddress.name = regXml.confirmemail.text();
			_confirmAddress.x = _two + 20 + 10;
			_confirmAddress.y = _emailAddress.y + 40 + 4;
			_confirmAddressBg.x = _two + 20;
			_confirmAddressBg.y = _emailAddress.y + 40;

			_submitBtn.x = _formBg.x + (_formBg.width / 2) - ( _submitBtn.width / 2 );
			_submitBtn.y = _confirmAddress.y + 90;
			var oldSubmitTf : TextField = TextField(_submitBtn.getChildByName("t"));
			var arrowSprite : Sprite = Sprite(_submitBtn.getChildByName("arrow"));
			oldSubmitTf.visible = false;

			var submitTf : TextField = FontFactory.generateTextField(regXml.submit.text(), null, 10, 0xFFFFFF, false);
			submitTf.width = oldSubmitTf.width;
			var combinedWidth : Number = submitTf.textWidth + arrowSprite.width + 12;
			submitTf.x = (110 - combinedWidth) * 0.5;
			submitTf.y = oldSubmitTf.y;

			arrowSprite.x = submitTf.x + submitTf.textWidth + 12;
			_submitBtn.addChild(submitTf);

			_submitHintBox.x = _formBg.x + (_formBg.width / 2) - ( _submitHintBox.width / 2 ) + 10;
			_submitHintBox.y = _submitBtn.y + 50;
			var privacyTf : TextField = TextField(_submitHintBox.getChildByName("privacyTf"));
			privacyTf.visible = false;

			var newPrivacyTf : TextField = FontFactory.generateTextField(regXml.privacy.text(), FontFactory.ARIAL_FONT_NAME, 11, 0xEFEFEF, true, TextFieldAutoSize.LEFT);
			newPrivacyTf.x = privacyTf.x;
			newPrivacyTf.y = privacyTf.y;
			newPrivacyTf.width = privacyTf.width - 5;
			newPrivacyTf.gridFitType = GridFitType.SUBPIXEL;
			
			
			FontFactory.updateText(newPrivacyTf, regXml.privacy.text());
			/*
			newPrivacyTf.embedFonts = false;
			newPrivacyTf.antiAliasType = AntiAliasType.ADVANCED;
			newPrivacyTf.thickness = -50;
			newPrivacyTf.alpha = 0.94;

			//FontFactory.updateText(newPrivacyTf, regXml.privacy.text());

			newPrivacyTf.addEventListener(MouseEvent.CLICK, privacyClickedHandler);

			_privacyLink = "<p href=" + newPrivacyTf.htmlText.split("<p href=")[1];
			_privacyLink = _privacyLink.split("</p>")[0] + "</p>";
			 */
			var line : Sprite = new Sprite();
			line.name = "line";
			_submitHintBox.addChild(line);
			_submitHintBox.addChild(newPrivacyTf);
			
			trace("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
			trace(newPrivacyTf.htmlText);
			trace("WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW");
			
			//

			_firstName.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			_firstName.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			_firstName.addEventListener(Event.CHANGE, onChangeHandler);

			_seccondName.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			_seccondName.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			_seccondName.addEventListener(Event.CHANGE, onChangeHandler);

			_emailAddress.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			_emailAddress.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			_emailAddress.addEventListener(Event.CHANGE, onChangeHandler);
			_emailAddress.addEventListener(TextEvent.TEXT_INPUT, onEmailInput);

			_confirmAddress.addEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			_confirmAddress.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutHandler);
			_confirmAddress.addEventListener(Event.CHANGE, onConfirmInput, false, 0);
			_confirmAddress.addEventListener(TextEvent.TEXT_INPUT, onConfirmInput, false, 1);

			_submitBtn.addEventListener(MouseEvent.MOUSE_OVER, onSubmitOver);
			_submitBtn.addEventListener(MouseEvent.MOUSE_OUT, onSubmitOut);
			_submitBtn.addEventListener(MouseEvent.CLICK, onSubmitClick);

			_countriesComboBox = new RegisterComboBox();
			_countriesComboBox.name = "countriesComboBox";
			_countriesComboBox.x = _titleComboBox.x = _two + 20;
			_countriesComboBox.y = _confirmAddress.y + 40;
			var countryComboTf : TextField = TextField(_countriesComboBox.titleTf);
			/*
			countryComboTf.visible = false;

			var newComboTf : TextField = FontFactory.generateTextField('<span class="zh_copy">'+regXml.countries.@default+'</span>', null, 10, 0xFFFFFF, true);
			newComboTf.x = countryComboTf.x;
			newComboTf.y = countryComboTf.y;
			newComboTf.width = countryComboTf.width;
			_countriesComboBox.addChild(newComboTf);
			 */
			countryComboTf.embedFonts = true;
			FontFactory.updateText(countryComboTf, '<span class="' + AppController.getInstance().language + '_copy">' + regXml.countries.@default + '</span>');

			Artist.drawRect(_bg, _formTitle.x - 20, _formTitle.y - 20, 290, _countriesComboBox.y + 20, 0x000000, 0.0, 0, 0, 0);

			_countriesComboBox.addEventListener(WtbComboBoxEvent.DROP_DOWN_OPENING, countriesDropDownOpeningHandler);
			_titleComboBox.addEventListener(WtbComboBoxEvent.DROP_DOWN_OPENING, titleDropDownOpeningHandler);

			_countriesComboBox.addEventListener(WtbComboBoxEvent.SELECTION_CHANGED, countriesSelectedHandler);
			_titleComboBox.addEventListener(WtbComboBoxEvent.SELECTION_CHANGED, titleSelectedHandler);

			addChild(_back);
			addChild(_bg);
			addChild(_formBg);

			addChild(_firstNameBg);
			addChild(_seccondNameBg);
			addChild(_emailAddressBg);
			addChild(_confirmAddressBg);

			addChild(_titleText);
			addChild(_copyText);
			addChild(_formTitle);
			addChild(_firstName);
			addChild(_seccondName);
			addChild(_emailAddress);
			addChild(_confirmAddress);
			addChild(_submitBtn);
			addChild(_submitHintBox);
			// addChild(_closeButton);
			
			_firstName.tabIndex = 0;
			_seccondName.tabIndex = 0;
			_emailAddress.tabIndex = 0;
			_confirmAddress.tabIndex = 0;
			_submitBtn.tabIndex = 0;
			
			addEventListener(ViewEvent.REPOSITION_VIEW, repositionViewHandler);

			// RED DOTS TO LOCALIZE REGISTRATION POINTS

			/*
			_register = new Sprite();
			Artist.drawRect(_register, -5, -5, 10, 10, 0xFF0000, 1, 0, 0 ,0);
			Artist.drawRect(_register, -1, -1, 2, 2, 0xFFFFFF, 1, 0, 0 ,0);
			var backRegister:Sprite = new Sprite();
			Artist.drawRect(backRegister, -5, -5, 10, 10, 0xFF0000, 1, 0, 0 ,0);
			Artist.drawRect(backRegister, -1, -1, 2, 2, 0xFFFFFF, 1, 0, 0 ,0);
			addChild(_register);
			_back.addChild(backRegister);
			 */

			_closeButton.addEventListener(MouseEvent.MOUSE_OVER, closeOverHandler);
			_closeButton.addEventListener(MouseEvent.MOUSE_OUT, closeOutHandler);
			_closeButton.addEventListener(MouseEvent.CLICK, closeClickedHandler);
		}

		private function privacyClickedHandler(e : MouseEvent) : void {
			var myTextField : TextField = TextField(e.target);
			var index : int = myTextField.getCharIndexAtPoint(e.localX, e.localY);
			trace(index);
			var startIndex : int =0;			var endIndex : int =0;
			for (var a : int = index; a > 0; a--) {
				if (myTextField.text.substring(a, a - 1) == " ") {
					startIndex = a;
					break;
				}
			}
			for (var b : int = index; b < myTextField.text.length; b++) {
				if (myTextField.text.substring(b, b + 1) == " ") {
					endIndex = b;
					break;
				}
			}

			trace("privacy handler ::: "+myTextField.text.substring(a, b));

		}

		private function onSubmitClick(event : MouseEvent) : void {
			if (_firstName.text != _firstName.name && _firstName.text.length > 1 && _seccondName.text != _seccondName.name && _seccondName.text.length > 1 && _titleComboBox.selectedModel() && _titleComboBox.selectedModel().label != RegisterController.getInstance().countriesXml.titleList.@default && _countriesComboBox.selectedModel().label != RegisterController.getInstance().countriesXml.countries.@default
			) {
				var variables : URLVariables = new URLVariables();
				variables.title = _titleComboBox.selectedModel().label;
				variables.firstname = _firstName.text;
				variables.lastname = _seccondName.text;
				variables.email = _emailAddress.text;
				variables.country = _countriesComboBox.selectedModel().xml.@code;
				variables.fromflash = "true";
				variables.language = AppController.getInstance().language;

				var request : URLRequest = new URLRequest("flashregister.php");
				// var request:URLRequest = new URLRequest("flashregister.php");
				// request.url = "flashregister.php";
				request.method = URLRequestMethod.POST;
				request.data = variables;

				trace("variables.language:" + variables.language);
				trace("variables.country:" + variables.country);
				
				trace("POST! submit! " + request.url);

				_errorPlane.visible = false;
				_errorPlane2.visible = false;
				_errorPlane3.visible = false;
				
				var loaderForm : URLLoader = new URLLoader();
				loaderForm.dataFormat = URLLoaderDataFormat.VARIABLES;
				loaderForm.addEventListener(Event.COMPLETE, completeHandler);
				loaderForm.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
				loaderForm.addEventListener(ErrorEvent.ERROR, errorHandler);

				try {
					loaderForm.load(request);
				} catch (error : Error) {
					trace("Unable to load URL!");
				}
			} else {
				_errorPlane3.y = _submitBtn.y;
				_errorPlane3.x = _submitBtn.x + Number(_ar?_submitBtn.width+_errorPlane3.width+30:0);
				addChild(_errorPlane3);
			}
		}

		private function errorHandler(event : ErrorEvent) : void {
			trace("ERROR:" + event.text);
		}

		private function completeHandler(event : Event) : void {
			trace("CompleteHandler");

			var loader : URLLoader = URLLoader(event.target);

			trace("data:" + loader.data + ":");

			if (loader.data.atrium_success && loader.data.atrium_success == "1") {
				showThankYou();
			}
			/*
			trace("data.success :" + loader.data.success+":"); 			trace("data.atrium_success :" + loader.data.atrium_success+":"); 			*/
		}

		private function showThankYou() : void {
			_submited = true;
			var thingsToTween : Array = new Array(_titleComboBox, _firstName, _firstNameBg, _seccondName, _seccondNameBg, _emailAddress, _emailAddressBg, _confirmAddress, _confirmAddressBg, _submitBtn, _submitHintBox, _countriesComboBox);

			for (var i : int = 0; i < thingsToTween.length; i++) {
				TweenLite.to(thingsToTween[i], 0.5, {alpha:0});
			}

			var formTitleStr : String = RegisterController.getInstance().countriesXml.thankyoutitle.text();
			// "Thank you for registering your interest in the<br>new Constellation Quest Collection.<br><br>You can now look forward to being the first to<br>hear exclusive news from Vertu.";
			_formTitle.multiline = true;
			FontFactory.updateText(_formTitle, formTitleStr);
		}

		private function onSubmitOut(event : MouseEvent) : void {
			var bg : Sprite = event.target.getChildByName("bg") as Sprite;
			TweenLite.to(bg, .5, {tint:null});
		}

		private function onSubmitOver(event : MouseEvent) : void {
			var bg : Sprite = event.target.getChildByName("bg") as Sprite;
			TweenLite.to(bg, .5, {tint:0x333333});
		}

		private function onConfirmInput(event : Event) : void {
			var t : TextField = TextField(event.target);
			// t.text = t.text.toUpperCase();
			if (t.text != _emailAddress.text.substring(0, t.text.length) ) {
				trace("emails do not match!");
				_errorPlane2.x = _confirmAddressBg.x + Number(_ar?_confirmAddressBg.width+_errorPlane2.width+30:0);
				_errorPlane2.y = _confirmAddressBg.y;
				addChild(_errorPlane2);
			} else {
				if (contains(_errorPlane2)) removeChild(_errorPlane2);
			}
			// trace("confirmEmail: " + t + " || email: " + _emailAddress.text.substring(0, t.length));
		}

		private function onEmailInput(event : TextEvent) : void {
			var t : TextField = TextField(event.target);
			if (t.text.length > 6 && t.text.indexOf('@') > 0 && t.text.indexOf('.') > 0) {
				if (!_emailRegExp.test(t.text)) {
					_errorPlane.x = _emailAddressBg.x + Number(_ar?_emailAddressBg.width+_errorPlane.width+30:0);
					_errorPlane.y = _emailAddressBg.y;
					addChild(_errorPlane);
				} else {
					if (contains(_errorPlane)) removeChild(_errorPlane);
				}
			} else {
				if (contains(_errorPlane)) removeChild(_errorPlane);
			}
		}

		private function onChangeHandler(event : Event) : void {
			// if (contains(_errorPlane3)) removeChild(_errorPlane3);	
			// var t:TextField = TextField(event.target);
			// t.text = t.text.toUpperCase();
		}

		private function onFocusOutHandler(event : FocusEvent) : void {
			var t : TextField = TextField(event.target);
			if (t.text.length < 1 || t.text == " ") {
				t.text = t.name;
			} else {
				t.removeEventListener(FocusEvent.FOCUS_IN, onFocusInHandler);
			}
		}

		private function onFocusInHandler(event : FocusEvent) : void {
			var t : TextField = TextField(event.target);
			t.text = "";
		}

		private function onTextInputHandler(event : TextEvent) : void {
		}

		override public function show() : void {
			alpha = 0;
			visible = true;
			TweenLite.to(this, AppController.TWEEN_IN_TIME, {alpha:1, ease:Sine.easeOut, delay:AppController.TWEEN_DELAY_TIME});
		}

		private function closeClickedHandler(event : MouseEvent) : void {
			var mEvent : ModuleEvent = new ModuleEvent(ModuleEvent.CLOSE_CLICKED);
			dispatchEvent(mEvent);
		}

		private function closeOutHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5, {tint:null, ease:Quart.easeOut});
		}

		private function closeOverHandler(event : MouseEvent) : void {
			TweenLite.to(_closeButton.getChildByName("closeText"), .5, {tint:0xFFFFFF, ease:Quart.easeOut});
		}

		private function repositionViewHandler(event : ViewEvent) : void {
			scaleAndReposition();
		}

		private function titleDropDownOpeningHandler(event : WtbComboBoxEvent) : void {
			var combo : TitleComboBox = TitleComboBox(event.target);
			addChild(combo);
		}

		private function countriesDropDownOpeningHandler(event : WtbComboBoxEvent) : void {
			var combo : RegisterComboBox = RegisterComboBox(event.target);
			addChild(combo);
		}

		private function titleSelectedHandler(event : WtbComboBoxEvent) : void {
			if (_titleComboBox.selectedModel() != null) {
				var cityNode : XML = TitleComboModel(_titleComboBox.selectedModel()).data as XML;
			}
		}

		private function countriesSelectedHandler(event : WtbComboBoxEvent) : void {
			if (_countriesComboBox.selectedModel() != null) {
				var countryNode : XML = CountryComboModel(_countriesComboBox.selectedModel()).data as XML;
			}
		}

		public function reveal(titleArr : Array, countriesArr : Array) : void {
			_back.alpha = 0;

			TweenLite.to(_back, 1, {alpha:1});
			if (_countriesComboBox.rows.length < 1) {
				for (var i : int = 0;i < countriesArr.length;i++) {
					var rowModel : CountryComboModel = new CountryComboModel();
					rowModel.setData(CountryComboModel(countriesArr[i]).data as XML);
					_countriesComboBox.addRow(rowModel);
				}
			}

			FontFactory.updateText(_titleComboBox.titleTf, RegisterController.getInstance().countriesXml.titleList.@default);
			if (_titleComboBox.rows.length < 1) {
				for (var j : int = 0;j < titleArr.length;j++) {
					var rowModel2 : TitleComboModel = new TitleComboModel();
					rowModel2.setData(TitleComboModel(titleArr[j]).data as XML);
					_titleComboBox.addRow(rowModel2);
				}
			}

			_titleComboBox.alpha = 0;
			_countriesComboBox.alpha = 0;

			TweenLite.to(_countriesComboBox, 1.2, {alpha:1});
			TweenLite.to(_titleComboBox, 1.2, {alpha:1});

			addChild(_titleComboBox);
			addChild(_countriesComboBox);

			// show();
			scaleAndReposition();
		}

		override public function scaleAndReposition() : void {
			var stg : Stage = AppController.getInstance().base.stage as Stage;
			if (stg) {
				var theStageWidth : Number = Number(stg.stageWidth + 0);
				var theStageHeight : Number = Number(stg.stageHeight + 0);
				var multiplyer : Number = Math.min(( theStageHeight - 67 ) / 570, theStageWidth / 970);

				x = (theStageWidth - 970) / 2;
				y = (theStageHeight - 67 - 570) / 2;

				_back.width = 970 * multiplyer;
				_back.height = 570 * multiplyer;
				_back.x = ((970 - theStageWidth) / 2) + ((theStageWidth - _back.width) / 2);
				_back.y = ((570 - theStageHeight) / 2) + ((theStageHeight - _back.height) / 2);

				_bg.width = theStageWidth;
				_bg.height = theStageHeight;

				_bg.x = ((970 - theStageWidth) / 2) + ((theStageWidth - _bg.width) / 2);
				_bg.y = ((570 - theStageHeight) / 2) + ((theStageHeight - _bg.height) / 2);
			}
		}

		public function showAll() : void {
			var thingsToTween : Array = new Array(_titleComboBox, _firstName, _firstNameBg, _seccondName, _seccondNameBg, _emailAddress, _emailAddressBg, _confirmAddress, _confirmAddressBg, _submitBtn, _submitHintBox, _countriesComboBox);

			for (var i : int = 0; i < thingsToTween.length; i++) {
				if (thingsToTween[i]) {
					thingsToTween[i].alpha = 1;
				}
				// TweenLite.to(thingsToTween[i], 0.5, {alpha:0});
			}
		}
	}
}
