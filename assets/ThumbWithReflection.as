package {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;

	public class ThumbWithReflection extends MovieClip {
		public var nr : int;
		public var toMask : MovieClip;
		public var masker : MovieClip;
		public var image : MovieClip;

		public function setNr(arg0 : int) : void {
			nr = arg0;
		}
		
		public function ThumbWithReflection() {
			toMask.mask = masker;
		}
	}
}
