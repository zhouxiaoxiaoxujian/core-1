package cactus.common.tools.cache.single
{
	import cactus.common.Global;
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.Dictionary;

	/**
	 * 显示对象缓存池 
	 * @author Pengx
	 * 
	 */
	public class DisplayCachePool
	{
		/**
		 * 缓存字典 
		 */
		private var _cacheDic:Dictionary;
		/**
		 * 舞台引用 
		 */
		private var _stage:Stage;
		
		private static var _instance:DisplayCachePool;
		
		public function DisplayCachePool(param:SingletonEnforcer)
		{
			_cacheDic = new Dictionary(false);//如果为true可以动态释放内存
		}
		
		/**
		 * 单例 
		 * @return 
		 * 
		 */
		public static function getInstance():DisplayCachePool
		{
			if(_instance==null)
			{
				_instance = new DisplayCachePool(new SingletonEnforcer());	 
			}
			return _instance;
		}
		
		/**
		 * 注册舞台
		 * @param _stage
		 * 
		 */
		public function registerStage(stage:Stage):void
		{
			this._stage = stage;
		}
		
		/**
		 * 缓存一个显示对象 
		 * @param name		缓存名
		 * @param target	缓存对象
		 * @param rotation	缓存角度
		 * 
		 */
//		public function cacheDisplay(name:String,target:DisplayObject,rotation:int = 0):void
//		{
//			if(ifHad(name)) return;
//			var cache:BitmapDataCache = new BitmapDataCache(target,rotation,_stage);
//			_cacheDic[name] = cache;
//		}
		
		/**
		 * 缓存一个显示对象的所有角度 
		 * @param name			缓存名
		 * @param target		缓存对象
		 * @param dynamicCache	是否动态缓存
		 * 
		 */
//		public function cacheDisplay360(name:String,target:DisplayObject,dynamicCache:Boolean = true):void
//		{
//			if(ifHad(name)) return;
//			var cache:BitmapDataCache360 = new BitmapDataCache360(target,_stage,dynamicCache);
//			_cacheDic[name] = cache;
//		}
		
		/**
		 * 缓存一个影片剪辑(只能缓存主时间轴) 
		 * @param name			缓存名
		 * @param target		缓存对象
		 * @param dynamicCache	是否动态缓存
		 * 
		 */
		private function cacheMovieClip(name:String,target:MovieClip,dynamicCache:Boolean = true):void
		{
			if(ifHad(name)) return;
//			var cache:BitmapDataMovieCache = new BitmapDataMovieCache(target,_stage,dynamicCache);
			var cache:BitmapDataMovieCache = new BitmapDataMovieCache(target,Global.stage ,dynamicCache);
			_cacheDic[name] = cache;
		}
		
		/**
		 * 获得单针显示对象 
		 * @param name			缓存名
		 * @param disableMouse	是否禁用鼠标事件
		 * @return 
		 * 
		 */
//		public function getSprite(name:String,disableMouse:Boolean = true):Sprite
//		{
//			if(!ifHad(name))
//			{
//				return null;
//			}
//			var sp:Sprite;
//			var data:* = _cacheDic[name];
//			if(data is BitmapDataCache)
//			{
//				sp = new SpriteCache(data,disableMouse);
//			}
//			else if(data is BitmapDataCache360)
//			{
//				sp = new SpriteCache360(data,disableMouse);
//			}
//			return sp;
//		}
		
		/**
		 * 获得影片剪辑对象 
		 * @param name			缓存名
		 * @param disableMouse	是否禁用鼠标事件
		 * @return 
		 * 
		 */
		public function getMovieClip(name:String,mc:MovieClip,disableMouse:Boolean = true):MovieClip
		{
			if(!ifHad(name))
			{
				cacheMovieClip(name,mc);
//				return null;
			}
			var data:* = _cacheDic[name];
			var mc:MovieClip = new MovieClipCache(data,disableMouse);
			return mc;
		}
		
		/**
		 * 是否已经存在这个名字的缓存对象 
		 * @param name	缓存名
		 * @return 
		 * 
		 */
		public function ifHad(name:String):Boolean
		{
			if(_cacheDic[name] != undefined)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		/**
		 * 释放缓存 (先确保有关显示对象都已经释放)
		 * @param name	缓存名
		 * 
		 */
		public function destroyCache(name:String):void
		{
			if(!ifHad(name))
			{
				return;
			}
			trace("destroy cache : " + name);
			_cacheDic[name].destroy();
			delete _cacheDic[name];
		}
		
		/**
		 * 释放所有缓存 (先确保有关显示对象都已经释放)
		 * 
		 */
		public function destroyAllCache():void
		{
			for(var i:* in _cacheDic)
			{
				_cacheDic[i].destroy();
				delete _cacheDic[i];
			}
		}
	}
}
class SingletonEnforcer{}
