package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import peng.common.Config;
	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.manager.EnterFrameManager;
	import cactus.common.manager.PopupManager;
	import cactus.common.manager.SceneManager;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.EventBus;
	import peng.game.horse.core.IHorseBackground;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HCache;
	import peng.game.horse.manager.PBackgroundManager;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;
	import peng.game.horse.prop.GameFactory;
	import peng.game.horse.view.scene.GamePlayScene;
	import peng.game.horse.view.scene.SelectScene;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;

	/**
	 * 选择界面UI
	 * @author Peng
	 */
	public class SelectView_UI extends PAutoView
	{
		[Bind(ref="a")]
		public var option_PB:Option_UI = new Option_UI; 

		[Bind(align="center", ref="t")]
		public var btn_start_PB:PButton;

		[Bind(align="center", ref="t")]
		public var skillbar_PB:Skillbar_UI = new Skillbar_UI;

		// 多语言选择框
		[Bind(ref="a")]
		public var langBox_PB:PLanguageSelectBox = new PLanguageSelectBox;
		
		// 滚动背景的容器
		public var mmc_movie_bg_PB:MovieClip;

		// 弹出弹窗层
		public var mmc_pop_layer_PB:MovieClip;

		public function SelectView_UI(src:* = null)
		{
			super(src);
		}

		override public function init():void
		{
			super.init();
			btn_start_PB.addEventListener(MouseEvent.CLICK, btn_startClick);

			addEventListener(HorseEvent.UI_SHOW_SKILL_POP, onUIShowSkillPop);

			EventBus.getIns().addEventListener(HorseEvent.INSTALL_PROP_TO_SKILL_BAR, onInstallPropToSkillBar);
			EventBus.getIns().addEventListener(HorseEvent.UNINSTALL_PROP_FROM_SKILL_BAR, onUninstallPropToSkillBar);
			EventBus.getIns().addEventListener(HorseEvent.UI_CLOSE_SKILL_POP, onCloseSkillPop)

			// 初始化默认选中的道具
			for each (var vo:PropVO in HorseModel.getIns().getUserEquips())
			{
				skillbar_PB.install(vo);
			}

			// 加入滚动背景
			var bg:IHorseBackground = GameFactory.createBackground();
			bg.init(HCache.getIns().getBitmapData("bg"));
//			bg.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg.setCouldList(["Cloud1", "Cloud2"]); 
			bg.setCloudNoddleList(["CloudNoddle1"]);
			bg.setScrollSpeed(0, 0); 
			bg.mapToScreen(Global.originalScreenW,Global.originalScreenH,Global.screenW,Global.screenH);

			PBackgroundManager.getInstance().init();
			PBackgroundManager.getInstance().setCanvas(mmc_movie_bg_PB);
			PBackgroundManager.getInstance().addBackground(bg);
			PBackgroundManager.getInstance().changeBackgroundByIndex(0);

			EnterFrameManager.getInstance().registerEnterFrameFunction(update);
		}
		
		private function update(delay:int):void
		{ 
			PBackgroundManager.getInstance().update(delay);
		}

		override public function destory():void
		{
			super.destory();

			EnterFrameManager.getInstance().removeEnterFrameFunction(update);
			PBackgroundManager.getInstance().destory();

			btn_start_PB.removeEventListener(MouseEvent.CLICK, btn_startClick);
			removeEventListener(HorseEvent.UI_SHOW_SKILL_POP, onUIShowSkillPop);

			EventBus.getIns().removeEventListener(HorseEvent.INSTALL_PROP_TO_SKILL_BAR, onInstallPropToSkillBar);
			EventBus.getIns().removeEventListener(HorseEvent.UNINSTALL_PROP_FROM_SKILL_BAR, onUninstallPropToSkillBar);
			EventBus.getIns().removeEventListener(HorseEvent.UI_CLOSE_SKILL_POP, onCloseSkillPop);
		}


		/**
		 * 关闭上方弹出的技能面板
		 * @param event
		 */
		protected function onCloseSkillPop(event:Event):void
		{
			skillbar_PB.btn_add_PB.visible = true;
		}

		/**
		 *
		 * @param event
		 */
		protected function onUninstallPropToSkillBar(event:HorseEvent):void
		{
			var vo:PropVO = event.body as PropVO;
			Debugger.debug("uninstall", vo);
			skillbar_PB.unInstall(vo);

			HorseModel.getIns().uninstallEquip(vo);

		}

		/**
		 *
		 * @param event
		 */
		protected function onInstallPropToSkillBar(event:HorseEvent):void
		{
			var vo:PropVO = event.body as PropVO;
			Debugger.debug("install", vo);
			skillbar_PB.install(vo);
		}

		protected function onUIShowSkillPop(event:Event):void
		{
			Debugger.debug("显示技能弹窗");
			// 弹出在本层，以便切换场景时remove掉
			// PopupManager.getInstance().showPanel(SkillShop_POP, null, null, -99999, -99999, mmc_pop_layer_PB);
			PopupManager.getInstance().showPanel(SkillShop_POP);

			skillbar_PB.btn_add_PB.visible = false;
		}


		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		private function btn_startClick(evt:MouseEvent):void
		{
			btn_start_PB.enabled = false;
			//  测试
//			SceneManager.getInstance().changeScene(SelectScene);
//			return;


			// 玩游戏次数加1
			Config.service.addUserPlayCount();

			var userEquips:String = "";
			var index:int = 0;
			for each (var vo:PropVO in HorseModel.getIns().getUserEquips())
			{
				index++;
				userEquips += vo.id.toString();

				if (index < HorseModel.getIns().getUserEquips().length)
					userEquips += ","
			}
			Debugger.debug("保存装备", userEquips);

			Config.service.setUserEquipsServerStr(userEquips);
			SceneManager.getInstance().changeScene(GamePlayScene);
		}
	}
}
