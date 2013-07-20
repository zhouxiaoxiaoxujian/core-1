package cactus.common
{
	import flash.display.Sprite;
	import flash.utils.getTimer;

	import cactus.common.frame.DefaultResourceHelper;
	import cactus.common.frame.scheduler.Scheduler;
	import cactus.common.manager.AppManager;
	import cactus.common.manager.EnterFrameManager;
	import cactus.common.manager.PopupManager;
	import cactus.common.manager.SceneManager;
	import cactus.ui.PUIConfig;

	import org.spicefactory.parsley.context.ContextBuilder;
	import org.spicefactory.parsley.core.context.Context;

	/**
	 * 基础世界容器
	 * 1 负责初始化各种管理器
	 * 2 负责初始化Parsley配置，不同的平台应继承此类，实现不同的逻辑
	 * @author Peng
	 */
	public class DefaultGameWorld extends BaseGameWorld implements IGameWorld
	{
		/**
		 * 游戏启动方法
		 * @default
		 */
		public var gameStart : Function;

		/**
		 * 游戏初始化
		 *
		 */
		public function gameInit() : void
		{
			// 初始化各类无关框架的管理器
			initManager();
			// 
			// 初始化手机，PC等平台的差异
			initPlatform();

			// 编译程序框架
			buildFramework();
		}

		/**
		 * 初始化不同平台的配置
		 */
		protected function initPlatform() : void
		{
		}

		/**
		 * 初始化各类管理器
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

			// 初始化UI框架
			PUIConfig.initResourceHelper(new DefaultResourceHelper);
		}


		private function buildFramework() : void
		{
			var t : int = getTimer();
			trace("build module at " + t);
			// 初始化CactusGame模块
			var builder : ContextBuilder = ContextBuilder.newSetup().domain(AppManager.getInstance().applicationDomain).
				scope(moduleName).newBuilder();
			onRegister(builder, false);

			// 所有模块加载完，才能一起build
			var context : Context = builder.build();
			// 多个关联模块，使用延迟注册
			registerMappingCommandToContext(context);

			ContextManager.instance.context = context;
			trace("build module cost " + (getTimer() - t));
		}

	} //end GameWorld
}
