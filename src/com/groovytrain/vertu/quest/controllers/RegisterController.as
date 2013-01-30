package com.groovytrain.vertu.quest.controllers {
	import com.groovytrain.vertu.quest.models.CountryComboModel;
	import com.groovytrain.vertu.quest.models.TitleComboModel;
	import com.groovytrain.vertu.quest.views.RegisterView;
	import com.asual.swfaddress.SWFAddress;
	import com.groovytrain.vertu.quest.events.PageEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.events.WtbComboBoxEvent;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.models.WtbComboRowModel;
	import com.groovytrain.vertu.quest.views.AbstractView;
	import com.groovytrain.vertu.quest.views.WhereToBuyView;

	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	/**
	 * @author mateuszw
	 */
	 
	 
	public class RegisterController extends AbstractViewController {
		private const COUNTRIES_XML_PREFFIX 					: String = "register_";
		private var _opened 									: Boolean = false;
		private var _countriesXml 								: XML;
		private var _countries 									: Array;
		private var _titles										: Array;
		private static var _instance 							: RegisterController;

		private static function hidden() : void {
			
		}

		public static function getInstance() : RegisterController {
			if( _instance == null ) {
				_instance = new RegisterController(hidden);
			}
			return _instance;
		}

		public function RegisterController(h : Function) {
			if (h !== hidden) {
				throw new Error("WhereToBuyController and can only be accessed through WhereToBuyController.getInstance()");
			}
		}

		public function close() : void {
			pageCloseClickedHandler(null);
		}

		public function start() : void {
			if(!_opened) {

				var xmlPath : String = COUNTRIES_XML_PREFFIX + AppController.getInstance().language + ".xml";
				xmlPath = AppController.getInstance().configModel.getValueByKey("xmlDirectory") + xmlPath;
				LoadManager.getInstance().addItemToLoadQueue(xmlPath, xmlLoadedHandler);
				_opened = true;
				
				var regView:RegisterView = RegisterView(view);
				
				regView.showAll();
				
			}
		}
		
		private function pageCloseClickedHandlerAddress(event : PageEvent) : void {
			AppController.getInstance().closeLevelOne();
		}

		private function puttingAwayViewHandler(event : ViewEvent) : void {
			trace("HHHHHHHHH puttingAwayViewHandler() :: REGISTER");
			AbstractView(event.target).removeEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
			_opened = false;
		}

		private function pageCloseClickedHandler(event : PageEvent) : void {
			view.putAway();
			_opened = false;
		}

		private function xmlErrorHandler(event : ErrorEvent) : void {
			//trace("xmlErrorHandler::" + event);
		}

		private function xmlLoadedHandler(event : Event) : void {
			_titles = new Array();
			_countries = new Array();
			
			_countriesXml = XML(event.target.data);
						 
			for each (var item : XML in _countriesXml.titleList.item) {
				var titleModel : TitleComboModel = new TitleComboModel();
				titleModel.setData(item);
				_titles.push(titleModel);
			}
			
			for each (var country : XML in _countriesXml.countries.country) {
				var countryModel : CountryComboModel = new CountryComboModel();
				countryModel.setData(country);
				_countries.push(countryModel);
			}

			var regView : RegisterView = RegisterView(view);
			regView.addEventListener(WtbComboBoxEvent.STORE_CHOSEN, storeChosenHandler);
			
			//moved from start function.
				AppController.getInstance().viewStack.addViewToLayer(view, AppController.STATIC_PAGE_LAYER);
				view.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
				view.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandlerAddress);
				view.show();
				
				regView.drawContent();
			
			regView.reveal(_titles, _countries);
		}

		private function storeChosenHandler(event : WtbComboBoxEvent) : void {
			var storeNode : XML = event.data.storeNode as XML;
			loadStoreImage(storeNode.image.text());
		}

		private function loadStoreImage(imgPath : String) : void {
			var directory : String = AppController.getInstance().configModel.getValueByKey("wtbStoreImagesDirectory");

			//trace("loadStoreImage::" + directory + imgPath);

			LoadManager.getInstance().addItemToLoadQueue(directory + imgPath, imgLoadedHandler);

		}

		private function imgLoadedHandler(event : Event) : void {
			var info : LoaderInfo = LoaderInfo(event.target);
			info.loader.removeEventListener(IOErrorEvent.IO_ERROR, imgErrorHandler);
			info.loader.removeEventListener(IOErrorEvent.NETWORK_ERROR, imgErrorHandler);
			info.loader.removeEventListener(Event.COMPLETE, imgLoadedHandler);

			var wtbView : WhereToBuyView = WhereToBuyView(view);
			//trace("info.content:" + info.content);

			var imgSprite : Sprite = new Sprite();
			imgSprite.addChild(info.content);
			wtbView.displayStoreDetail(imgSprite);
		}

		private function imgErrorHandler(event : IOErrorEvent) : void {
		}
		

		override public function reposition() : void {
			// don't do reposition here, the view will take care of it.
		}

		public function get countriesXml() : XML {
			return _countriesXml;
		}
	}
}
