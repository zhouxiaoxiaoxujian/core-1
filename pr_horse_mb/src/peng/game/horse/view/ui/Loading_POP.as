package peng.game.horse.view.ui
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import gs.TweenLite;

	import cactus.common.Global;
	import cactus.common.manager.PopupManager;
	import peng.game.horse.model.HorseModel;
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.control.*;

	public class Loading_POP extends BasePopupPanel
	{


		public function Loading_POP(src:* = null)
		{
			super("Loading_POP");
		}

		override public function init():void
		{
			super.init();

			// android平台显示loading广告
			// Global.gameWorld.createAdmob();


			// 自动消除
			var timeOut:uint = setTimeout(function():void
			{
				close();
				clearTimeout(timeOut);

				if (HorseModel.getIns().userPlayCount <= 1)
				{
					// 打开 help页
					PopupManager.getInstance().showTopPanel(Help_POP);
				}

				// android平台显示loading广告
				// Global.gameWorld.destroyAdmob();
			}, 1000);

		}

		override public function destory():void
		{
			super.destory();
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		override public function showIn():void
		{
			this.visible = true;
			onShowIned();
		}

		override public function showOut():void
		{
			TweenLite.to(this, 1, {y: -1200, onComplete: onShowOuted});
		}


		override protected function onShowOuted():void
		{
			super.onShowOuted();



		}
	}
}
