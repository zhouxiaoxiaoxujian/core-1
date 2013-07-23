package peng.common.platform
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.system.Security;

	import peng.common.Config;
	import cactus.common.Global;
	import cactus.common.tools.util.Debugger;
	import peng.game.horse.model.HorseModel;

	public class PlatformAdapter extends EventDispatcher
	{

		// ====================================================================
		// ====================== 定义平台           ===========================
		// ====================================================================
		/**
		 *
		 * @default
		 */
		public static const NONE:String = "0";
		/**
		 * pc版本的kongreate平台
		 * @default
		 */
		public static const PC_KONGREATE:String = "1";
		/**
		 * Android AppChina
		 * @default
		 */
		public static const ANDROID_APPCHINA:String = "2";


		// ====================================================================
		// ====================== 定义统计和存储内容 ===========================
		// ====================================================================
		/**
		 * key:世界最高分记录
		 * @default
		 */
		public static const STAT_WORLD_RECORD:String = "World Record";


		/**
		 * key:玩家玩游戏的次数
		 * @default
		 */
		public static const DATA_PLAY_COUNT:String = "playCount";




		// ====================================================================
		// ====================== 定义事件 ===========================
		// ====================================================================
		/**
		 * 初始化完成
		 */
		public static const EVENT_INIT_COMPLETE:String = "EVENT_INIT_COMPLETE";





		private static var _instance:PlatformAdapter = new PlatformAdapter;



		public var api:*;
		public var currPlatform:String = "none";


		private var _initCompleteCallBack:Function;
		/**
		 * 加载计数器
		 */
		private var _loadCount:int = 0;



		public function PlatformAdapter()
		{
		}

		public static function getIns():PlatformAdapter
		{
			return _instance;
		}

		public function init(platformName:String, $initCompleteCallBack:Function):void
		{
			// 初始化完成回调
			_initCompleteCallBack = $initCompleteCallBack;

			currPlatform = platformName


			try
			{
				if (currPlatform == PC_KONGREATE)
				{
					var apiPath:String = "http://www.kongregate.com/flash/API_AS3_Local.swf";

					var request:URLRequest = new URLRequest(apiPath);
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAPIComplete);
					loader.load(request);

					// kongregate的还必须加入显示列表
					Global.stage.addChild(loader);

					Security.allowDomain(apiPath);
				}
				else
				{
					checkLoadComplete();
				}
			}
			catch (error:Error)
			{
				// do nothing;
				Debugger.error("PlatformAdapter", error.getStackTrace());
			}

		}

		public function destory():void
		{

		}

		/**
		 * 提交最高分的特例接口
		 */
		public function submitHighScore(value:int):void
		{
			if (currPlatform == PC_KONGREATE)
			{
				api.stats.submit("World Record", value);
			}
		}

		private function loadAPIComplete(event:Event):void
		{
			if (currPlatform == PC_KONGREATE)
			{
				api = event.target.content;

				// 添加share content的监听
//				_loadCount++;
//				api.sharedContent.addLoadListener(DATA_PLAY_COUNT, onPlayCountLoad);

				// 连接api
				api.services.connect();
				checkLoadComplete();
			}

		}

		private function onPlayCountLoad(params:Object):void
		{
			var id:Number = params.id;
			var name:String = params.name;
			var permalink:String = params.permalink;
			var content:String = params.content;
			var label:String = params.label;


			Config.service.setUserPlayCount(int(content));
			_loadCount--;
			checkLoadComplete();
		}


		private function checkLoadComplete():void
		{
			if (_loadCount == 0)
			{
				_initCompleteCallBack();
			}
		}
	}
}
