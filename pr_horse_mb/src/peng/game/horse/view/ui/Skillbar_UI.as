package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import peng.common.Config;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.manager.PopupManager;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.EventBus;
	import cactus.common.tools.util.FontUtil;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;
	import peng.game.horse.view.control.PropButton;
	import peng.game.horse.view.control.PropRenderer_UI;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;

	/**
	 * 已装备的技能栏
	 * @author Peng
	 */
	public class Skillbar_UI extends PAutoView
	{
		public var btn_add_PB:PButton = new PLazyClickButton(null,1000);
		public var txt_score_PB:TextField;
		public var txt_distance_desc_PB:PTextField = new PTextField;
		public var propRender2_PB:PropRenderer_UI = new PropRenderer_UI;
		public var propRender1_PB:PropRenderer_UI = new PropRenderer_UI;

		public function Skillbar_UI(src:* = null)
		{
			super(src);
		}

		override public function init():void
		{
			super.init();
			btn_add_PB.addEventListener(MouseEvent.CLICK, btn_addClick);
			propRender1_PB.addEventListener(MouseEvent.CLICK, onPropRenderClick);
			propRender2_PB.addEventListener(MouseEvent.CLICK, onPropRenderClick);

			propRender1_PB.clear();
			propRender2_PB.clear();
			
			propRender1_PB.buttonMode = true;
			propRender2_PB.buttonMode = true;

			txt_score_PB.text = HorseModel.getIns().userFlyDistance.toString() + "m";
			txt_distance_desc_PB.text = "{select_total_distance_desc}";
		}

		override public function destory():void
		{
			super.destory();
			btn_add_PB.removeEventListener(MouseEvent.CLICK, btn_addClick);
			propRender1_PB.removeEventListener(MouseEvent.CLICK, onPropRenderClick);
			propRender2_PB.removeEventListener(MouseEvent.CLICK, onPropRenderClick);
		}

		private function onPropRenderClick(event:MouseEvent):void
		{
			var renderer:PropRenderer_UI = event.currentTarget as PropRenderer_UI;
			
			// 空容器
			if ( renderer.propIconName =="")
			{
				return;
			}
			
			var vo:PropVO = renderer.data as PropVO;
			EventBus.getIns().dispatchEvent(new HorseEvent(HorseEvent.UNINSTALL_PROP_FROM_SKILL_BAR, vo));
		}
		
		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		private function btn_addClick(evt:MouseEvent):void
		{
			dispatchEvent(new HorseEvent(HorseEvent.UI_SHOW_SKILL_POP, null, true));
		}

		/**
		 * 卸载道具
		 * @param vo
		 */
		public function unInstall(vo:PropVO):void
		{
			if (propRender1_PB.propIconName == vo.icon)
			{
				propRender1_PB.clear();
				return;
			}

			if (propRender2_PB.propIconName == vo.icon)
			{
				propRender2_PB.clear();
				return;
			}
		}

		/**
		 * 装备道具
		 * @param vo
		 */
		public function install(vo:PropVO):void
		{
			if (propRender1_PB.propIconName == vo.icon || propRender2_PB.propIconName == vo.icon)
			{
				Debugger.debug("已经装备了", vo);
				return;
			}

			if (propRender1_PB.isEmpty())
			{
				propRender1_PB.data = vo;
				return;
			}

			if (propRender2_PB.isEmpty())
			{
				propRender2_PB.data = vo;
				return;
			}
		}
	}
}
