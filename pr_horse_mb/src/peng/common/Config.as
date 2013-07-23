package peng.common
{
	import cactus.common.Global;
	import cactus.common.frame.scheduler.Scheduler;
	import cactus.common.tools.Hook;
	import cactus.common.tools.Local;
	import cactus.common.tools.util.FontUtil;
	import cactus.common.xx.goem.Vector2D;
	
	import flash.display.Stage;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import peng.game.horse.model.IHorseService;

	/**
	 * 配置
	 *
	 */
	public class Config
	{
		// 广告的尺寸
		public static const AD_WIDTH:int = 650;
		public static const AD_HEIGHT:int = 80; 

		
		public static const gameOverCount:int = 3;
		/**
		 * 是否暂停
		 * @default
		 */
		public static function get bPause():Boolean
		{
			return _bPause;
		}

		/**
		 * @private
		 */
		public static function set bPause(value:Boolean):void
		{
			_bPause = value;

			if (_bPause)
			{
				Scheduler.getIns().run();
			}
			else
			{
				Scheduler.getIns().stop();
			}
		}

		public static function get AD_BOTTOM_X():Number
		{
			return (Global.screenW - AD_WIDTH) / 2;
		}

		public static function get AD_BOTTOM_Y():Number
		{
			return (Global.screenH - AD_HEIGHT);
		}

		// 所有Debug上线后均为false

		/**
		 * 是否开启Game Over
		 * @default
		 */
		public static const DEBUG_NO_GAME_OVER:Boolean = false;

		/**
		 * 是否开启调试苹果不消耗
		 */
		public static const DEBUG_BOUNCE_LIMIT:Boolean = false;

		/**
		 * 是否开启所有道具可用
		 * @default
		 */
		public static const DEBUG_ALL_PROP:Boolean = false;

		/**
		 * 数据服务
		 * @default
		 */
		public static var service:IHorseService;

		/**
		 * 添加AI敌人的速率倍数，值越大，添加敌人越快
		 * 上线后应该为1，或者注释掉
		 * @default
		 */
		public static function get DEBUG_AI_ENEMY_ADD_THREDHOLD():int
		{
			return Hook.getInt("game_speed");
		}

		/**
		 * 游戏是否进行中
		 * @default
		 */
		public static var bRunning:Boolean = false;


		/**
		 * 标志玩家不可以弹起,如碰到坏人后
		 * @default
		 */
		public static var bPlayerCanNotFly:Boolean = false;

		private static var _bPause:Boolean;

		// 游戏可否开始？
		// 要求第一次绘制的线条能够接住游戏者
		public static var GAME_RUNNING:Boolean;

		public static function get SCREEN_WIDTH():Number
		{
			if (Global.screenW <= 100)
				throw new Error("wrong state");
			return Global.screenW;
//			return 750
		}

		public static function get SCREEN_HEIGHT():Number
		{
			if (Global.screenH <= 100)
				throw new Error("wrong state");
			return Global.screenH;
//			return 600
		}

		/**
		 * 第一层地面的高度
		 * @default
		 */
		public static function get FLOOR_HEIGHT():int
		{
			return Hook.getInt("game_floor_height");
		}

		/**
		 *
		 * @param txt
		 */
		public static function setGroboldFont(txt:TextField):void
		{
			FontUtil.setFont(txt, "grobold");
		}

		/**
		 *
		 * @param txt
		 */
		public static function setLocalFont(txt:TextField):void
		{
		}

		public static function get FLOOR_LAYER_HEIGHT():int
		{
			return SCREEN_HEIGHT - FLOOR_HEIGHT;
		}

		/**
		 * 普通苹果的奖励得分
		 * @default
		 */
		public static function get BOUNS_COMMON_APPLE():int
		{
			return Hook.getInt("bouns_common_apple");
		}

		/**
		 * 大苹果奖励得分
		 * @default
		 */
		public static function get BOUNS_BIG_APPLE():int
		{
			return Hook.getInt("bouns_big_apple");
		}

		/**
		 * 多次弹射的苹果奖励得分
		 * @default
		 */
		public static function get BOUNS_MULTI_APPLE():int
		{
			return Hook.getInt("bouns_multi_apple");
		}

		/**
		 * 玩家速度最大值
		 * @default
		 */
		public static function get PLAYER_MAX_SPEED():int
		{
			return Hook.getInt("player_max_speed");
		}

		/**
		 * 当无敌时的加速度
		 * @default
		 */
		public static function get ZOOL_ADD_VX():Number
		{
			return Hook.getNumber("player_zool_add_speed") * Global.widthRatio();
		}

		/**
		 * 玩家重力
		 * @default
		 */
		private static var temp1:Vector2D;

		public static function get PLAYER_G():Vector2D 
		{
			if (!temp1)
			{
				temp1 = new Vector2D(Hook.getNumber("player_gx") * Global.widthRatio(), Hook.getNumber("player_gy") * Global.heightRatio());
			}
			return temp1;
		}

		/**
		 * 玩家正常状态的弹力
		 * @default
		 */
		private static var temp2:Vector2D;

		public static function get PLAYER_NORMAL_BOUNCE():Vector2D
		{
			if (!temp2)
			{
				temp2 = new Vector2D(Hook.getInt("player_bounce_x") * Global.widthRatio(), Hook.getInt("player_bounce_y") * Global.heightRatio());
			}
			return temp2;
		}

		/**
		 * 玩家在鼠标按下时的弹力
		 * @default
		 */
		private static var temp3:Vector2D;

		public static function get PLAYER_MOUSE_DOWN_BOUNCE():Vector2D
		{
			if (!temp3)
			{
				temp3 = new Vector2D(Hook.getNumber("player_mousedown_bounce_x") * Global.widthRatio(), Hook.getNumber("player_mousedown_bounce_y") * Global.heightRatio());
			}
			return temp3;
		}

		// 玩家的状态
		/**
		 * 正常状态
		 */
		public static const STATE_PLAYER_NORMAL:String = "normal";

		/**
		 * 无敌状态
		 */
		public static const STATE_PLAYER_ZOOL:String = "zool";

		/**
		 * 落地翻转状态
		 */
		public static const STATE_PLAYER_ROLL:String = "roll";

		/**
		 * 第二次落地翻滚
		 * @default
		 */
		public static const STATE_PLAYER_ROLL2:String = "roll2";

		/**
		 * 吸苹果状态
		 * @default
		 */
		public static const STATE_PLAYER_MAGNET:String = "magnet";
	}
}
