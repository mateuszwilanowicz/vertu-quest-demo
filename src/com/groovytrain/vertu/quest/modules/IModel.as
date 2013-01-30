package com.groovytrain.vertu.quest.modules {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public interface IModel {
		/* used to inject data into the model object */
		function setData(xmlData:XML):void;
		
		/* a dump of what the model holds */
		function dump():String;
	}
}
