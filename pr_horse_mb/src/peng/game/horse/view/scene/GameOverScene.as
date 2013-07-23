package peng.game.horse.view.scene
{
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.util.Debugger;
	import cactus.ui.base.BaseScene;

	import peng.game.horse.HSoundFlag;
	import peng.game.horse.view.ui.GameOverView_UI;

	public class GameOverScene extends BaseScene
	{

		private var _ui:GameOverView_UI;

		public function GameOverScene()
		{
			super();
		}

		override protected function onAllReady():void
		{
			Debugger.info("进入 GameOver 场景");
			super.onAllReady();

			buildUI();

			SoundManager.getInstance().stopBgSound();
			SoundManager.getInstance().playSound(HSoundFlag.SGameOver);
		}

		private function buildUI():void
		{
			_ui = new GameOverView_UI(ResourceFacade.getMC("GameOverView_UI"));
			addChild(_ui);
		}
	}
}
