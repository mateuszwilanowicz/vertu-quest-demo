package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.models.AbstractModel;
	import gs.TweenLite;

	import com.groovytrain.vertu.quest.assetsManager.AssetsManager;
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.WtbComboBoxEvent;
	import com.groovytrain.vertu.quest.models.WtbComboRowModel;
	import com.groovytrain.vertu.quest.utils.Artist;
	import com.groovytrain.vertu.quest.utils.ButtonInjector;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.text.TextField;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class WtbComboBox extends Sprite {
		private var _maskSprite : Sprite;
		private var _consealedSprite : Sprite;
		private var _rowDepth : Number = 20;
		private var _realWidth : Number;
		private var _rows : Array;
		private var _titleTf : TextField;
		private var _titleRow : WtbComboRowSprite = null;
		private var _selectedRow : WtbComboRowSprite;
		private var _opened : Boolean = false;
		private var _hilightedRowIndex : int = 0;

		public function WtbComboBox() {
			init();
		}

		private function init() : void {
			_rows = new Array();
			_realWidth = 350;

			_consealedSprite = new Sprite();
			_consealedSprite.y = _rowDepth;
			addChild(_consealedSprite);

			_maskSprite = new Sprite();
			Artist.drawRect(_maskSprite, 0, 0, _realWidth, 10, 0xFF0000, 0.8);
			_maskSprite.y = 0;

			_consealedSprite.mask = _maskSprite;

			drawFirstRow();
		}

		private function drawFirstRow() : void {
			var rowSprite : WtbComboRowSprite;
			var arrow : Sprite;
			if(_titleRow == null) {
				rowSprite = new WtbComboRowSprite();
				arrow = new AssetsManager.ARROW_DOWN() as Sprite;
				arrow.name = "arrow";
			} else {
				rowSprite = _titleRow;
				arrow = _titleRow.getChildByName("arrow") as Sprite;
			}
			arrow.x = _realWidth - arrow.width;

			rowSprite.setWidth(_realWidth);
			rowSprite.setLabel("Select...");
			rowSprite.y = 0;

			rowSprite.addChild(arrow);
			addChild(rowSprite);

			_titleTf = rowSprite.label;
			_titleRow = rowSprite;

			addChild(_maskSprite);

			ButtonInjector.injectButtonDefaults(arrow);
			_titleRow.addEventListener(MouseEvent.CLICK, arrowClickedHandler);
			arrow.addEventListener(MouseEvent.CLICK, arrowClickedHandler);
		}

		private function arrowClickedHandler(event : MouseEvent) : void {
			if(_maskSprite.height > 10) {
				// _opened) {
				closeDropDown();
			} else {
				openDropDown();
			}
		}

		private function openDropDown() : void {
			_opened = true;
			_hilightedRowIndex = 0;
			_consealedSprite.y = _rowDepth;
			addChild(_consealedSprite);
			addEventListener(Event.ENTER_FRAME, mouseDetectHandler);
			AppController.getInstance().base.stage.addEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
			dispatchEvent(new WtbComboBoxEvent(WtbComboBoxEvent.DROP_DOWN_OPENING));
			TweenLite.to(_maskSprite, 1, {height:350, y:_rowDepth});
		}

		private function mouseDetectHandler(event : Event) : void {
			if(mouseX > 0 && mouseX < _consealedSprite.width - 20) {
				// trace("mouseY::" + mouseY);// 40 - 350
				var maxY : Number = _rowDepth;
				// - 350
				var minY : Number = _rowDepth - _consealedSprite.height + 350;
				//
				var yPos : Number = _consealedSprite.y;
				var mag : Number = 0;
				//
				if(mouseY < 40) {
					mag = (40 - mouseY) * 0.3;
					yPos += mag;
					(yPos > maxY) ? yPos = maxY : "";
				} else if(mouseY > 350) {
					mag = (mouseY - 350) * 0.3;
					yPos -= mag;
					(yPos < minY) ? yPos = minY : "";
				}
				_consealedSprite.y = yPos;
			}
		}

		private function shiftSpriteToPos(yPos : Number) : void {
			TweenLite.to(_consealedSprite, 0.3, {y:_rowDepth - yPos});
		}

		private function keyDownHandler(event : KeyboardEvent) : void {
			var k : int = event.charCode as int;
			var previousRowIndex : int = _hilightedRowIndex;
			var previousRowSprite : WtbComboRowSprite = null;
			var hilightedRowFound : Boolean = false;
			var uSprite : WtbComboRowSprite = null;

			trace("CHARCODE:" + k);
			// 97-122 : a-z
			trace("KEYCODE:" + event.keyCode);
			// UP_ARROW:38 DN_ARROW:40
			// 13 : enter

			// trace(String("a").charCodeAt(0));
			if(k > 96 && k < 123) {
				previousRowSprite = WtbComboRowSprite(_rows[_hilightedRowIndex]);
				var previousCharCode : int = previousRowSprite.model.label.toLowerCase().charCodeAt(0);
				var startFrom : int = _hilightedRowIndex;

				// if the current letter is before the last letter typed
				if(previousCharCode > k) {
					// start from begining.
					startFrom = 0;
				}

				for (var i : int = startFrom;i < _rows.length;i++) {
					var rowSprite : WtbComboRowSprite = _rows[i] as WtbComboRowSprite;
					trace("charCode:" + rowSprite.model.label.toLocaleLowerCase().charCodeAt(0));
					if(!rowSprite.hilighted && rowSprite.model.label.toLocaleLowerCase().charCodeAt(0) == k) {
						rowSprite.hilight();
						shiftSpriteToPos(rowSprite.y);
						_hilightedRowIndex = i;
						break;
					}
				}

				previousRowSprite.rollOut();

				if(previousRowIndex == _hilightedRowIndex) {
					_hilightedRowIndex = 0;
				}
			} else if(k == 13) {
				for (var x : int = 0;x < _rows.length;x++) {
					var rSprite : WtbComboRowSprite = _rows[x] as WtbComboRowSprite;
					if(rSprite.hilighted) {
						rSprite.dispatchEvent(new WtbComboBoxEvent(WtbComboBoxEvent.SELECTION_CHANGED));
					}
				}
			} else if(event.keyCode == 38) {
				// UP
				previousRowSprite = WtbComboRowSprite(_rows[_hilightedRowIndex]);
				for (var p : int = _rows.length - 1; p > -1; p--) {
					uSprite = _rows[p] as WtbComboRowSprite;
					if(hilightedRowFound) {
						uSprite.hilight();
						shiftSpriteToPos(uSprite.y);
						_hilightedRowIndex = p;
						break;
					} else if(uSprite.hilighted) {
						hilightedRowFound = true;
					}
				}

				previousRowSprite.rollOut();

				if(previousRowIndex == _hilightedRowIndex) {
					_hilightedRowIndex = 0;
				}
			} else if(event.keyCode == 40) {
				// DOWN
				previousRowSprite = WtbComboRowSprite(_rows[_hilightedRowIndex]);
				for (var u : int = 0;u < _rows.length;u++) {
					uSprite = _rows[u] as WtbComboRowSprite;
					if(hilightedRowFound) {
						uSprite.hilight();
						shiftSpriteToPos(uSprite.y);
						_hilightedRowIndex = u;
						break;
					} else if(uSprite.hilighted) {
						hilightedRowFound = true;
					}
				}

				if(!hilightedRowFound) {
					WtbComboRowSprite(_rows[0]).hilight();
					shiftSpriteToPos(WtbComboRowSprite(_rows[0]).y);
					_hilightedRowIndex = 0;
				} else {
					previousRowSprite.rollOut();
				}

				if(previousRowIndex == _hilightedRowIndex) {
					_hilightedRowIndex = 0;
				}
			}
		}

		private function closeDropDown() : void {
			_opened = false;

			removeEventListener(Event.ENTER_FRAME, mouseDetectHandler);
			AppController.getInstance().base.stage.removeEventListener(KeyboardEvent.KEY_UP, keyDownHandler);
//			TweenLite.to(_maskSprite, 0.3, {height:10, y:0, onComplete:dropDownClosed});			TweenLite.to(_maskSprite, 0.3, {height:0, y:0, onComplete:dropDownClosed});
		}

		private function dropDownClosed() : void {
			dispatchEvent(new WtbComboBoxEvent(WtbComboBoxEvent.SELECTION_CHANGED));
		}

		public function destroy() : void {
			/*
			for (var i : int = 0;i < _rows.length;i++) {
			var rowSprite : WtbComboRowSprite = _rows[i] as WtbComboRowSprite;
			_consealedSprite.removeChild(rowSprite);
			}
			 */
			if(contains(_consealedSprite)) {
				for(var i : int = _consealedSprite.numChildren-1; i>-1; i--) {
					_consealedSprite.removeChildAt(i);
				}
				_rows = new Array();
				removeChild(_consealedSprite);
			}
		}

		public function addRow(rowModel : WtbComboRowModel) : void {
			var rowSprite : WtbComboRowSprite = new WtbComboRowSprite();
			rowSprite.model = rowModel;
			rowSprite.setWidth(_realWidth);
			rowSprite.setLabel(rowModel.label);
			rowSprite.y = _rows.length * _rowDepth;
			rowSprite.addEventListener(WtbComboBoxEvent.SELECTION_CHANGED, selectionChangedHandler);
			_rows.push(rowSprite);

			_consealedSprite.addChild(rowSprite);

			addChild(_maskSprite);
		}

		public function selectedModel() : AbstractModel {
			if(_selectedRow) {
				return _selectedRow.model;
			} else {
				return null;
			}
		}

		private function selectionChangedHandler(event : WtbComboBoxEvent) : void {
			if(_selectedRow) {
				_selectedRow.selected = false;
			}
			_selectedRow = event.target as WtbComboRowSprite;
			// _titleTf.htmlText = _selectedRow.label.htmlText;
			_titleRow.setLabel(_selectedRow.label.text);
			closeDropDown();
		}

		public function get realWidth() : Number {
			return _realWidth;
		}

		public function set realWidth(realWidth : Number) : void {
			_realWidth = realWidth;
		}
	}
}
