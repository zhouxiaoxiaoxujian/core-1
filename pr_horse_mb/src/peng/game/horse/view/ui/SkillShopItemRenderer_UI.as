package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import peng.common.Config;
	import cactus.common.frame.interfaces.ISelected;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.tools.Local;
	import cactus.common.tools.ToolTip;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.EventBus;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;
	import peng.game.horse.view.control.PropButton;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.IPTileListRenderer;
	import cactus.ui.control.PButton;

	/**
	 * 道具商店的渲染器
	 * @author Peng
	 */
	public class SkillShopItemRenderer_UI extends PAutoView implements IPTileListRenderer, ISelected
	{

		public var mmc_btnHolder_PB:MovieClip;

		private var _button:PropButton

		public function SkillShopItemRenderer_UI($sourceName:String = null)
		{
			super("SkillShopItemRenderer_UI");
		}

		override public function init():void
		{
			addEventListener(HorseEvent.CLICK_PROP_INNER_BUTTON, onClickPropInnerButton);
		}

		override public function destory():void
		{
			super.destory();
			removeEventListener(HorseEvent.CLICK_PROP_INNER_BUTTON, onClickPropInnerButton);
			ToolTip.getInstance().removeGlobalTextTip(this);
		}

		override public function fireDataChange():void
		{ 
			var vo:PropVO = this.data as PropVO;

			var mcBtn:MovieClip = ResourceFacade.getMC(vo.icon);
			_button = new PropButton(mcBtn);

			while (mmc_btnHolder_PB.numChildren > 0)
				mmc_btnHolder_PB.removeChildAt(0);
			mmc_btnHolder_PB.addChild(_button);

			Debugger.debug("玩家飞行距离", HorseModel.getIns().userFlyDistance,"米");
			
			
			// 是否可以解锁
			if ( Config.DEBUG_ALL_PROP || HorseModel.getIns().userFlyDistance >= vo.needPlay)
			{
				_button.enabled = true;

				// 是否已经安装
				if (HorseModel.getIns().hasInstall(vo))
				{
					install();
				}
				
				ToolTip.getInstance().setGlobalTextTip(this, Local.getString(vo.normalTip), Local.getString(vo.selectedTip));	
			}
			else
			{
				_button.enabled = false;
				
				var needDistance:int = vo.needPlay;
				var currDistance:int = HorseModel.getIns().userFlyDistance;
				var d:int = needDistance - currDistance;
				
				ToolTip.getInstance().setGlobalTextTip(this, Local.getString(vo.normalTip)+Local.getString("shop_need_fly_distance")+d.toString()+"m", Local.getString(vo.selectedTip));
			}

		}

		override public function get width():Number
		{
			return 90;
		}

		override public function get height():Number
		{
			return 90;
		}

		public function isSelected():Boolean
		{
			return _button.selected;
		}

		public function install():void
		{
			_button.selected = true;
			EventBus.getIns().dispatchEvent(new HorseEvent(HorseEvent.INSTALL_PROP_TO_SKILL_BAR, this.data));
		}

		public function unInstall():void
		{
			_button.selected = false;
			EventBus.getIns().dispatchEvent(new HorseEvent(HorseEvent.UNINSTALL_PROP_FROM_SKILL_BAR, this.data));
		}

		protected function onClickPropInnerButton(event:HorseEvent):void
		{
			if(_button.enabled)
			{
				dispatchEvent(new HorseEvent(HorseEvent.CLICK_PROP, this, true));	
			}
			
		}
	}
}
