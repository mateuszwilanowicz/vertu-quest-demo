package com.groovytrain.vertu.quest.controllers {
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
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	 
	 
	public class WhereToBuyController extends AbstractViewController {
		private const STORES_XML_PREFFIX : String = "stores_";
		private var _opened : Boolean = false;
		private var _countriesXml : XML;
		private var _countries : Array;
		private static var _instance : WhereToBuyController;

		private static function hidden() : void {
			
		}

		public static function getInstance() : WhereToBuyController {
			if( _instance == null ) {
				_instance = new WhereToBuyController(hidden);
			}
			return _instance;
		}

		public function WhereToBuyController(h : Function) {
			if (h !== hidden) {
				throw new Error("WhereToBuyController and can only be accessed through WhereToBuyController.getInstance()");
			}
		}

		public function close() : void {
			pageCloseClickedHandler(null);
		}

		public function start() : void {
			if(!_opened) {
				var xmlPath : String = STORES_XML_PREFFIX + AppController.getInstance().language + ".xml";
				xmlPath = AppController.getInstance().configModel.getValueByKey("xmlDirectory") + xmlPath;

				LoadManager.getInstance().addItemToLoadQueue(xmlPath, xmlLoadedHandler);

				AppController.getInstance().viewStack.addViewToLayer(view, AppController.STATIC_PAGE_LAYER);
				view.addEventListener(ViewEvent.PUTTING_AWAY_VIEW, puttingAwayViewHandler);
				view.addEventListener(PageEvent.CLOSE_CLICKED, pageCloseClickedHandlerAddress);
				view.show();

				_opened = true;
			}
		}

		private function pageCloseClickedHandlerAddress(event : PageEvent) : void {
			AppController.getInstance().closeLevelOne();
		}

		private function puttingAwayViewHandler(event : ViewEvent) : void {
			trace("HHHHHHHHH puttingAwayViewHandler() :: WHERE TO BUY");
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
			_countries = new Array();
			_countriesXml = XML(event.target.data);
			/*
			var attributesDictionary:Array = new Array();
			var tagNameDictionary:Array = new Array();
			tagNameDictionary = [	["country", "co"],
			["city", "ci"],
			["storeDisplayName", "sdn"],
			["name", "n"],
			["store", "s"],
			["address", "a"],
			["hours", "h"],
			["tel", "t"],
			["fax", "f"],
			["email", "e"],
			["url", "u"],
			["image", "i"],
			["region","r"]];
							
			attributesDictionary = [	["code", "c"],
			["name", "n"],
			["order", "o"]];			_countriesXml = XML(StringCompressor.uncompressXml(String(XML(event.target.data).toString()), tagNameDictionary, attributesDictionary));
			 */
			trace("countriesXml::" + _countriesXml.country.length());
			trace("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
				trace("<countries language=\"en\">");
				
			for each (var country : XML in _countriesXml.country) {
				trace("\t<country code=\""+country.@code+"\" name=\""+country.@name+"/>");
				var countryModel : WtbComboRowModel = new WtbComboRowModel();
				countryModel.setData(country);
				_countries.push(countryModel);
			}

			var wtbView : WhereToBuyView = WhereToBuyView(view);
			wtbView.addEventListener(WtbComboBoxEvent.STORE_CHOSEN, storeChosenHandler);
			wtbView.reveal(_countries);
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
	}
}
