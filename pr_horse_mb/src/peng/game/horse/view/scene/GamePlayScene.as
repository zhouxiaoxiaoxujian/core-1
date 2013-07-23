package peng.game.horse.view.scene
{
	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.frame.scheduler.Scheduler;
	import cactus.common.manager.ComboManager;
	import cactus.common.manager.EnterFrameManager;
	import cactus.common.manager.PopupManager;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.EventBus;
	import cactus.common.xx.goem.Vector2D;
	import cactus.ui.base.BaseScene;
	import cactus.ui.control.PButton;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	import peng.common.Config;
	import peng.game.horse.CommonMotion;
	import peng.game.horse.core.HorseBackground;
	import peng.game.horse.core.IHorseBackground;
	import peng.game.horse.core.Player;
	import peng.game.horse.core.ScrollBackground;
	import peng.game.horse.enumerate.Enum;
	import peng.game.horse.enumerate.EnumCombo;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HAIManager;
	import peng.game.horse.manager.HCache;
	import peng.game.horse.manager.HInputManager;
	import peng.game.horse.manager.HStatManager;
	import peng.game.horse.manager.PBackgroundManager;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;
	import peng.game.horse.prop.Enemy;
	import peng.game.horse.prop.GameFactory;
	import peng.game.horse.view.ui.GamePlayView_UI;
	import peng.game.horse.view.ui.Pause_POP;

	public class GamePlayScene extends BaseScene
	{
		/**
		 * 背景层
		 */
		public var bgLayer:Sprite;
		/**
		 * 道具跌落层
		 */
		public var fallLayer:Sprite;
		/**
		 * 世界，碰撞层
		 */
		public var worldLayer:Sprite;

		/**
		 * ui层
		 */
		public var uiLayer:GamePlayView_UI;
		/**
		 * 玩家
		 */
		public var player:Player;


		private var aiManager:HAIManager = HAIManager.getIns();
		private var bgManager:PBackgroundManager = PBackgroundManager.getInstance();
		private var statManager:HStatManager = HStatManager.getIns();
		private var comboManager:ComboManager = ComboManager.getIns();


		public function GamePlayScene()
		{
			super();
		}

		override protected function onAllReady():void
		{
			Debugger.info("进入 无限游戏 场景");
			Scheduler.getIns().getClock().startEnumClock(Enum.GAMEING_TIME);

			super.onAllReady();

			// 装备和道具
			buildEquip();

			// 界面
			buildUI();

			// 背景1
			buildBackground();

			// 玩家
			buildPlayer();

			// AI
			buildAI();

			// 输入
			buildInput();

			// 添加监听和游戏主循环
			addListeners();

			Config.bRunning = true;
			Config.bPlayerCanNotFly = false;

			// 初始化加分的组合技
			ComboManager.getIns().addComboItem(EnumCombo.ADD_BOUNS, EnumCombo.ADD_BOUNS_INTERVAL);
			ComboManager.getIns().addComboItem(EnumCombo.EAT_APPLE, EnumCombo.EAT_APPLE_INTERVAL);
		}

		override public function destory():void
		{
			super.destory();
			Scheduler.getIns().getClock().stopEnumClock(Enum.GAMEING_TIME);

			EnterFrameManager.getInstance().removeEnterFrameFunction(gameLoop);

			PBackgroundManager.getInstance().destory();
			HInputManager.getIns().destory();
			HorseModel.getIns().destory();
			HAIManager.getIns().destory();
			HStatManager.getIns().destory();
			removeListeners();
			player.destory();

			ComboManager.getIns().removeAllComboItems();
		}


		/**
		 * 游戏主循环
		 * @param evt
		 */
		protected function gameLoop(delay:int):void
		{
			if (Config.bPause || !Config.bRunning)
			{
				return;
			}
			// AI,碰撞
			aiManager.update(delay);

			// 计算背景
			bgManager.update(delay);

			// 统计
			statManager.update(delay);

			// 组合
			comboManager.update(delay);
		}

		private function buildBackground():void
		{
			// 构建不同层次的背景
			var bg1:HorseBackground = GameFactory.createBackground() as HorseBackground;
			var bg2:IHorseBackground = GameFactory.createBackground();
			var bg3:IHorseBackground = GameFactory.createBackground();
			var bg4:IHorseBackground = GameFactory.createBackground();
			var bg5:IHorseBackground = GameFactory.createBackground();
			var bg6:IHorseBackground = GameFactory.createBackground();
			var bg7:IHorseBackground = GameFactory.createBackground();
			var bg8:IHorseBackground = GameFactory.createBackground();
			var bg9:IHorseBackground = GameFactory.createBackground();
			var bg10:IHorseBackground = GameFactory.createBackground();


			var bg1_0:IHorseBackground = GameFactory.createBackground(HCache.getIns().getBitmapData("bg1_0"), 0, 0, 0, 0);
			bg1.addSubBg(bg1_0 as ScrollBackground);
			
			// 对于背景上的山，移动平台采取优化效率
			var spdX:int = 0;
			if (Global.isPC())
				spdX = 1;
			
			var bg1_1:IHorseBackground = GameFactory.createBackground(HCache.getIns().getBitmapData("bg1_1"), spdX, 0, 0, Global.mapToScreenY(370));
			bg1.addSubBg(bg1_1 as ScrollBackground);
			
			var spdX2:int = 0;
			if (Global.isPC())
				spdX2 = 4;
			
			var bg1_2:IHorseBackground = GameFactory.createBackground(HCache.getIns().getBitmapData("bg1_2"), spdX2, 0, 0, Global.mapToScreenY(305));
			bg1.addSubBg(bg1_2 as ScrollBackground);
			
			var bg1_3:IHorseBackground = GameFactory.createBackground(HCache.getIns().getBitmapData("bg1_3"), 20, 0, 0, Global.mapToScreenY(510));
			bg1.addSubBg(bg1_3 as ScrollBackground);

			// bg1.mapToScreen(Global.originalScreenW,Global.originalScreenH,Global.screenW,Global.screenH);
			bg1_0.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);
			bg1_2.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg2.init(HCache.getIns().getBitmapData("bg2"));
			bg2.setFloatList(["Float2"]);
			bg2.setCouldList(["Cloud1", "Cloud2"]);
			bg2.setCloudNoddleList(["CloudNoddle1"]);
			bg2.setScrollSpeed(0, 0);
			bg2.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);


			bg3.init(HCache.getIns().getBitmapData("bg3"));
			bg3.setFloatList(["Float1", "Float2"]);
			bg3.setCouldList(["Cloud1", "Cloud2"]);
			bg3.setCloudNoddleList(["CloudNoddle1"]);
			bg3.setScrollSpeed(0, 0);
			bg3.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg4.init(HCache.getIns().getBitmapData("bg4"));
			bg4.setFloatList(["Float1", "Float2", "Float3"]);
			bg4.setCouldList(["Cloud1", "Cloud2"]);
			bg4.setCloudNoddleList(["CloudNoddle1"]);
			bg4.setScrollSpeed(0, 0);
			bg4.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg5.init(HCache.getIns().getBitmapData("bg5"));
			bg5.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg5.setCouldList(["Cloud1", "Cloud2"]);
			bg5.setCloudNoddleList(["CloudNoddle1"]);
			bg5.setScrollSpeed(0, 0);
			bg5.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg6.init(HCache.getIns().getBitmapData("bg6"));
			bg6.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg6.setCouldList(["Cloud1", "Cloud2"]);
			bg6.setCloudNoddleList(["CloudNoddle1"]);
			bg6.setScrollSpeed(0, 0);
			bg6.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg7.init(HCache.getIns().getBitmapData("bg7"));
			bg7.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg7.setCouldList(["Cloud1", "Cloud2"]);
			bg7.setCloudNoddleList(["CloudNoddle1"]);
			bg7.setScrollSpeed(0, 0);
			bg7.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg8.init(HCache.getIns().getBitmapData("bg8"));
			bg8.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg8.setCouldList(["Cloud1", "Cloud2"]);
			bg8.setCloudNoddleList(["CloudNoddle1"]);
			bg8.setScrollSpeed(0, 0);
			bg8.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg9.init(HCache.getIns().getBitmapData("bg9"));
			bg9.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg9.setCouldList(["Cloud1", "Cloud2"]);
			bg9.setCloudNoddleList(["CloudNoddle1"]);
			bg9.setScrollSpeed(0, 0);
			bg9.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			bg10.init(HCache.getIns().getBitmapData("bg10"));
			bg10.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg10.setCouldList(["Cloud1", "Cloud2"]);
			bg10.setCloudNoddleList(["CloudNoddle1"]);
			bg10.setScrollSpeed(0, 0);
			bg10.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			PBackgroundManager.getInstance().init();
			PBackgroundManager.getInstance().setCanvas(bgLayer);
			PBackgroundManager.getInstance().addBackground(bg1);
			PBackgroundManager.getInstance().addBackground(bg2);
			PBackgroundManager.getInstance().addBackground(bg3);
			PBackgroundManager.getInstance().addBackground(bg4);
			PBackgroundManager.getInstance().addBackground(bg5);
			PBackgroundManager.getInstance().addBackground(bg6);
			PBackgroundManager.getInstance().addBackground(bg7);
			PBackgroundManager.getInstance().addBackground(bg8);
			PBackgroundManager.getInstance().addBackground(bg9);
			PBackgroundManager.getInstance().addBackground(bg10);
		}

		private function buildEquip():void
		{
			HorseModel.getIns().initEquip();
		}

		private function buildInput():void
		{
			HInputManager.getIns().init(onStageMouseDown, onStageMouseUp);
		}

		private function buildAI():void
		{
			HAIManager.getIns().init(this);
			HStatManager.getIns().init(this);

		}

		private function buildPlayer():void
		{
			player = new Player;
			player.mouseChildren = false;
			player.mouseEnabled = false;
			player.velocity = new Vector2D(0, 8)
			player.position = new Vector2D(200, 240);
			worldLayer.addChild(player);
		}

		private function buildUI():void
		{
			if (!bgLayer)
			{
				bgLayer = new Sprite;
				bgLayer.mouseChildren = false;
				bgLayer.mouseEnabled = false;
				addChild(bgLayer);
			}
			if (!fallLayer)
			{
				fallLayer = new Sprite;
				fallLayer.mouseChildren = false;
				fallLayer.mouseEnabled = false;
				addChild(fallLayer);
			}
			if (!worldLayer)
			{
				worldLayer = new Sprite;
				worldLayer.mouseChildren = false;
				worldLayer.mouseEnabled = false;
				addChild(worldLayer);
			}
			if (!uiLayer)
			{
				uiLayer = new GamePlayView_UI(ResourceFacade.getMC("GamePlayView_UI"));
				addChild(uiLayer);
			}

			CommonMotion.getIns().container = fallLayer;
		}

		private function onStageMouseDown(evt:MouseEvent = null):void
		{
			if (Config.bPause)
				return;

			if (Config.bPlayerCanNotFly)
				return;

			var underPoints:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
			for each (var item:* in underPoints)
			{
				if (findButton(item) != null)
				{
					// trace("点在了按钮上");
					return;
				}
			}

			// Debugger.debug(" 鼠标按下 ");

			if (HStatManager.getIns().currChance > 0)
			{
				if (!Config.DEBUG_BOUNCE_LIMIT)
				{
					HStatManager.getIns().currChance--;
				}
				player.bounceByClick();

				_bMouseDown = true;

				// 按下时持续发力
				EnterFrameManager.getInstance().registerEnterFrameFunction(updateBounce);
			}
		}

		private function findButton(target:*):PButton
		{
			if (target == null)
				return null;

			if (target is PButton)
			{
				return target;
			}
			else
			{
				return (target == undefined) ? null : findButton(target.parent);
			}
		}


		private function onStageMouseUp(evt:MouseEvent = null):void
		{
			if (Config.bPause)
				return;

			if (Config.bPlayerCanNotFly)
				return;

			if (_bMouseDown)
			{
				// Debugger.debug("--- 鼠标抬起 ---");
				_bMouseDown = false;
				EnterFrameManager.getInstance().removeEnterFrameFunction(updateBounce);
			}
		}

		private var _bMouseDown:Boolean;

		private function updateBounce(delay:int):void
		{
			if (_bMouseDown)
			{
				player.bounceByMouseDown();
			}
		}

		private function addListeners():void
		{
			addEventListener(HorseEvent.SHOW_APPLE_CORE, onShowAppleCore);
			addEventListener(HorseEvent.SHOW_SUB_APPLE, onShowSubApple);
			addEventListener(HorseEvent.SHOW_BE_DESTORY, onShowBeDestory);
			addEventListener(HorseEvent.ADD_BOUNS, onAddBouns);
			addEventListener(HorseEvent.SYS_PAUSE, onPause);
			addEventListener(HorseEvent.SYS_RESUME, onResume);

			EventBus.getIns().addEventListener(HorseEvent.USE_ITEM, onUseItem);

			EnterFrameManager.getInstance().registerEnterFrameFunction(gameLoop);
		}

		private function removeListeners():void
		{
			removeEventListener(HorseEvent.SHOW_APPLE_CORE, onShowAppleCore);
			removeEventListener(HorseEvent.SHOW_SUB_APPLE, onShowSubApple);
			removeEventListener(HorseEvent.SHOW_BE_DESTORY, onShowBeDestory);
			removeEventListener(HorseEvent.ADD_BOUNS, onAddBouns);
			removeEventListener(HorseEvent.SYS_PAUSE, onPause);
			removeEventListener(HorseEvent.SYS_RESUME, onResume);

			EventBus.getIns().removeEventListener(HorseEvent.USE_ITEM, onUseItem);

			EnterFrameManager.getInstance().removeEnterFrameFunction(gameLoop);
		}

		protected function onShowBeDestory(event:HorseEvent):void
		{
			// 显示敌人被击落的动画
			var params:Array = event.body as Array;
			var addPoint:Point = params[0];
			var enemyType:int = params[1];

			switch (enemyType)
			{
				case Enemy.TYPE_COMMON:
				{
					CommonMotion.getIns().commonEnemyFall(addPoint.x, addPoint.y);
					break;
				}
				case Enemy.TYPE_MIDDLE:
				{
					CommonMotion.getIns().middleEnemyFall(addPoint.x, addPoint.y);
					break;
				}
				case Enemy.TYPE_SENIOR:
				{
					CommonMotion.getIns().seniorEnemyFall(addPoint.x, addPoint.y);
					break;
				}
				default:
				{
					break;
				}
			}
		}

		/**
		 * 使用道具
		 * @param event
		 */
		protected function onUseItem(event:HorseEvent):void
		{
			var propVO:PropVO = event.body as PropVO;

			// 吸铁石
			if (propVO.id == HorseModel.PROP_MAGNET_ID)
			{
				HStatManager.getIns().doingMagnet = true;
			}
		}


		protected function onShowAppleCore(event:HorseEvent):void
		{
			// 显示苹果核
			var addPoint:Point = event.body as Point;

			CommonMotion.getIns().eatApple(addPoint.x, addPoint.y);
		}

		protected function onShowSubApple(event:HorseEvent):void
		{
			// 显示减去身上的持有苹果数
			var params:Array = event.body as Array;
			var addPoint:Point = params[0] as Point;
			var count:int = params[1] as int;

			CommonMotion.getIns().plusApple(count, addPoint.x + 20, addPoint.x + 20);
		}

		protected function onAddBouns(event:HorseEvent):void
		{
			// 显示加分
			var params:Array = event.body as Array;
			var addPoint:Point = params[0] as Point;
			var score:int = params[1] as int;

			// 记录combo
			var currentTimeCombo:int = ComboManager.getIns().activeCombo(EnumCombo.ADD_BOUNS);

			trace("!!加分连击数", currentTimeCombo);
			var extraScore:int = 0;
			// 准备combo
			if (currentTimeCombo <= 1)
			{
				// 没有形成连击
			}
			else
			{
				// 连击为 currentCombo次
				// 播放位置，暂时为固定
				if (currentTimeCombo % 5 == 0)
				{
					extraScore = currentTimeCombo * 5;
//					CommonMotion.getIns().playComboScore(currentTimeCombo, extraScore,Global.mapToWidth(650), Global.mapToHeight(200));
					CommonMotion.getIns().playComboScore(currentTimeCombo, extraScore, addPoint.x + 0, addPoint.x + 0);
				}
			}

			score += extraScore;

			HStatManager.getIns().currBonus += score;

			CommonMotion.getIns().addScore(score, addPoint.x + 20, addPoint.x + 20);
		}

		protected function onResume(event:Event):void
		{
			Config.bPause = false;
		}

		protected function onPause(event:Event):void
		{
			PopupManager.getInstance().showTopPanel(Pause_POP);
			Config.bPause = true;
		}

	}
}
