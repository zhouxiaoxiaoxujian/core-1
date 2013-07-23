package peng.game.horse.view.scene
{
	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.util.Debugger;
	import cactus.ui.base.BaseScene;

	import peng.common.Config;
	import peng.common.HorsePointFactory;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.view.ui.SelectView_UI;

	public class SelectScene extends BaseScene
	{
		public var ui : SelectView_UI

		public function SelectScene()
		{
			super();
		}

		override public function destory() : void
		{
			super.destory();

			Global.gameWorld.destroyAdmob();
		}

		override protected function onAllReady() : void
		{
			Debugger.info("进入选择场景");
			super.onAllReady();

			buildUI();

			SoundManager.getInstance().playBgSound(HSoundFlag.BgSound);

			HorsePointFactory.login();

			Global.gameWorld.createAdmob(Config.AD_BOTTOM_X, Config.AD_BOTTOM_Y, Config.AD_WIDTH, Config.AD_HEIGHT);
		}


		private function buildUI() : void
		{
			ui = new SelectView_UI(ResourceFacade.getMC("SelectView_UI"));
			addChild(ui);
		}
	}
}
