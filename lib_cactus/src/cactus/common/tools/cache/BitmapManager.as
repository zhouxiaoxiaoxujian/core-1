/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 * @create		2010-8-23 下午02:20:25
 * @update
 **/
package cactus.common.tools.cache
{
	
	import flash.utils.Dictionary;
	
	/**
	 * 缓存位图管理
	 * @author Peng
	 */
	public class BitmapManager
	{
		private static var instance:BitmapManager=new BitmapManager;


		// 缓存具体引用用
		private var bmDict:Dictionary=new Dictionary;
		
		// 缓存位图数据用
		private var dataDict:Dictionary=new Dictionary;	

		public function BitmapManager()
		{
		}

		public static function getIns():BitmapManager
		{
			return instance;
		}

		// ----- 对于 FrameData的存取，建议使用 -----
		public function hasData(name:String):Boolean
		{
			if (dataDict[name] == null || dataDict[name] == undefined)
				return false;
			return true;
		}

		public function addData(name:String,frames:Vector.<Vector.<BitmapFrameInfo>>):void
		{
			dataDict[name]=frames;
		}

		public function getData(name:String):Vector.<Vector.<BitmapFrameInfo>>
		{
			return dataDict[name] as Vector.<Vector.<BitmapFrameInfo>>;
		}

		// ----- 对于 FrameData的存取，建议使用 end -----

		// ----- 对于 BitmapMovieClip 实例的存取，暂时废弃 ----
		public function hasMovieClip(name:String):Boolean
		{
			if (bmDict[name] == null || bmDict[name] == undefined)
				return false;
			return true;
		}

		public function addMovieClip(name:String,clip:BitmapMovieClip):BitmapMovieClip
		{
			bmDict[name]=clip;
			return clip;
		}

		public function getMovieClip(name:String):BitmapMovieClip
		{
			return bmDict[name] as BitmapMovieClip;
		}

		// ----- 对于 BitmapMovieClip 实例的存取，暂时废弃 end ----

	}
}