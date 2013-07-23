package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import peng.common.Config;
	import cactus.common.manager.EnterFrameManager;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;
	import peng.game.horse.view.control.LifeBar;
	import peng.game.horse.view.control.PropRenderer_UI;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;

	public class GamePlayView_UI extends PAutoView
	{
		/**
		 * 最高分
		 * @default
		 */
		[Bind(align="right", ref="t")]
		public var txt_best_score_PB:TextField;

		/**
		 * 楼层
		 */
		[Bind(align="center")]
		public var txt_level_PB:TextField;

		/**
		 * 弹射机会
		 */
		public var txt_chance_PB:TextField;

		/**
		 * 分数板
		 */
		[Bind(align="right", ref="t")]
		public var txt_score_PB:TextField;
		
		[Bind(align="right", ref="t")]
		public var txt_score_desc_PB:PTextField = new PTextField;
		/**
		 * 无敌进度条
		 */
//		public var pgb_zool_PB:PProgressBar = new PProgressBar;


		/**
		 * 技能栏1
		 */
		[Bind(ref="a")]
		public var propRender1_PB:PropRenderer_UI = new PropRenderer_UI;

		/**
		 * 技能栏2
		 */
		[Bind(ref="a")]
		public var propRender2_PB:PropRenderer_UI = new PropRenderer_UI;


		/**
		 * 技能栏3
		 * @default
		 */
		[Bind(ref="a")]
		public var propRender3_PB:PropRenderer_UI = new PropRenderer_UI;

		/**
		 * 暂停按钮
		 */
		[Bind(ref="a")]
		public var btn_pause_PB:PButton;


		public var txt_apples_desc_PB:PTextField = new PTextField;
//		public var txt_power_desc_PB:PTextField = new PTextField;




		/**
		 * 活跃的，需要CD计数的道具栏
		 * @default
		 */
		public var activePropRenderers:Array = [];

		/**
		 * 生命条
		 */
		public var lifebar_PB:LifeBar = new LifeBar;
		
		public function GamePlayView_UI(src:* = null)
		{
			super(src)
		}

		override public function init():void
		{
			super.init();
			
			lifebar_PB.currLife = Config.gameOverCount;
			
			txt_level_PB.visible = false;
			
			
			propRender1_PB.visible = false;
			propRender2_PB.visible = false;
			propRender3_PB.visible = false;

//			pgb_zool_PB.maximum = 100;
//			pgb_zool_PB.value = 1;

			txt_level_PB.text = "1";
			txt_score_PB.text = "0";

			btn_pause_PB.addEventListener(MouseEvent.CLICK, onPauseClick);

			txt_apples_desc_PB.text = "{game_apples}";
//			txt_power_desc_PB.text = "{game_power}"
			txt_score_desc_PB.text = "{game_score}";

			// 安装技能
			for each (var prop:PropVO in HorseModel.getIns().getUserEquips())
			{
				// 主动技能显示在右下角
				if (!prop.isPassivitySkill())
				{
					if (propRender3_PB.isEmpty())
					{
						propRender3_PB.data = prop;
						propRender3_PB.clickMode = true;
						propRender3_PB.visible = true;
						activePropRenderers.push(propRender3_PB);
						continue;
					}
				}
				// 被动技能
				else
				{
					if (propRender1_PB.isEmpty())
					{
						propRender1_PB.data = prop;
						propRender1_PB.visible = true;
						continue;
					}

					if (propRender2_PB.isEmpty())
					{
						propRender2_PB.data = prop;
						propRender2_PB.visible = true;
						continue;
					}
				}
			}

			txt_apples_desc_PB.visible = false;
			txt_best_score_PB.text = HorseModel.getIns().bestScore.toString();
			EnterFrameManager.getInstance().registerEnterFrameFunction(update);
		}

		protected function update(delay:int):void
		{
			for each (var renderer:PropRenderer_UI in activePropRenderers)
			{
				renderer.update(delay);
			}

		}

		override public function destory():void
		{
			super.destory();
			activePropRenderers = [];
			btn_pause_PB.removeEventListener(MouseEvent.CLICK, onPauseClick);

			EnterFrameManager.getInstance().removeEnterFrameFunction(update);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		protected function onPauseClick(event:MouseEvent):void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SYS_PAUSE));
			event.stopImmediatePropagation();
		}
	}
}