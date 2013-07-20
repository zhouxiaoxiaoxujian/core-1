package cactus.ui.module
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import mx.core.ByteArrayAsset;
	
	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.frame.resource.helper.ResourceLoadHelper;
	import cactus.common.tools.Local;
	import cactus.common.tools.util.ByteArrayAssetFactory;
	import cactus.common.tools.util.Debugger;

	/**
	 * 游戏加载和初始化主引擎
	 * @author Cactus
	 * @version 1.0
	 * @created 12-八月-2010 15:26:13
	 */
	public class Engine extends Sprite
	{
		[Embed(source = "asset/cactus_ppt_res.swf", mimeType = "application/octet-stream")]
		public static var resource1:Class;
		
		[Embed(source = "asset/cactus_ui_res.swf", mimeType = "application/octet-stream")]
		public static var resource2:Class;

		[Embed(source = "asset/cactus_dy.swf", mimeType = "application/octet-stream")]
		public static var resource3:Class;
		
		[Embed(source = "asset/lang.xml", mimeType = "application/octet-stream")]
		public static var langXML:Class;

		/**
		 * 所有的单机资源
		 * @default
		 */
		public static const assets:Array = [resource1, resource2,resource3];

		/**
		 * 配置文件加载完毕
		 */
		public static const CONFIG_LOADED:String = "configLoaded";
		/**
		 * 基础资源加载完毕
		 */
		public static const BASE_RESOURCE_LOADED:String = "baseResourceLoaded";

		private var _loadSuccessIndex:int = 0;
		private var _ifInPreloader:Boolean = false;
		private var _gameWorld:DefaultGameWorld;

		public function Engine($startMethod:Function, $gameWorld:Class = null)
		{
			if (!$gameWorld)
			{
				_gameWorld = new DefaultGameWorld();
			}
			else
			{
				_gameWorld = new $gameWorld;
			}

			_gameWorld.gameStart = $startMethod;
			addEventListener(Event.ADDED_TO_STAGE, initEngine);
			ResourceFacade.ERROR_HANDLE = onResourceError;
		}

		private function onResourceError(e:*):void
		{
			trace("资源加载出错 :" + e.vo.name);
		}

		protected function initEngine(e:Event = null):void
		{
			if (!_ifInPreloader)
			{
				loadConfig();
			}
		}

		/**
		 * 设置是否是通过Preloader加载
		 * 如果是通过Preloader加载，Preloader需要统计进度和一下信息，很多方法是在Preloader里面调用，不用在Engine里面主动触发。
		 */
		public function setIfInPreloader(v:Boolean):void
		{
			_ifInPreloader = v;
		}

		public function loadConfig():void
		{
			for each (var resource:Class in assets)
			{
				var loader:Loader = new Loader;
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onResLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onResIoError);

				var lc:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				lc.allowCodeImport = true;
				loader.loadBytes(ByteArrayAsset(new resource()), lc);
			}

		}

		protected function onResIoError(event:IOErrorEvent):void
		{
			Debugger.error("Engine onResIoError", event.text, event.toString());
		}

		private function onResLoadComplete(e:Event):void
		{
			_loadSuccessIndex++;
			if (_loadSuccessIndex == assets.length)
			{
				Local.parseXML(ByteArrayAssetFactory.createXMLAsset(langXML));

				this.dispatchEvent(new Event(CONFIG_LOADED));
				onLoadBaseResourceComplete();
			}

		}

		protected function gameConfigLoadComplete(evt:Event = null):void
		{

		}

		protected function configLoadComplete():void
		{
			this.dispatchEvent(new Event(CONFIG_LOADED));
			if (!_ifInPreloader)
			{
				loadBaseResource();
			}
		}

		/**
		 * 加载游戏基础资源
		 */
		public function loadBaseResource():void
		{
			//ResourceLoadHelper.loadByRelateObject("base",onLoadBaseResourceComplete);
			ResourceLoadHelper.loadAll(onLoadBaseResourceComplete);
		}

		protected function onLoadBaseResourceComplete():void
		{
			initGame();
		}

		public function initGame():void
		{
			Global.stage = stage;
			addChild(_gameWorld);
			_gameWorld.gameInit();
			onInitComplete();
		}

		private function onInitComplete():void
		{
			if (!_ifInPreloader)
			{
				beginGame();
			}
		}

		/**
		 * 获取图片
		 * @param url
		 * @return
		 *
		 */
		static public function getImageFromUrl(url:String):DisplayObject
		{
			try
			{
				var loader:Loader = new Loader();
				loader.load(new URLRequest(url), new LoaderContext(true));
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageComplete);
				return loader;
			}
			catch (e:Error)
			{
				//--hide--trace("[Error]getImageFromUrl:"+url);
			}
			return null;
		}

		static private function onImageComplete(e:Event):void
		{
			var target:DisplayObject = DisplayObject(e.currentTarget.content);
			target.x = -target.width / 2;
			target.y = -target.height / 2;
		}

		/**
		 * 开始游戏
		 *
		 */
		public function beginGame():void
		{
			_gameWorld.gameStart();
		}
	} //end Engine
}
