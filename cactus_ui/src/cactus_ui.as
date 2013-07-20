package
{
	import cactus.common.Global;
	import cactus.common.manager.SceneManager;
	import cactus.ui.module.DefaultGameWorld;
	import cactus.ui.module.EngineMulti;
	import cactus.ui.module.mvcmodule.scene.TestScene1;

	[SWF(width=1000, height=800, backgroundColor="#ffffff")]
	public class cactus_ui extends EngineMulti
	{
		public function cactus_ui()
		{
			super(gameStart, DefaultGameWorld); 
		}

		private function gameStart():void
		{
			Global.initCapabilities(1000,800);
			
			// 控件集合
			SceneManager.getInstance().changeScene(TestScene1);
		}
	}
}
