package com.groovytrain.vertu.quest.modules {
	import com.groovytrain.vertu.quest.models.ModuleModel;

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public interface IModule {
		function injectDataModel(moduleModel:ModuleModel):void;		function show():void;		function hide():void;
	}
}
