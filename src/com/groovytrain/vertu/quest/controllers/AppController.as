package com.groovytrain.vertu.quest.controllers {
	import com.asual.swfaddress.SWFAddress;
	import com.asual.swfaddress.SWFAddressEvent;
	import com.google.analytics.AnalyticsTracker;
	import com.google.analytics.GATracker;
	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.events.AppEvent;
	import com.groovytrain.vertu.quest.events.FooterViewEvent;
	import com.groovytrain.vertu.quest.events.ViewEvent;
	import com.groovytrain.vertu.quest.events.ViewStackEvent;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.generic.LanguageDirection;
	import com.groovytrain.vertu.quest.generic.ResourceType;
	import com.groovytrain.vertu.quest.loadManager.LoadManager;
	import com.groovytrain.vertu.quest.models.CategoryModel;
	import com.groovytrain.vertu.quest.models.ConfigModel;
	import com.groovytrain.vertu.quest.models.CopyModuleModel;
	import com.groovytrain.vertu.quest.models.FooterModel;
	import com.groovytrain.vertu.quest.models.ModuleModel;
	import com.groovytrain.vertu.quest.models.VideoModuleModel;
	import com.groovytrain.vertu.quest.modules.ModuleTypes;
	import com.groovytrain.vertu.quest.utils.FontFactory;
	import com.groovytrain.vertu.quest.utils.StringCompressor;
	import com.groovytrain.vertu.quest.views.AbstractView;
	import com.groovytrain.vertu.quest.views.BgView;
	import com.groovytrain.vertu.quest.views.CollectionView;
	import com.groovytrain.vertu.quest.views.ExperienceThePhoneView;
	import com.groovytrain.vertu.quest.views.FooterView;
	import com.groovytrain.vertu.quest.views.ModuleView;
	import com.groovytrain.vertu.quest.views.RangeView;
	import com.groovytrain.vertu.quest.views.RegisterView;
	import com.groovytrain.vertu.quest.views.SpecificationsView;
	import com.groovytrain.vertu.quest.views.ViewAlignment;
	import com.groovytrain.vertu.quest.views.ViewOrientation;
	import com.groovytrain.vertu.quest.views.ViewStack;
	import com.groovytrain.vertu.quest.views.WhereToBuyView;

	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.Font;
	import flash.text.StyleSheet;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 * 
	 * @usage 	<pre>
	 * 			// the base should be the main document class. 
	 * 			Must set this before calling loadConfig.
	 * 			controller.base = this; 
	 *			controller.loadConfig("config.xml");</pre>
	 */
	public class AppController extends EventDispatcher {

		/* DEFAULT LANGAGE SETTING */
		private var _language : String = LanguageCodes.ENGLISH;
		/* DEFAULT LANGAGE SETTING */
		
		public static const FADE_TIME : Number = 0.5;
		public static const FADE_DELAY : Number = 1;
		public static const BACKGROUND_LAYER : String = "BACKGROUND_LAYER";
		public static const LOADER_LAYER : String = "LOADER_LAYER";
		public static const STATIC_PAGE_LAYER : String = "STATIC_PAGE_LAYER";
		public static const CONTENT_LAYER : String = "CONTENT_LAYER";
		public static const RANGE_LAYER : String = "RANGE_LAYER";
		public static const FOOTER_LAYER : String = "FOOTER_LAYER";
		public static const EXPERIENCE_THE_PHONE_VIEW : String = "EXPERIENCE_THE_PHONE_VIEW";
		public static const SPECIFICATION_VIEW : String = "SPECIFICATION_VIEW";
		public static const REGISTER_VIEW : String = "REGISTER_VIEW";
		public static const WHERE_TO_BUY_VIEW : String = "WHERE_TO_BUY_VIEW";
		public static const BACKGROUND_VIEW : String = "BACKGROUND_VIEW";
		public static const CONTENT_GLOBE_VIEW : String = "CONTENT_GLOBE_VIEW";
		public static const CONTENT_MODULE_VIEW : String = "CONTENT_MODULE_VIEW";
		public static const RANGE_VIEW : String = "RANGE_VIEW";
		public static const FOOTER_VIEW : String = "FOOTER_VIEW";
		public static const LOADER_VIEW : String = "LOADER_VIEW";
		public static const FOOTER_BACK_GRAD : String = "FOOTER_BACK_GRAD";
		private static const COLLECTION_VIEW : String = "COLLECTION_VIEW";
		public static const TWEEN_IN_TIME : Number = 1;
		public static const TWEEN_OUT_TIME : Number = 0.5;
		public static const TWEEN_DELAY_TIME : Number = 0.5;
		private var _firstLevel : String;
		private var _seccondLevel : String;
		private var _thirdLevel : String;
		private var _vloader : MovieClip;
		private var _configModel : ConfigModel;
		private var _footerModel : FooterModel;
		private var _base : Sprite;
		private var _viewStack : ViewStack;
		private var _modules : Array = new Array();
		private var _categories : Array = new Array();
		private var _categoriesModels : Array = new Array();
		private var _languageDirection : String = LanguageDirection.LTR;
		private var _cssStyleSheet : StyleSheet;
		private var _configXml : XML;
		private var _contentXml : XML;
		private var _resourceToLaunch : String;
		private var _currentOpenedResource : Array = new Array();
		private var _highResFrame : MovieClip;
		private static var _instance : AppController;
		private var _moduleToLaunch : String = "0";
		private var _tracker : AnalyticsTracker;

		private static function hidden() : void {
		}

		public static function getInstance() : AppController {
			if ( _instance == null ) {
				_instance = new AppController(hidden);
			}
			return _instance;
		}

		public function AppController(h : Function) {
			if (h !== hidden) {
				throw new Error("AppController and can only be accessed through AppController.getInstance()");
			}
		}

		public function loadConfig(configPath : String) : void {
			LoadManager.getInstance().addItemToLoadQueue(configPath, configLoadedHandler);
		}

		private function loadCSS() : void {
			LoadManager.getInstance().addItemToLoadQueue("styles.css", cssLoadedHandler);
		}

		private function cssLoadedHandler(event : Event) : void {
			_tracker = new GATracker(_base, "UA-1504701-13", "AS3", false);

			_cssStyleSheet = new StyleSheet();
			_cssStyleSheet.parseCSS(String(event.target.data));

			_footerModel = new FooterModel();
			_footerModel.setData(_contentXml.footer[0] as XML);

			_modules = new Array();
			_categoriesModels = new Array();

			// trace("getting the categories!")
			for each (var category : XML in _contentXml.categorietypes.category) {
				// trace("    " + category);
				var categoryModel : CategoryModel;
				categoryModel = new CategoryModel();
				categoryModel.setData(category);
				_categoriesModels.push(categoryModel);
			}

			var n : int = 0;

			for each (var module : XML in _contentXml..module) {
				// trace(module);
				var moduleModel : ModuleModel;
				if (module.@type == ModuleTypes.VIDEO) {
					moduleModel = new VideoModuleModel();
					moduleModel.id = String("" + n);
					moduleModel.setData(module);
					VideoModuleModel(moduleModel).timeLapse = Number(module.@time);
					_modules.push(moduleModel);
				} else if (module.@type == ModuleTypes.COPY_1 ) {
					moduleModel = new CopyModuleModel();
					moduleModel.id = String("" + n);
					moduleModel.setData(module);
					_modules.push(moduleModel);
				} else if ( module.@type == ModuleTypes.COPY_2 ) {
					moduleModel = new CopyModuleModel();
					moduleModel.id = String("" + n);
					moduleModel.setData(module);
					_modules.push(moduleModel);
				} else if ( module.@type == ModuleTypes.COPY_3 ) {
					moduleModel = new CopyModuleModel();
					moduleModel.id = String("" + n);
					moduleModel.setData(module);
					_modules.push(moduleModel);
				}
				n++;
			}

			// SET THE INITIAL GLOBAL STAGE QUALITY
			_base.stage.quality = StageQuality.MEDIUM;
			_base.stage.align = StageAlign.TOP_LEFT;
			_base.stage.scaleMode = StageScaleMode.NO_SCALE;
			_base.stage.frameRate = 28;

			// SET UP THE VIEW STACK
			_viewStack = new ViewStack();
			_base.addChild(_viewStack);

			// DIVIDE MODULES IN TO CATEGORIES AND INITIATE
			findCategoriesSortAndCreate();

			// DRAW BASIC ELEMENTS

			drawLoader();

			var value : String = SWFAddress.getValue();
			if (value.split("/")[2] == undefined || value.split("/")[2] == "" || value.split("/")[2] == " " ) {
				trace('DDDDDDDDDDDDDDDDD drawBackground()');
				drawBackground();
			}

			drawContent();
			drawStaticPages();
			drawFooter();

			stageResizeHandler();

			if (value.split("/")[2] == undefined || value.split("/")[2] == "" || value.split("/")[2] == " " ) {
				launchBackground();
			}

			trace("%%%%%%%%%%%%%%% " + value + " %%%%%%%%%%%%%% " + value.split("/")[2]);
			addStageListeners();
			addSwfAddressListeners();

			SWFAddress.setTitle("Vertu | Constellation Quest");
		}

		private function introFinishedHandler(e : Event) : void {
			if (_base.stage) {
				if (_base.stage.hasEventListener("INTRO_FINISHED")) {
					_base.stage.removeEventListener("INTRO_FINISHED", introFinishedHandler);
				}
			}

			var eulav : String;
			eulav = _language + "/" + ResourceType.EXPERIENCE;
			SWFAddress.setValue(cleanSwfAddressPath(eulav));

			addSwfAddressListeners();
		}

		public function loadFullXml(fullXmlPath : String) : void {
			LoadManager.getInstance().addItemToLoadQueue(fullXmlPath, fullXmlLoadedHandler);
		}

		private function addStageListeners() : void {
			_base.stage.addEventListener(Event.RESIZE, stageResizeHandler);
			_base.stage.addEventListener(ViewEvent.HIDDEN, hiddenHandler);
			// _base.stage.addEventListener(FooterViewEvent.ENDADDRESSUPDAE, onEndAdressUpdate)
		}

		private function onEndAdressUpdate(event : FooterViewEvent) : void {
			trace("EEEEEEEEEEEEEEEEE onEndAdressUpdate");
			if (_moduleToLaunch) {
				launchModule(Number(_moduleToLaunch), FooterView(FooterViewController.getInstance().view).categoryNr);
			}
		}

		private function hiddenHandler(event : ViewEvent) : void {
			// launchResource(_resourceToLaunch);
		}

		private function stageResizeHandler(event : Event = null) : void {
			var vsEvent : ViewStackEvent = new ViewStackEvent(ViewStackEvent.STAGE_RESIZED);
			vsEvent.data.base = _base;
			vsEvent.data.stage = _base.stage;
			_viewStack.dispatchEvent(vsEvent);
		}

		private function findCategoriesSortAndCreate() : void {
			for each (var categorie : XML in _contentXml.categories.categorie) {
				addNewCategory({name:categorie.@id, modules:[]});
			}

			for (var i : int = 0; i < _modules.length; i++ ) {
				_categories[findCategory(_modules[i].category)].modules.push(_modules[i]);
			}

			// trace("**********************************");
			// trace("categories.length: " + _categories.length);
			// trace("**********************************");
			for (var k : int = 0; k < _categories.length; k++) {
				// trace("**********************************");
				// trace(_categories[k].name);
				// trace("**********************************");

				for (var l : int = 0; l < _categories[k].modules.length; l++ ) {
					// trace(_categories[k].modules[l].title);
				}
			}
		}

		private function addNewCategory(o : Object) : void {
			_categories.push(o);
		}

		private function findCategory(name : String) : int {
			var r : int = 0;
			for (var i : int = 0; i < _categories.length; i++) {
				if (_categories[i].name == name) {
					r = i;
					return i;
					break;
				}
			}
			return r;
		}

		private function configErrorHandler(event : ErrorEvent) : void {
			trace("ERROR:" + ErrorEvent(event));
		}

		private function fullXmlLoadedHandler(event : Event) : void {
			var attributesDictionary : Array = new Array();
			var tagNameDictionary : Array = new Array();
			tagNameDictionary = [["country", "co"], ["city", "ci"], ["storeDisplayName", "sdn"], ["name", "n"], ["store", "s"], ["address", "a"], ["hours", "h"], ["tel", "t"], ["fax", "f"], ["email", "e"], ["url", "u"], ["image", "i"], ["region", "r"]];

			attributesDictionary = [["code", "c"], ["name", "n"], ["order", "o"]];

			var resultXml : XML = XML(event.target.data);
			var outStr : String = "";
			outStr = resultXml.toString();
			outStr = StringCompressor.compressXml(outStr, tagNameDictionary, attributesDictionary);
		}

		private function configLoadedHandler(event : Event) : void {
			var resultXml : XML = XML(event.target.data);

			_configXml = resultXml;

			_configModel = new ConfigModel();
			_configModel.setData(resultXml.config[0] as XML);

			LoadManager.getInstance().baseDirectory = _configModel.getValueByKey("baseDirectory");
			LoadManager.getInstance().imageDirectory = _configModel.getValueByKey("imageDirectory");
			LoadManager.getInstance().swfDirectory = _configModel.getValueByKey("swfDirectory");
			LoadManager.getInstance().xmlDirectory = _configModel.getValueByKey("xmlDirectory");
			LoadManager.getInstance().videoDirectory = _configModel.getValueByKey("videoDirectory");

			// loadContentXml();

			SWFAddress.addEventListener(SWFAddressEvent.INIT, swfAddressInitHandler);
		}

		private function swfAddressInitHandler(event : SWFAddressEvent) : void {
			// trace("OOOOOOOOOOOOOOOOOOOOOOOOOO");
			// trace("OOOOO SWFAdress.INIT OOOOO");
			// trace("OOOOOOOOOOOOOOOOOOOOOOOOOO");
			var urlLang : String = SWFAddress.getValue().split("/")[1] as String;
			if (urlLang.length == 2) {
				_language = urlLang;
			}

			loadContentXml();
		}

		private function loadContentXml() : void {
			var contentXmlPath : String = LoadManager.getInstance().xmlDirectory + "content_" + _language + ".xml";
			LoadManager.getInstance().addItemToLoadQueue(contentXmlPath, contentLoadedHandler);
		}

		private function contentLoadedHandler(event : Event) : void {
			_contentXml = XML(event.target.data);

			loadFontsForLocale();
		}

		private function loadFontsForLocale() : void {
			var prefix : String = _language;
//			if (prefix == LanguageCodes.GERMAN || prefix == LanguageCodes.FRENCH) {
//				prefix = LanguageCodes.ENGLISH;
//			}
			var fontPath : String = LoadManager.getInstance().swfDirectory + prefix + "_fonts.swf";
			LoadManager.getInstance().addItemToLoadQueue(fontPath, fontsLoadedHandler);
		}

		private function fontsLoadedHandler(event : Event) : void {
			trace("FONTS LOADED::::::::::::::::::::::::");
			var fontsSprite : Sprite = new Sprite();
			var clip : MovieClip = LoaderInfo(event.target).content as MovieClip;
			clip.addEventListener("FONT_REGISTERED", fontsRegisteredHandler);
			fontsSprite.addChild(clip);
			fontsSprite.visible = false;
			_base.addChild(fontsSprite);
		}

		private function fontsRegisteredHandler(event : Event) : void {
			var fonts : Array = Font.enumerateFonts(false);
			// trace("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
			for (var i : int = 0;i < fonts.length;i++) {
				var font : Font = fonts[i] as Font;

				trace("font:" + i + " : " + (fonts[i]).fontName + ": font.fontStyle:" + font.fontStyle + ": font.fontType:" + font.fontType);
			}
			// trace("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

			loadCSS();
		}

		private function addSwfAddressListeners() : void {
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, swfAddressChangeHandler);
		}

		// SWFAddress handling
		private function swfAddressChangeHandler(event : SWFAddressEvent) : void {
			var value : String = SWFAddress.getValue();
			var title : String = "Vertu";
			var names : Array = SWFAddress.getPathNames();

			_resourceToLaunch = null;

			for (var i : int = 2;i < value.split("/").length;i++) {
				title += " | " + value.split("/")[i];
			}

			trace(":: SWFAddress | [2] " + value.split("/")[2] + " | [3] " + value.split("/")[3] + " | [4] " + value.split("/")[4]);

			if (value == "/" || value == "/" + _language || value == "/" + _language + "/") {
				trace('UUUUUUUUUUUUUUUUUUUUU unhandledSwfChange()');
				// closeCurrentResource();
			} else {
				// parsePathAndLaunchResource(value);

				_tracker.trackPageview(value);

				trace("GOOGLE ANALITICS: _tracker.trackPageView(" + value + ")");

				if (_firstLevel != value.split("/")[2]) {
					_firstLevel = value.split("/")[2];
					if (value.split("/")[2] == ResourceType.EXPERIENCE) {
						_resourceToLaunch = ResourceType.EXPERIENCE;
						closeCurrentResource();
					} else if (value.split("/")[2] == ResourceType.COLLECTION) {
						_resourceToLaunch = ResourceType.COLLECTION;
						closeCurrentResource();
					} else if (value.split("/")[2] == ResourceType.REGISTER) {
						_resourceToLaunch = ResourceType.REGISTER;
						closeCurrentResource();
					} else if (value.split("/")[2] == ResourceType.BACKGROUND) {
						_resourceToLaunch = ResourceType.BACKGROUND;
						closeCurrentResource();
					} else if (value.split("/")[2] == undefined) {
						_resourceToLaunch = ResourceType.EXPERIENCE;
						closeCurrentResource();
					}
				}

				if (_seccondLevel != value.split("/")[3]) {
					_seccondLevel = value.split("/")[3];
					closeCurrentResource();
					hideExistingStaticPage();
					if (value.split("/")[3] == ResourceType.DESIGN || value.split("/")[3] == ResourceType.LIFESTYLE || value.split("/")[3] == ResourceType.PERFORMANCE ) {
						// launchCategory(value.split("/")[3]);
						_resourceToLaunch = value.split("/")[3];
					} else if (value.split("/")[3] == ResourceType.RANGE) {
						_resourceToLaunch = ResourceType.RANGE;
					} else if (value.split("/")[3] == ResourceType.SPECIFICATIONS) {
						_resourceToLaunch = ResourceType.SPECIFICATIONS;
					} else if (value.split("/")[3] == undefined) {
						closePage();
						_resourceToLaunch = _firstLevel;
						_seccondLevel = undefined;
					}
				}

				if (_thirdLevel != value.split("/")[4]) {
					_thirdLevel = value.split("/")[4];
					if (value.split("/")[4] != undefined) {
						if (!_resourceToLaunch) {
							launchModule(value.split("/")[4], FooterView(FooterViewController.getInstance().view).categoryNr);
							FooterView(FooterViewController.getInstance().view).makeThumClick(Number(value.split("/")[4]));
							_moduleToLaunch = value.split("/")[4];
						} else {
							_moduleToLaunch = value.split("/")[4];
						}
					} else {
						_moduleToLaunch = "0";
					}
				}
			}

			if (_resourceToLaunch) {
				trace("LLLLLLLLLLL launchResource( " + _resourceToLaunch + " )");
				launchResource(_resourceToLaunch);
			}
		}

		private function drawBackground() : void {
			_viewStack.createLayer(BACKGROUND_LAYER);
			var bgView : BgView = new BgView();
			bgView.orientation = ViewOrientation.SOUTH;
			bgView.align = ViewAlignment.CENTRE;

			bgView.id = BACKGROUND_VIEW;
			_viewStack.addViewToLayer(bgView, BACKGROUND_LAYER);
			bgView.hide();

			BackgroundViewController.getInstance().view = bgView;

			bgView.x = 0;
			bgView.y = 0;
		}

		private function drawLoader() : void {
			var vgraphic : Sprite = new AssetsManager.V_LOADER() as Sprite;
			vgraphic.x = _base.stage.stageWidth / 2;
			vgraphic.y = _base.stage.stageHeight / 2;
			MovieClip(vgraphic.getChildByName("v")).stop();
			vgraphic.name = "vgraphic";

			_vloader = new MovieClip;
			_vloader.name = "vloader";

			var vbackGround : Sprite = new Sprite();
			vbackGround.name = "background";
			vbackGround.graphics.beginFill(0x000000,0);
			vbackGround.graphics.drawRect(0, 0, _base.stage.stageWidth, _base.stage.stageHeight);
			vbackGround.graphics.endFill();

			_vloader.addChild(vbackGround);
			_vloader.addChild(vgraphic);
			_vloader.alpha = 0;

			_viewStack.createLayer(LOADER_LAYER);

			var loaderView : AbstractView = new AbstractView();
			loaderView.id = LOADER_VIEW;
			loaderView.addChild(_vloader);
			loaderView.orientation = ViewOrientation.FULL_SCREEN;
			loaderView.align = ViewAlignment.CENTRE;

			_viewStack.addViewToLayer(loaderView, LOADER_LAYER);
			// loaderView.show();

			LoaderController.getInstance().view = loaderView;
			LoaderController.getInstance().vl = _vloader;
			LoaderController.getInstance().vb = vbackGround;
			LoaderController.getInstance().vg = vgraphic;
		}

		private function drawContent() : void {
			_viewStack.createLayer(CONTENT_LAYER);
			var moduleView : ModuleView = new ModuleView();
			moduleView.id = CONTENT_MODULE_VIEW;
			_viewStack.addViewToLayer(moduleView, CONTENT_LAYER);
			ModuleController.getInstance().view = moduleView;
		}

		private function drawStaticPages() : void {
			_viewStack.createLayer(STATIC_PAGE_LAYER);

			var etpView : ExperienceThePhoneView = new ExperienceThePhoneView();
			etpView.orientation = ViewOrientation.CENTRE;
			etpView.id = EXPERIENCE_THE_PHONE_VIEW;
			_viewStack.addViewToLayer(etpView, STATIC_PAGE_LAYER);
			ExperienceThePhoneController.getInstance().view = etpView;
			etpView.hide();

			var collView : CollectionView = new CollectionView();
			collView.orientation = ViewOrientation.CENTRE;
			collView.id = COLLECTION_VIEW;
			_viewStack.addViewToLayer(collView, STATIC_PAGE_LAYER);
			CollectionController.getInstance().view = collView;
			collView.hide();

			var specView : SpecificationsView = new SpecificationsView();
			specView.orientation = ViewOrientation.CENTRE;
			specView.id = SPECIFICATION_VIEW;
			_viewStack.addViewToLayer(specView, STATIC_PAGE_LAYER);
			SpecificationsController.getInstance().view = specView;
			specView.hide();

			var rangeView : RangeView = new RangeView();
			rangeView.orientation = ViewOrientation.CENTRE;
			rangeView.id = RANGE_VIEW;
			_viewStack.addViewToLayer(rangeView, STATIC_PAGE_LAYER);
			RangeController.getInstance().view = rangeView;
			rangeView.hide();

			var wtbView : WhereToBuyView = new WhereToBuyView();
			wtbView.id = WHERE_TO_BUY_VIEW;
			_viewStack.addViewToLayer(wtbView, STATIC_PAGE_LAYER);
			WhereToBuyController.getInstance().view = wtbView;
			wtbView.hide();

			var regView : RegisterView = new RegisterView();
			regView.id = REGISTER_VIEW;
			regView.orientation = ViewOrientation.CENTRE;
			_viewStack.addViewToLayer(regView, STATIC_PAGE_LAYER);
			RegisterController.getInstance().view = regView;
			regView.hide();
		}

		private function drawFooter() : void {
			_viewStack.createLayer(FOOTER_LAYER);

			var ftView : FooterView = new FooterView();
			ftView.id = FOOTER_VIEW;
			ftView.orientation = ViewOrientation.SOUTH;
			ftView.align = ViewAlignment.CENTRE;

			_viewStack.addViewToLayer(ftView, FOOTER_LAYER);

			ftView.x = 0;

			FooterViewController.getInstance().view = ftView;
			FooterViewController.getInstance().model = _footerModel;
			FooterViewController.getInstance().start();

			FooterViewController.getInstance().addEventListener(FooterViewEvent.EXPERIENCE_THE_PHONE, experienceThePhoneClickedHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.THE_COLLECTION, collectionClickedHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.SPECIFICATIONS, specificationsClickedHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.RANGE, rangeClickedHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.REGISTER, registerClickHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.DESIGN, designClickedHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.LIFESTYLE, lifestyleClickedHandler);
			FooterViewController.getInstance().addEventListener(FooterViewEvent.PERFORMANCE, performanceClickedHandler);

			// MOVING THE LOADER LAYER TO THE TOP BUT UNDER THE MENU
			_viewStack.moveLayerToTop(LOADER_LAYER);
			_viewStack.moveLayerToTop(FOOTER_LAYER);
		}

		private function collectionClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.COLLECTION;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function registerClickHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.REGISTER;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function hideLoader() : void {
			LoaderController.getInstance().view.visible = false;
		}

		private function hideExistingStaticPage() : void {
			var visViews : Array = _viewStack.getVisibleViewsFromLayer(STATIC_PAGE_LAYER);
			for (var i : int = 0;i < visViews.length;i++) {
				var theView : AbstractView = visViews[i] as AbstractView;
				if (theView.alpha > 0) {
					theView.putAway();
				}
			}
		}

		private function specificationsClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.COLLECTION + "/" + ResourceType.SPECIFICATIONS;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function rangeClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.COLLECTION + "/" + ResourceType.RANGE;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function designClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.EXPERIENCE + "/" + ResourceType.DESIGN + "/0";
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function performanceClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.EXPERIENCE + "/" + ResourceType.PERFORMANCE + "/0";
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function lifestyleClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.EXPERIENCE + "/" + ResourceType.LIFESTYLE + "/0";
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		private function launchCategory(id : String) : void {
			// trace("lunchCategory: " + id);
			FooterViewController.getInstance().hideMenu();

			var fv : FooterView = FooterViewController.getInstance().view as FooterView;
			if (id == ResourceType.DESIGN) {
				fv.showDesignThums();
				ModuleController.getInstance().loadModule(_categories[0].modules[Number(_moduleToLaunch)]);
			} else if (id == ResourceType.LIFESTYLE) {
				fv.showLifestyleThums();
				ModuleController.getInstance().loadModule(_categories[1].modules[Number(_moduleToLaunch)]);
			} else if (id == ResourceType.PERFORMANCE) {
				fv.showPerformanceThums();
				ModuleController.getInstance().loadModule(_categories[2].modules[Number(_moduleToLaunch)]);
			}
			_currentOpenedResource.push(ResourceType.PAGE);
		}

		public function launchModule(moduleNr : int, categoryNr : int) : void {
			ModuleController.getInstance().loadModule(_categories[categoryNr].modules[moduleNr]);
			_currentOpenedResource.push(ResourceType.PAGE);
		}

		private function experienceThePhoneClickedHandler(event : FooterViewEvent) : void {
			var valueStr : String = _language + "/" + ResourceType.EXPERIENCE;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		public function cleanSwfAddressPath(valueStr : String) : String {
			while (valueStr.indexOf("/null") > -1) {
				valueStr = valueStr.split("/null").join("");
			}
			return valueStr;
		}

		public function launchExperienceThePhone() : void {
			FooterViewController.getInstance().showExMenu();
			FooterViewController.getInstance().selectButtonById(ResourceType.EXPERIENCE);
			ExperienceThePhoneController.getInstance().start();
		}

		public function launchWhereToBuy() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.WHERE_TO_BUY);
			FooterViewController.getInstance().hideSecondMenu();
			WhereToBuyController.getInstance().start();
		}

		public function launchSpecifications() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.SPECIFICATIONS);
			FooterViewController.getInstance().showSpMenu();
			SpecificationsController.getInstance().start();
		}

		public function launchCollection() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.COLLECTION);
			FooterViewController.getInstance().showSpMenu();
			CollectionController.getInstance().start();
		}

		public function launchRange() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.RANGE);
			FooterViewController.getInstance().showSpMenu();
			RangeController.getInstance().start();
		}

		public function launchDesign() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.DESIGN);
			FooterView(FooterViewController.getInstance().view).showDesignThums();
			ModuleController.getInstance().loadModule(_categories[0].modules[0]);
		}

		public function launchLifestyle() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.LIFESTYLE);
			FooterView(FooterViewController.getInstance().view).showLifestyleThums();
			ModuleController.getInstance().loadModule(_categories[1].modules[0]);
		}

		public function launchPerformance() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.PERFORMANCE);
			FooterView(FooterViewController.getInstance().view).showPerformanceThums();
			ModuleController.getInstance().loadModule(_categories[2].modules[0]);
		}

		public function launchBackground() : void {
			FooterViewController.getInstance().currentButtonView = null;
			FooterViewController.getInstance().updateButtonStates();
			FooterViewController.getInstance().hideSecondMenu();

			_resourceToLaunch = ResourceType.BACKGROUND;
			_currentOpenedResource = new Array();
			_currentOpenedResource.push(ResourceType.BACKGROUND);

			_base.stage.addEventListener("INTRO_FINISHED", introFinishedHandler);

			var bgView : BgView = BgView(_viewStack.getViewById(BACKGROUND_VIEW));
			bgView.reveal();
		}

		public function launchRegister() : void {
			FooterViewController.getInstance().selectButtonById(ResourceType.REGISTER);
			FooterViewController.getInstance().hideSecondMenu();
			RegisterController.getInstance().start();
		}

		private function closeCurrentResource() : void {
			while (_currentOpenedResource.length > 0) {
				var resourceId : String = _currentOpenedResource[_currentOpenedResource.length - 1];
				switch(resourceId) {
					case ResourceType.EXPERIENCE:
						ExperienceThePhoneController.getInstance().close();
						break;
					case ResourceType.WHERE_TO_BUY:
						WhereToBuyController.getInstance().close();
						break;
					case ResourceType.SPECIFICATIONS:
						SpecificationsController.getInstance().close();
						break;
					case ResourceType.COLLECTION:
						CollectionController.getInstance().close();
						break;
					case ResourceType.REGISTER:
						RegisterController.getInstance().close();
						break;
					case ResourceType.BACKGROUND:
						BackgroundViewController.getInstance().close();
						break;
					case ResourceType.PAGE:
						closePage();
						break;
					default:
						break;
				}

				_currentOpenedResource.pop();
			}
			// trace("OOOOOOOOOOOOO _currentOpenedResource.length = " + _currentOpenedResource.length);
		}

		private function launchResource(resourceType : String) : void {
			_currentOpenedResource.push(resourceType);

			switch(resourceType) {
				// STATIC PAGES - start()
				case ResourceType.EXPERIENCE:
					launchExperienceThePhone();
					break;
				case ResourceType.COLLECTION:
					launchCollection();
					break;
				case ResourceType.WHERE_TO_BUY:
					launchWhereToBuy();
					break;
				case ResourceType.REGISTER:
					launchRegister();
					break;
				case ResourceType.RANGE:
					launchRange();
					break;
				case ResourceType.SPECIFICATIONS:
					launchSpecifications();
					break;
				case ResourceType.DESIGN:
					launchCategory(ResourceType.DESIGN);
					break;
				case ResourceType.LIFESTYLE:
					launchCategory(ResourceType.LIFESTYLE);
					break;
				case ResourceType.BACKGROUND:
					launchBackground();
					break;
				case ResourceType.PERFORMANCE:
					launchCategory(ResourceType.PERFORMANCE);
					break;
				default:
					break;
			}
		}

		public function loadModule(moduleId : String) : void {
			var valueStr : String = _language + "/" + ResourceType.MODULE + "/" + moduleId;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		public function closePage() : void {
			ModuleController.getInstance().doCloseButtonClick();
			FooterViewController.getInstance().hideSecondMenu();
		}

		private function newFontsLoadedHandler(event : Event) : void {
			// trace("NEW FONTS LOADED::::::::::::::::::::::::");
			var fontsSprite : Sprite = new Sprite();
			var clip : MovieClip = LoaderInfo(event.target).content as MovieClip;
			clip.addEventListener("FONT_REGISTERED", newFontsRegisteredHandler);
			fontsSprite.addChild(clip);
			fontsSprite.visible = false;
			_base.addChild(fontsSprite);

			newFontsRegisteredHandler(null);
		}

		private function newFontsRegisteredHandler(event : Event) : void {
			var fonts : Array = Font.enumerateFonts(false);
			// trace("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
			for (var i : int = 0;i < fonts.length;i++) {
				var font : Font = fonts[i] as Font;
				// trace("font:" + i + " : " + (fonts[i]).fontName + ": font.fontStyle:" + font.fontStyle + ": font.fontType:" + font.fontType);
			}
			// trace("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");

			FontFactory.refreshTextfields(_language);
		}

		public function get base() : Sprite {
			return _base;
		}

		public function set base(base : Sprite) : void {
			_base = base;
		}

		public function get viewStack() : ViewStack {
			return _viewStack;
		}

		public function get modules() : Array {
			return _modules;
		}

		public function get configModel() : ConfigModel {
			return _configModel;
		}

		public function get language() : String {
			return _language;
		}

		public function set language(lang : String) : void {
			if (lang != _language) {
				_language = lang;
				/*
				var fontPath : String = LoadManager.getInstance().swfDirectory + _language + "_fonts.swf";
				LoadManager.getInstance().addItemToLoadQueue(fontPath, newFontsLoadedHandler);
				 */

				var outStr : String = "";
				var value : String = SWFAddress.getValue();
				if (value == "/") {
					value = _language;
					outStr = value;
				} else {
					var arr : Array = value.split("/");
					arr[1] = "@@@";
					outStr = arr.join("/");
					outStr = outStr.split("/@@@").join("/");
					outStr = outStr.split("//").join("/");
					outStr = _language + outStr;
				}
				trace("SWFAddress.setValue:::: " + cleanSwfAddressPath(outStr) + " :::: set language()");
				var event : AppEvent;
				//if (_language != LanguageCodes.ARABIC) {
				event = new AppEvent(AppEvent.LANGUAGE_CHANGED);
				SWFAddress.setValue(cleanSwfAddressPath(outStr));
				//} else {
				//	event = new AppEvent(AppEvent.LANGUAGE_CHANGED_AR);
				//}
				_base.dispatchEvent(event);
				// Network.launchUrl("#/"+outStr);
			} else {
				_language = lang;
			}
		}

		public function get cssStyleSheet() : StyleSheet {
			return _cssStyleSheet;
		}

		public function get languageDirection() : String {
			if (_language == LanguageCodes.ARABIC) {
//				_languageDirection = LanguageDirection.RTL;				_languageDirection = LanguageDirection.LTR;
			} else {
				_languageDirection = LanguageDirection.LTR;
			}

			// _languageDirection = LanguageDirection.RTL; // HACK development hard reset!!

			return _languageDirection;
		}

		public function get highResFrame() : MovieClip {
			return _highResFrame;
		}

		public function set highResFrame(highResFrame : MovieClip) : void {
			_highResFrame = highResFrame;
		}

		public function get vloader() : Sprite {
			return _vloader;
		}

		public function get categories() : Array {
			return _categories;
		}

		public function set categories(categories : Array) : void {
			_categories = categories;
		}

		public function get contentXml() : XML {
			return _contentXml;
		}

		public function get thirdLevel() : String {
			return _thirdLevel;
		}

		public function set thirdLevel(thirdLevel : String) : void {
			_thirdLevel = thirdLevel;
		}

		public function get seccondLevel() : String {
			return _seccondLevel;
		}

		public function set seccondLevel(seccondLevel : String) : void {
			_seccondLevel = seccondLevel;
		}

		public function get firstLevel() : String {
			return _firstLevel;
		}

		public function set firstLevel(firstLevel : String) : void {
			_firstLevel = firstLevel;
		}

		public function closeLevelThree() : void {
			var valueStr : String = _language + "/" + _firstLevel + "/" + _seccondLevel;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		public function closeLevelTwo() : void {
			var valueStr : String = _language + "/" + _firstLevel;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		public function closeLevelOne() : void {
			var valueStr : String = _language + "/" + ResourceType.EXPERIENCE;
			SWFAddress.setValue(cleanSwfAddressPath(valueStr));
		}

		public function get moduleToLaunch() : String {
			return _moduleToLaunch;
		}

		public function get categoriesModels() : Array {
			return _categoriesModels;
		}
	}
}
