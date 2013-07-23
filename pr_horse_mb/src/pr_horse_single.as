package
{
	import cactus.common.manager.SceneManager;
	
	import peng.common.Engine;
	import peng.common.PCStandaloneGameWorld;
	import peng.common.platform.PlatformAdapter;
	import peng.game.horse.view.scene.SelectScene;

	[SWF(width = 750, height = 600, backgroundColor = "#ffffff", frameRate = "30")]
	public class pr_horse_single extends Engine
	{
		public function pr_horse_single()
		{
			super(gameStart, PCStandaloneGameWorld); 
		}

		private function gameStart():void
		{
//			this.scaleX = this.scaleY = .1;

			PlatformAdapter.getIns().init(PlatformAdapter.NONE, function():void
			{
//				PopupManager.getInstance().showPanel(Loading_POP);
				SceneManager.getInstance().changeScene(SelectScene); 
			});
		}
	}
}

