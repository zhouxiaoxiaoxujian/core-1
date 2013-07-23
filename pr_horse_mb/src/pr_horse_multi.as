package
{
	import cactus.common.manager.SceneManager;
	
	import peng.common.EngineMulti;
	import peng.common.PCConfigableGameWorld;
	import peng.common.platform.PlatformAdapter;
	import peng.game.horse.view.scene.SelectScene;

	[SWF(width = 750, height = 600, backgroundColor = "#ffffff", frameRate = "30")]
	public class pr_horse_multi extends EngineMulti
	{ 
		public function pr_horse_multi()
		{
			super(gameStart, PCConfigableGameWorld);
		} 

		private function gameStart():void
		{
			PlatformAdapter.getIns().init(PlatformAdapter.NONE, function():void
			{
//				PopupManager.getInstance().showPanel(Loading_POP);
				SceneManager.getInstance().changeScene(SelectScene); 
			});
		}

	}
}
