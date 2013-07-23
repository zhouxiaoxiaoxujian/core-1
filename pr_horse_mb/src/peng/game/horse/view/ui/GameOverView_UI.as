package peng.game.horse.view.ui
{
	import cactus.common.Global;
	import cactus.common.manager.EnterFrameManager;
	import cactus.common.manager.SceneManager;
	import cactus.common.tools.Local;
	import cactus.common.tools.Utils;
	import cactus.common.tools.util.NumberFormat;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PButton;
	import cactus.ui.control.PTextField;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import peng.common.Config;
	import peng.common.platform.PlatformAdapter;
	import peng.game.horse.HUtils;
	import peng.game.horse.core.IHorseBackground;
	import peng.game.horse.enumerate.EnumAddress;
	import peng.game.horse.manager.HCache;
	import peng.game.horse.manager.HStatManager;
	import peng.game.horse.manager.PBackgroundManager;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.HorseServiceLocal;
	import peng.game.horse.prop.GameFactory;
	import peng.game.horse.view.scene.SelectScene;

	public class GameOverView_UI extends PAutoView
	{
		[Bind(align="center", ref="t")]
		public var gameScore_PB:GameOverScore_UI = new GameOverScore_UI();

		/**
		 * 返回主页
		 * @default
		 */
		[Bind(align="center", ref="a")]
		public var btn_home_PB:PButton;

		// public var txt_gameover_tip_PB:PTextField = new PTextField;
		
		[Bind(ref="a")]
		public var bottom_PB:GameOverBottom = new GameOverBottom;

		/**
		 * 滚动背景的容器
		 * @default
		 */
		public var mmc_movie_bg_PB:MovieClip;

		// 各种分享功能按钮
		[Bind(align="right")]
		public var btn_fb_PB:PButton;
		[Bind(align="right")]
		public var btn_twt_PB:PButton;
		[Bind(align="right")]
		public var btn_sina_PB:PButton;
		[Bind(align="right")]
		public var btn_qq_PB:PButton;

		public function GameOverView_UI(src:* = null)
		{
			super(src);
		}

		override public function init():void
		{
			btn_home_PB.addEventListener(MouseEvent.CLICK, onBtnHomeClick);

			gameScore_PB.txt_distance_PB.text = HStatManager.getIns().currDistance.toString();
			gameScore_PB.txt_time_PB.text = NumberFormat.msToTimeString(HStatManager.getIns().currTime);
			gameScore_PB.txt_destory_PB.text = HStatManager.getIns().currDestory.toString();

			gameScore_PB.txt_totalCount_PB.text = HStatManager.getIns().caculateScore().toString();

//			txt_gameover_score_PB.text = Local.getString("gameover_score");
//			txt_gameover_distance_PB.text = Local.getString("gameover_distance");
//			txt_gameover_time_PB.text = Local.getString("gameover_time");
//			txt_gameover_bring_down_point_PB.text = Local.getString("gameover_bring_down_point");

			gameScore_PB.txt_gameover_score_PB.text = "{gameover_score}";
			gameScore_PB.txt_gameover_distance_PB.text = "{gameover_distance}";
			gameScore_PB.txt_gameover_time_PB.text = "{gameover_time}";
			gameScore_PB.txt_gameover_bring_down_point_PB.text = "{gameover_bring_down_point}";
//			txt_gameover_tip_PB.text = "{gameover_tip}";

			PlatformAdapter.getIns().submitHighScore(HStatManager.getIns().caculateScore());

			// 增加统计
			Config.service.addUserFlyDistance(HStatManager.getIns().currDistance);

			// 最高分替换
			Config.service.setData(HorseServiceLocal.SHARE_OBJ_RECORD_BEST_SCORE, HStatManager.getIns().caculateScore().toString(), function(value:String):void
			{
				HorseModel.getIns().bestScore = Math.max(HStatManager.getIns().caculateScore(), HorseModel.getIns().bestScore);
			});

			// 加入滚动背景
			var bg:IHorseBackground = GameFactory.createBackground();
			bg.init(HCache.getIns().getBitmapData("bg"));
//			bg.setFloatList(["Float1", "Float2", "Float3", "Float4"]);
			bg.setCouldList(["Cloud1", "Cloud2"]);
			bg.setCloudNoddleList(["CloudNoddle1"]);
			bg.setScrollSpeed(0, 0);
			bg.mapToScreen(Global.originalScreenW, Global.originalScreenH, Global.screenW, Global.screenH);

			PBackgroundManager.getInstance().init();
			PBackgroundManager.getInstance().setCanvas(mmc_movie_bg_PB);
			PBackgroundManager.getInstance().addBackground(bg);
			PBackgroundManager.getInstance().changeBackgroundByIndex(0);

			EnterFrameManager.getInstance().registerEnterFrameFunction(update);

			if (Global.isMobile())
			{
				btn_fb_PB.visible = true;
				btn_qq_PB.visible = true;
				btn_sina_PB.visible = true;
				btn_twt_PB.visible = true;
			}
			else
			{
				btn_fb_PB.visible = false;
				btn_qq_PB.visible = false;
				btn_sina_PB.visible = false;
				btn_twt_PB.visible = false;
			}

			btn_fb_PB.addEventListener(MouseEvent.CLICK, onFbClick);
			btn_twt_PB.addEventListener(MouseEvent.CLICK, onTwtClick);
			btn_sina_PB.addEventListener(MouseEvent.CLICK, onSinaClick);
			btn_qq_PB.addEventListener(MouseEvent.CLICK, onQqClick);

			Global.gameWorld.createAdmob(Config.AD_BOTTOM_X, Config.AD_BOTTOM_Y, Config.AD_WIDTH, Config.AD_HEIGHT);
		}

		private function onFbClick(evt:MouseEvent):void
		{
			Utils.jumpToUrl(EnumAddress.ADDR_FACEBOOK);
		}

		private function onTwtClick(evt:MouseEvent):void
		{
			Utils.jumpToUrl(EnumAddress.ADDR_TWITTER);
		}

		private function onSinaClick(evt:MouseEvent):void
		{
			Utils.jumpToUrl(EnumAddress.ADDR_WEIBO);
		}

		private function onQqClick(evt:MouseEvent):void
		{
			Utils.jumpToUrl(EnumAddress.ADDR_QZONE);
		}

		override public function destory():void
		{
			super.destory();

			EnterFrameManager.getInstance().removeEnterFrameFunction(update);
			PBackgroundManager.getInstance().destory();

			btn_home_PB.removeEventListener(MouseEvent.CLICK, onBtnHomeClick);

			btn_fb_PB.removeEventListener(MouseEvent.CLICK, onFbClick);
			btn_twt_PB.removeEventListener(MouseEvent.CLICK, onTwtClick);
			btn_sina_PB.removeEventListener(MouseEvent.CLICK, onSinaClick);
			btn_qq_PB.removeEventListener(MouseEvent.CLICK, onQqClick);

			Global.gameWorld.destroyAdmob();
		}

		private function update(delay:int):void
		{
			PBackgroundManager.getInstance().update(delay);
		}

		override public function fireDataChange():void
		{
		}

		protected function onBtnHomeClick(event:MouseEvent):void
		{
			btn_home_PB.enabled = false;
			SceneManager.getInstance().changeScene(SelectScene);
		}
	}
}
