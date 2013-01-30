package com.groovytrain.vertu.quest.components.contentswfs {
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public interface IContentScrollerView {
		function updateScroll(percentage:Number):void;
		function scrollToTop(animated:Boolean=true,time:Number=0.4):void;
	}
}
