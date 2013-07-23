package peng.game.horse
{
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.tools.cache.single.DisplayCachePool;
	
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;


	public class HUtils
	{
		public function HUtils()
		{
		}
		
		public static function getBitmapMovieClip(name:String):MovieClip
		{
			return DisplayCachePool.getInstance().getMovieClip(name,ResourceFacade.getMC(name));
		}

	}
}