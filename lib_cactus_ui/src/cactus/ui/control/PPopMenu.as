package cactus.ui.control
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.events.ViewEvent;

	/**
	 * 基本弹出性质的弹出菜单
	 * 用法：
	 * PopupManager.getInstance().showPanel(XXXMenuPop, null, params, evt.stageX, evt.stageY);
	 * @author: Peng
	 */
	public class PPopMenu extends BasePopupPanel
	{
		public function PPopMenu($source:*=null)
		{
			super($source);
		}

		override public function showIn():void
		{
			drawInnerMask(0x000000, 0.1);
			_makerLayer.addEventListener(MouseEvent.CLICK, onMaskerClick);
			this.visible=true;
			onShowIned();
		}

		override public function showOut():void
		{
			onShowOuted();
		}

		override protected function onShowOuted():void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.SHOW_OUTED));
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
		}

		protected function onMaskerClick(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.CLOSE));
		}
	}
}
