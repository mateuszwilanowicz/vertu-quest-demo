package com.groovytrain.vertu.quest.components.video {
	import com.akamai.net.AkamaiNetStream;

	import flash.media.Video;
	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public interface IVideoControls {
		function setData(vidObj : Video, nsObj : AkamaiNetStream, vidDuration:Number, vidPath:String):void;
		function stopVideo():void;
		function gotoLang(value:Number):void;
		function set repeat(value:Boolean):void;		
		function set timeLapse(value:Number):void;
		
	}
	
	
	
}
