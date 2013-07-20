package cactus.common.manager
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;

	import mx.modules.ModuleManager;

	public class AppManager extends EventDispatcher
	{
		/**
		 * 保证只有一个实例
		 * @return
		 *
		 */
		public static function getInstance() : AppManager
		{
			if (_instance)
				return _instance;

			_instance = new AppManager(new Lock());

			return _instance;
		}
		private static var _instance : AppManager;

		public function AppManager(lock : Lock)
		{
			if (lock)
			{
				_appDomain = ApplicationDomain.currentDomain;
				_assetsDomain = new ApplicationDomain();
			}
			else
			{
				throw new Error("AppManager is Singleton Class");
			}
		}

		/**
		 * 获得应用的域
		 */
		public function get applicationDomain() : ApplicationDomain
		{
			return _appDomain;
		}

		public function get assetDomain() : ApplicationDomain
		{
			return _assetsDomain;
		}

		/**
		 * 场景的根
		 * @return
		 *
		 */
		public function get root() : Sprite
		{
			return _root;
		}

		public function set root(value : Sprite) : void
		{
			_root = value;
		}

		public function get stage() : Stage
		{
			return _stage;
		}

		public function set stage(value : Stage) : void
		{
			_stage = value;
		}

		public function get width() : Number
		{
			return getInstance().stage.stageWidth;
		}

		public function get height() : Number
		{
			return getInstance().stage.stageHeight;
		}


		private var _appDomain : ApplicationDomain;

		private var _assetsDomain : ApplicationDomain;

		private var _mm : ModuleManager;

		private var _root : Sprite;

		private var _stage : Stage;
	}
}

class Lock
{
}
