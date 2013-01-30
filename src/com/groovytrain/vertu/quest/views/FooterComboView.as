package com.groovytrain.vertu.quest.views {
	import com.groovytrain.vertu.quest.controllers.AppController;
	import com.groovytrain.vertu.quest.events.FooterComboViewEvent;
	import com.groovytrain.vertu.quest.generic.LanguageCodes;
	import com.groovytrain.vertu.quest.models.FooterItemModel;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class FooterComboView extends FooterButtonView {

		private var _popupSprite : FooterComboOptionsView;

		public function FooterComboView(fiModel : FooterItemModel) {
			super(fiModel);
			
			initWithCombo();
		}

		private function initWithCombo() : void {
			 
			_popupSprite = new FooterComboOptionsView();
			if (AppController.getInstance().language == LanguageCodes.ARABIC) {
				_popupSprite.x = 162;
			} else {
				_popupSprite.x = 810;
			}
			_popupSprite.y = _back.y;
			
		}

		public function showPopup() : void {
			_popupSprite.showPopup(_model);
			
			startMouseBoundaryDetection();
		}

		public function hidePopup() : void {
			_popupSprite.hidePopup();
		}

		private function startMouseBoundaryDetection() : void {
			addEventListener(Event.ENTER_FRAME, mouseTrackHandler);
		}

		private function mouseTrackHandler(event : Event) : void {
			var s : Sprite = event.target as Sprite;
			if(s.mouseX < -70 || s.mouseX > 172 || s.mouseY < (_popupSprite.height + 32) * -1) {
				removeEventListener(Event.ENTER_FRAME, mouseTrackHandler);
				dispatchEvent(new FooterComboViewEvent(FooterComboViewEvent.MOUSE_STRAYED_OUT));
			}
		}

		public function get popupSprite() : Sprite {
			return _popupSprite;
		}
	}
}
