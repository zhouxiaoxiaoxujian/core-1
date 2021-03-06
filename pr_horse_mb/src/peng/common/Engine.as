///////////////////////////////////////////////////////////
//  Engine.as
//  Macromedia ActionScript Implementation of the Class Engine
//  Generated by Enterprise Architect
//  Created on:      12-八月-2010 15:26:13
//  Original author: Pengx
///////////////////////////////////////////////////////////

package peng.common
{
	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.tools.util.Debugger;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mx.core.ByteArrayAsset;

	/**
	 * 游戏加载和初始化主引擎
	 * @author Pengx
	 * @version 1.0
	 * @created 12-八月-2010 15:26:13
	 */
	public class Engine extends Sprite
	{
		[Embed(source = "asset/res_horse.swf", mimeType = "application/octet-stream")]
		public static var resource:Class;

		[Embed(source = "asset/lang.xml", mimeType = "application/octet-stream")]
		public static var langXML:Class;

		[Embed(source = "asset/engine.xml", mimeType = "application/octet-stream")]
		public static var engineXML:Class;

		/**
		 * 所有的单机资源
		 * @default
		 */
		public static const assets:Array = [resource];





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
			Global.mode = Global.MODE_SINGLE;
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

			// this.scrollRect = new Rectangle(0, 0, Config.SCREEN_WIDTH, Config.SCREEN_HEIGHT);
		}

		private function onResourceError(e:*):void
		{
			trace("资源加载出错 :" + e.vo.name);
		}

		protected function initEngine(e:Event = null):void
		{
			// 等待一段时间，给Stage的ORIENTATION改变留出时间
			var timout:uint = setTimeout(function():void
			{
				if (!_ifInPreloader)
				{
					loadConfig();
					clearTimeout(timout);
				}
			}, 0);

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
				this.dispatchEvent(new Event(CONFIG_LOADED));
				onLoadBaseResourceComplete();
			}
		}

		protected function onLoadBaseResourceComplete():void
		{
			initGame();
		}

		public function initGame():void
		{
			Global.stage = stage;
			Global.gameWorld = _gameWorld;
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
		 * 开始游戏
		 *
		 */
		public function beginGame():void
		{
			_gameWorld.gameStart();
		}
	} //end Engine
}
