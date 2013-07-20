package cactus.common.tools.cache.single
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageQuality;
	
	import cactus.common.frame.interfaces.IDisposeAble;

	/**
	 * 动画位图缓存数据 
	 * @author Pengx
	 * 
	 */
	public class BitmapDataMovieCache implements IDisposeAble
	{
		private var _target:MovieClip;
		private var _stage:Stage;
		private var _cacheVector:Vector.<BitmapDataCache>;
		/**
		 * 
		 * @param target		要缓存的影片剪辑(只能缓存主时间轴动画)
		 * @param stage			舞台
		 * @param dynamicCache	是否动态缓存(当用到时才缓存)
		 * 
		 */
		public function BitmapDataMovieCache(target:MovieClip,stage:Stage = null,dynamicCache:Boolean = true)
		{
			_target = target;
			_stage	= stage;
			var num:int = target.totalFrames;
			_cacheVector = new Vector.<BitmapDataCache>(num,true);
			if(!dynamicCache)
			{
				var oldQuality:String;
				if(stage != null)
				{
					oldQuality = stage.quality;
					stage.quality = StageQuality.BEST;
				}
				for(var i:int = 0 ; i < num ; i++)
				{
					_target.gotoAndStop(i+1);
					_cacheVector[i] = new BitmapDataCache(_target);
				}
				if(stage != null)
				{
					stage.quality = oldQuality;
				}
			}
		}
		
		/**
		 * 获得帧的缓存(从1开始)
		 * @param frame 第几帧
		 * @return 
		 * 
		 */
		public function getBitmapDataCache(frame:int):BitmapDataCache
		{
			var flag:int = frame - 1;
			if(_cacheVector[flag] == null)
			{
				_target.gotoAndStop(frame);
				_cacheVector[flag] = new BitmapDataCache(_target,0,_stage);
			}
			return _cacheVector[flag];
		}
		
		/**
		 * 获得影片剪辑 
		 * @return 
		 * 
		 */
		public function getMC():MovieClip
		{
			return _target;
		}
		
		/**
		 *  释放资源
		 * 
		 */
		public function destory():void
		{
			_target = null;
			_stage  = null;
			for(var i:int = 0 ; i < _cacheVector.length ; i++)
			{
				if(_cacheVector[i] != null)
				{
					_cacheVector[i].destory();
				}
			}
			_cacheVector = null;
		}
	}
}