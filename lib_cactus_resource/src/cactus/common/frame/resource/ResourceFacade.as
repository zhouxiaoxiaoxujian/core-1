package cactus.common.frame.resource
{
	import cactus.common.frame.proxy.ProxyDisplayObject;
	import cactus.common.frame.resource.helper.ResourceConfigLoadHelper;
	import cactus.common.frame.resource.helper.ResourceLoadHelper;
	
	import com.greensock.loading.LoaderMax;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * 资源管理外观类
	 * @author Pengx
	 *
	 */
	public class ResourceFacade
	{
		public static var ERROR_HANDLE:Function;
		private static var _errorHandle:Function;

		//============获取单例类============
		/**
		 * 获取资源地图
		 * @return
		 *
		 */
		public static function get map():ResourceMap
		{
			return ResourceMap.getInstance();
		}

		public static function init(config:XML):void
		{
			ResourceLoadHelper.init(config);
		}
		
		//============加载配置文件============
		/**
		 * 加载配置文件
		 * @param url			链接地址
		 * @param completeFun	完成调用函数
		 *
		 */
		public static function loadConfig(url:String, completeFun:Function):void
		{
			ResourceConfigLoadHelper.load(url, completeFun, onLoadError);
		}

		private static function onLoadError(e:* = null):void
		{
			if (_errorHandle != null)
				_errorHandle(e);
		}

		
		/**
		 * 加载所有资源
		 * @param completeFun
		 *
		 */
		public static function loadAll(completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void
		{
			ResourceLoadHelper.loadAll(completeFun,errorFun,progressFun);
		}
		
		/**
		 * 根据关联对象数组加载资源
		 * @param arr					要加载的素材链接名数组
		 * @param completeFun
		 *
		 */
		public static function loadByRelateObjectArr(arr:Array, completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void
		{
			ResourceLoadHelper.loadByRelateObjectArr(arr,completeFun,errorFun,progressFun);
		}
		
		/**
		 * 根据config中的name加载
		 * @param name
		 * @param completeFun
		 * @param errorFun
		 * @param progressFun
		 */
		public static function loadByName(name:String, completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void
		{
			ResourceLoadHelper.loadByName(name,completeFun,errorFun,progressFun);
		}
		
		/**
		 * 加载模块
		 * 用于加载一个模块由程序swf和uiswf组成的两个文件，都定义在relatedList中
		 * @param name
		 * @param completeFun
		 * @param errorFun
		 * @param progressFun
		 */
		public static function loadModule(name:String, completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void
		{
			ResourceLoadHelper.loadByRelateObjectArr([name],completeFun,errorFun,progressFun);
		}
		
		//============获取资源============
		public static function getContent(nameOrUrl:String):*
		{
			return LoaderMax.getContent(nameOrUrl);
		}

		public static function getLoader(nameOrUrl:String):*
		{
			return LoaderMax.getLoader(nameOrUrl);
		}

		public static function getUncompressContent(nameOrUrl:String):*
		{
			var data:ByteArray = getContent(nameOrUrl) as ByteArray;
			data.position = 0;
			data.uncompress();
			return data.readObject();
		}

		/**
		 * 获得影片剪辑（静态加载）
		 * 当确定库中有此资源时使用
		 * @param name
		 * @return
		 *
		 */
		public static function getMC(name:String):MovieClip
		{
			var myClass:Class = getDefinitionByName(name) as Class;
			return new myClass() as MovieClip;
		}

		/**
		 * 获得代理显示对象
		 * @param name
		 * @param replaceObj
		 * @return
		 */
		public static function getProxy(name:String, replaceObj:MovieClip = null):ProxyDisplayObject
		{
			var mc:DisplayObject;
			var proxy:ProxyDisplayObject;
			var _replaceObj:MovieClip = replaceObj == null ? (new MovieClip) : replaceObj;

			try
			{
				mc = getMC(name);
				proxy = new ProxyDisplayObject(mc, true);
				return proxy;
			}
			catch (e:Error)
			{
				if (_replaceObj != null)
				{
					proxy = new ProxyDisplayObject(_replaceObj, false);
					addProxyVO(name, proxy);
					return proxy;
				}
			}
			throw new Error("can't get proxy");
		}

		/**
		 * 获得BitmapData
		 * @param name
		 * @return
		 */
		public static function getBD(name:String):BitmapData
		{
			var myClass:Class = getDefinitionByName(name) as Class;
			return new myClass() as BitmapData;
		}

		// 代理加载
		/**
		 * 代理列表
		 * @default
		 */
		private static var _proxyList:Dictionary = new Dictionary;

		private static function addProxyVO(linkage:String, proxy:ProxyDisplayObject):void
		{
			// 一个资源里有多个素材名字可以加载回调
			var key:String = linkage;

			if (!_proxyList[key])
			{
				_proxyList[key] = new Array;
			}

			// 同一个id只load一次
			if (_proxyList[key].length == 0)
			{
				load(linkage);
			}

			_proxyList[key].push(proxy);
		}

		private static function load(linkage:String):void
		{
			try
			{
//				LoaderManager.loadSwf(convertFiles([dictId]), loadProxyComplete);
			}
			catch (error:Error)
			{
				trace(error.getStackTrace());
			}

			function loadProxyComplete(evt:Event):void
			{
				var key:String = linkage;

				for each (var proxy:ProxyDisplayObject in _proxyList[key])
				{
					var clip:MovieClip = getMC(linkage);

					if (clip)
					{
						proxy.setDisplay(clip);
					}
				}
				_proxyList[key] = new Array;
			}
		}

	}
}