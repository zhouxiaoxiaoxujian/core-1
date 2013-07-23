package peng.game.horse.view.ui
{
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.tools.ToolTip;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.EventBus;
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.control.*;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;

	/**
	 * 道具商店列表弹窗
	 * @author Peng
	 */
	public class SkillShop_POP extends BasePopupPanel
	{
		public var slt_skillList_PB:PTileList = new PTileList(null, 3, 2, SkillShopItemRenderer_UI, null, 60, 60, 20, 20);
		public var btn_close_PB:PButton;
		public var txt_tip_PB:PTextField = new PTextField;

		public function SkillShop_POP(src:* = null)
		{
//			new (getDefinitionByName("SkillShop_POP") as Class
			super(ResourceFacade.getMC("SkillShop_POP"));
		}

		override public function init():void
		{
			super.init();
			btn_close_PB.addEventListener(MouseEvent.CLICK, btn_closeClick);

			// 初始化
			slt_skillList_PB.data = HorseModel.getIns().getAllProp();


			addEventListener(HorseEvent.CLICK_PROP, clickProp);

//			ToolTip.getInstance().setGlobalTextTarget(txt_tip_PB, Local.getString("shop_default_tip"));
			ToolTip.getInstance().setGlobalTextTarget(txt_tip_PB, "{shop_default_tip}");
		}

		override public function destory():void
		{
			super.destory();
			btn_close_PB.removeEventListener(MouseEvent.CLICK, btn_closeClick);

			removeEventListener(HorseEvent.CLICK_PROP, clickProp);
			ToolTip.getInstance().removeGlobalTextTarget(txt_tip_PB);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		override public function showIn():void
		{
			this.visible = true;
			var toX:int = this.x;
			var toY:int = this.y;

			this.y = -1200;
			TweenLite.to(this, .75, {x: toX, y: toY, ease: Elastic.easeOut, easeParams: [0.5, 0.6], onComplete: onShowIned});
		}

		override public function showOut():void
		{
			TweenLite.to(this, .5, {y: -1200, onComplete: onShowOuted});
		}


		private function btn_closeClick(evt:MouseEvent):void
		{
			EventBus.getIns().dispatchEvent(new HorseEvent(HorseEvent.UI_CLOSE_SKILL_POP));
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		protected function clickProp(event:HorseEvent):void
		{
			var renderer:SkillShopItemRenderer_UI = event.body;

			Debugger.debug("点击道具", renderer.data);

			// 如果还可以安装道具，则安装道具
			if (HorseModel.getIns().hasEquipPlace() && !renderer.isSelected())
			{
				Debugger.debug("安装道具");
				HorseModel.getIns().installEquip(renderer.data as PropVO);
				renderer.install();
			}
			else if (renderer.isSelected())
			{
				Debugger.debug("卸载道具");
				HorseModel.getIns().uninstallEquip(renderer.data as PropVO);
				renderer.unInstall();
			}
			else
			{
				Debugger.debug("栏目已满，无法安装道具");
			}
		}
	}
}
