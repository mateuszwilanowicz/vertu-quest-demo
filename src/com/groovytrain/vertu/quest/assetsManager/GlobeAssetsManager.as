package com.groovytrain.vertu.quest.assetsManager {

	/**
	 * @author Mateusz Wilanowicz - GroovyTrain.com
	 */
	public class GlobeAssetsManager {

		[Embed(source = "/../assets/movieclips.swf", symbol = "WorldMovieClip")]
		public static const GLOBE_WORLD_MOVIE : Class;
		
		[Embed(source = "/../assets/movieclips.swf", symbol = "ModuleThumbnail")]
		public static const GLOBE_MODULE_THUMBNAIL : Class;
		
		[Embed(source = "/../assets/movieclips.swf", symbol = "CategoryThumbs")]
		public static const GLOBE_CATEGORY_THUMBNAIL : Class;
		
		[Embed(source = "/../assets/movieclips.swf", symbol = "ModuleThumbnailHigh")]
		public static const GLOBE_MODULE_HIGH_RES : Class;

		
		public function GlobeAssetsManager() {
			
		}
	}
}
