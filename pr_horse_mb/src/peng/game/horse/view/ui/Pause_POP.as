package peng.game.horse.view.ui
{
	import cactus.common.Global;
	import cactus.common.tools.Local;
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.control.PTextField;

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;

	import peng.common.Config;
	import peng.game.horse.HUtils;

	/**
	 * 暂停面板
	 * @author Peng
	 */
	public class Pause_POP extends BasePopupPanel
	{

		public var txt_content_PB_T:PTextField = new PTextField;

		public function Pause_POP($source:* = null, isModuleRoot:Boolean = false)
		{
			super("Pause_POP");
		}

		override public function init():void
		{
			txt_content_PB_T.text = "{game_pause_tip}";
			this.addEventListener(MouseEvent.CLICK, onThisClick);

			drawInnerMask(0x000000, .1);

			// android平台显示loading广告
			Global.gameWorld.createAdmob(Config.AD_BOTTOM_X, Config.AD_BOTTOM_Y, Config.AD_WIDTH, Config.AD_HEIGHT);
		}

		protected function onThisClick(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
			Config.bPause = false;
		}

		override public function destory():void
		{
			super.destory();

			Global.gameWorld.destroyAdmob();
		}

		override public function showIn():void
		{
			this.visible = true;
			onShowIned();
		}

		override public function showOut():void
		{
			onShowOuted();
		}

	}
}
