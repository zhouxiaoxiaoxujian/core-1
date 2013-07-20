package cactus.ui.module
{
	import cactus.common.Global;
	import cactus.common.IGameWorld;
	import cactus.common.frame.scheduler.Scheduler;
	import cactus.common.manager.EnterFrameManager;
	import cactus.common.manager.PopupManager;
	import cactus.common.manager.SceneManager;
	import cactus.common.tools.util.Stats;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	/**
	 */
	public class DefaultGameWorld extends Sprite implements IGameWorld
	{

		/**
		 * 广告是否可用
		 * @default
		 */
		private var _advEnable : Boolean = true;

		public var keyBackCallBack : Function;

		public var keyHomeCallBack : Function;


		/**
		 * 游戏启动方法
		 * @default
		 */
		public var gameStart : Function;

		public function DefaultGameWorld()
		{
		}

		/**
		 * 游戏初始化
		 *
		 */
		public function gameInit() : void
		{
			initManager();
			Global.stage = this.stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		public function get advEnable() : Boolean
		{
			return _advEnable;
		}

		public function set advEnable(value : Boolean) : void
		{
			_advEnable = value;
		}

		/**
		 * 获取游戏世界容器
		 * @return
		 *
		 */
		public function get gameWorldContainer() : DisplayObjectContainer
		{
			return this;
		}

		/**
		 * 创建Admob
		 */
		public function createAdmob(x : int, y : int, width : int, height : int, delay : int = 0) : void
		{
		}

		/**
		 * 销毁Admob
		 */
		public function destroyAdmob() : void
		{

		}



		/**
		 * 初始化管理器
		 *
		 */
		protected function initManager() : void
		{
			var sceneCanvas : Sprite = new Sprite();
			addChild(sceneCanvas);
			var popupPanelCanvas : Sprite = new Sprite();
			addChild(popupPanelCanvas);

			EnterFrameManager.getInstance().registerStage(this.stage);
			SceneManager.getInstance().setCanvas(sceneCanvas);
			PopupManager.getInstance().setCanvas(popupPanelCanvas);

			//初始化音效
			//			SoundFlag.initSoundInSoundManager();

			EnterFrameManager.getInstance().startEnterFrame();

			// 任务调度
			Scheduler.getIns().run();

		}

		/**
		 * 性能监控
		 */
		private var _statsBox : Stats;
		;

		/**
		 * 调试快捷键
		 * @param e
		 *
		 */
		protected function onKeyDown(e : KeyboardEvent) : void
		{
			//			trace(e.ctrlKey,e.charCode,"d".charCodeAt(0));
			if (e.ctrlKey)
			{
				//ctrl + d 显示性能监控
				if (e.charCode == "d".charCodeAt(0) || e.charCode == "D".charCodeAt(0))
				{
					checkStatsBox();
				}
			}

			if (e.keyCode == Keyboard.MENU)
			{
				checkStatsBox();
			}

			if (e.keyCode == Keyboard.BACK && keyBackCallBack != null)
			{
				keyBackCallBack(e)
			}

			if (e.keyCode == Keyboard.HOME && keyHomeCallBack != null)
			{
				keyHomeCallBack(e);
			}
		}

		protected function checkStatsBox() : void
		{
			if (_statsBox == null)
			{
				_statsBox = new Stats();
			}
			if (stage.contains(_statsBox))
			{
				stage.removeChild(_statsBox);
			}
			else
			{
				stage.addChild(_statsBox);
			}
		}
	} //end GameWorld
}