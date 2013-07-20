package
{
	import cactus.common.frame.DefaultResourceHelper;
	import cactus.common.manager.SceneManager;
	import cactus.ui.PUIConfig;
	import cactus.ui.module.DefaultGameWorld;
	import cactus.ui.module.Engine;
	import cactus.ui.module.EngineMulti;
	import cactus.ui.module.mvcmodule.scene.TestScene1;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;

	[SWF(width = 700, height = 600, backgroundColor = "#ffffff")]
	public class cactus_ui_single extends Engine
	{

		public function cactus_ui_single()
		{
			// 初始化UI框架
			PUIConfig.initResourceHelper(new DefaultResourceHelper);

			super(gameStart, DefaultGameWorld);
		}

		private function gameStart() : void
		{
			SceneManager.getInstance().changeScene(TestScene1);
		}

	}
}
