
package cactus.ui.demo
{

	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.frame.resource.helper.ResourceLoadHelper;
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * 游戏加载和初始化主引擎
	 * @author Pengx
	 * @version 1.0
	 * @created 12-八月-2010 15:26:13
	 */
	public class EngineMulti extends Sprite
	{

		private var _ifInPreloader:Boolean = false;

		private static var _gameWorld:DefaultGameWorld;

		public function EngineMulti($startMethod:Function, $gameWorld:Class = null)
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
		}

		/**
		 * 获取游戏世界
		 * @return
		 *
		 */
		public static function get gameWorld():DefaultGameWorld
		{
			return _gameWorld;
		}

		private function onResourceError(e:*):void
		{
			trace("资源加载出错:" + e.vo.name);
		}

		private function initEngine(e:Event = null):void
		{
			//本地调试时，不是在preload里面加载，直接内部完成加载
			if (!_ifInPreloader)
			{
				loadConfig();
			}
		}

		/**
		 * 加载配置文件
		 */
		private function loadConfig():void
		{
			ResourceFacade.loadConfig("../asset/config.xml", configLoadComplete);

		}

		private function configLoadComplete():void
		{
			loadBaseResource();
		}

		/**
		 * 加载游戏基础资源
		 */
		private function loadBaseResource():void
		{
			ResourceFacade.ERROR_HANDLE = onResourceError;
			ResourceLoadHelper.loadByRelateObjectArr(["base", "new"], onLoadBaseResourceComplete);
		}

		private function onLoadBaseResourceComplete():void
		{
//			Local.parseXML(new XML(ResourceFacade.getData("lang")));
			initGame();
		}

		/**
		 * 初始化完成
		 * 如果是在preload里面要抛事件给它，否则直接开始游戏
		 * @param e
		 *
		 */
		private function onInitComplete():void
		{
			if (!_ifInPreloader)
			{
				beginGame();
			}
		}

		//----------------- 公开给preload的方法 -------------------

		/**
		 * 初始化游戏(当加载完成所有资源)
		 *
		 */
		public function initGame():void
		{
			Global.stage = stage;
			addChild(_gameWorld);
			_gameWorld.gameInit();
			onInitComplete();
		}

		/**
		 * 开始游戏(一切准备完毕)
		 *
		 */
		public function beginGame():void
		{
			_gameWorld.gameStart();
		}

		/**
		 * 设置是否是通过Preloader加载
		 * 如果是通过Preloader加载，Preloader需要统计进度和一下信息，很多方法是在Preloader里面调用，不用在Engine里面主动触发。
		 */
		public function setIfInPreloader(v:Boolean):void
		{
			_ifInPreloader = v;
		}

	} //end Engine
}
