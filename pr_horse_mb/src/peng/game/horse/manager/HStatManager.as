package peng.game.horse.manager
{
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import cactus.common.tools.Hook;
	import cactus.common.tools.util.NumberFormat;
	import peng.game.horse.core.Player;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.view.scene.GamePlayScene;
	import peng.game.horse.view.ui.GamePlayView_UI;

	/**
	 * 统计
	 * @author Peng
	 */
	public class HStatManager
	{
		/**
		 * 允许的最大层次数
		 * @default
		 */
		public const maxLevel:int = 5;

		/**
		 * 允许的最大弹射次数
		 */
		private const _maxChange:int = 20;

		/**
		 * 当前层次
		 * @default
		 */
		private var _currLevel:int = -1;

		/**
		 * 当前飞行距离
		 */
		private var _currDistance:int = 0;

		/**
		 * 当前剩余弹射次数
		 */
		private var _currChance:int;

		/**
		 * 飞行时间
		 */
		private var _currTime:int;

		/**
		 * 奖励得分
		 */
		private var _currBonus:int;

		/**
		 * 当前击毁的敌人数
		 * @default
		 */
		private var _currDestory:int

		/**
		 * 触底计数器，当达到指定的触底值后，触发GamOver
		 */
		private var _gameOverStack:int;

		/**
		 * 是否处于无敌状态
		 */
		private var _zooling:Boolean;

		/**
		 * 是否处于吸苹果状态
		 * @default
		 */
		private var _doingMagnet:Boolean;

		/**
		 * 游戏主场景
		 */
		private var _gameScene:GamePlayScene;

		/**
		 * 玩家
		 */
		private var _player:Player;

		/**
		 * 主页面UI
		 */
		private var _ui:GamePlayView_UI;

		/**
		 * 游戏碰撞世界
		 */
		private var _world:Sprite;

		/**
		 * 计数
		 * @default
		 */
		private var _tick:int = 0;

		private static var _instance:HStatManager = new HStatManager;

		public function HStatManager()
		{
		}


		public function get doingMagnet():Boolean
		{
			return _doingMagnet;
		}

		public function set doingMagnet(value:Boolean):void
		{
			_doingMagnet = value;

			// 一段时间后，将玩家设置为正常状态
			if (_doingMagnet == true)
			{
				setTimeout(function():void
				{
					_player.normal();
					_doingMagnet = false;
				}, Hook.getNumber("magnetContinuedTime"));
			}
		}

		/**
		 * 当前击毁敌人数
		 */
		public function get currDestory():int
		{
			return _currDestory;
		}

		/**
		 * @private
		 */
		public function set currDestory(value:int):void
		{
			_currDestory = value;
		}

		public function get gameOverStack():int
		{
			return _gameOverStack;
		}

		public function set gameOverStack(value:int):void
		{
			if ( value - _gameOverStack > 0)
			{
				_ui.lifebar_PB.reduceLife();
			}
			
			_gameOverStack = value;
		}

		/**
		 * 重新计数gameover次数
		 *
		 */
		public function gameOverStackReset():void
		{
			gameOverStack = 0;
		}

		public function get zooling():Boolean
		{
			return _zooling;
		}

		public function set zooling(value:Boolean):void
		{
			if (_zooling != value)
			{
				_zooling = value;

				if (value == true)
				{
					_player.zool();
					
					var timeout:uint = setTimeout( function():void
					{
						zooling = false;
						clearTimeout(timeout);
					},6000);
				}
				else
				{
					_player.normal();
				}
			}

		}

		public static function getIns():HStatManager
		{
			return _instance;
		}

		public function get currBonus():int
		{
			return _currBonus;
		}

		public function set currBonus(value:int):void
		{
			_currBonus = value;

			fireScoreChange();
		}

		public function destory():void
		{

		}

		public function init($gameScene:GamePlayScene):void
		{
			_gameScene = $gameScene;
			_player = _gameScene.player;
			_ui = _gameScene.uiLayer;
			_world = _gameScene.worldLayer;

			// 初始化数据
			currLevel = 3;
			currChance = 10;
			currTime = 0;
			currDestory = 0;
			currBonus = 0;
			currDistance = 0;
			gameOverStackReset();

			if (HorseModel.getIns().hasMoreApples)
			{
				currChance += 5;
			}
		}


		/**
		 * 更新
		 * @param delay
		 */
		public function update(delay:int):void
		{
			currTime += delay;
			_tick++;
			currDistance++;

			// 界面矢量图更新的不能太频繁哦
			// 普通状态
//			if (!zooling)
//			{
//				_ui.pgb_zool_PB.value += 0.1;
//			}
//			// 无敌状态
//			else
//			{
//				_ui.pgb_zool_PB.value -= 0.3;
//
//				if (_ui.pgb_zool_PB.value < 1)
//				{
//					zooling = false;
//				}
//			}
			_tick = 0;
		}

		public function get currTime():int
		{
			return _currTime;
		}

		public function set currTime(value:int):void
		{
			_currTime = value;
		}

		public function get currChance():int
		{
			return _currChance;
		}

		public function set currChance(value:int):void
		{
			_currChance = value;

			if (_currChance > _maxChange)
				_currChance = _maxChange;

			if (_currChance < 0)
				_currChance = 0;

			fireCurrChanceChange();
		}

		public function get currDistance():int
		{
			return _currDistance;
		}

		public function set currDistance(value:int):void
		{
			_currDistance = value;

			fireCurrDistanceChange();
		}

		/**
		 * 当前层
		 * @default
		 */
		public function get currLevel():int
		{
			return _currLevel;
		}

		/**
		 * @private
		 */
		public function set currLevel(value:int):void
		{
			if (value != _currLevel)
			{
				_currLevel = value;
				fireLevelChange();
			}
		}

		/**
		 * 当楼层改变
		 */
		protected function fireLevelChange():void
		{
			// 改变显示楼层的数字
			_ui.txt_level_PB.text = _currLevel.toString();

			// 改变楼层
			PBackgroundManager.getInstance().changeBackgroundByIndex(_currLevel - 1);
		}

		/**
		 * 飞行距离改变
		 */
		private function fireCurrDistanceChange():void
		{
			fireScoreChange();
		}

		/**
		 * 弹射机会数改变
		 */
		private function fireCurrChanceChange():void
		{
			_ui.txt_chance_PB.text = _currChance.toString();
		}

		/**
		 * 分数改变
		 */
		private function fireScoreChange():void
		{
			var format:NumberFormat = new NumberFormat();

			_ui.txt_score_PB.text = format.format(caculateScore());
		}

		/**
		 * 奖励得分+飞行距离 + 飞行时间 秒*100 + 击落敌人数 * 1000  （待定）
		 * @return
		 */
		public function caculateScore():int
		{
//			trace("_currBonus", _currBonus);
//			trace("_currDistance", _currDistance);
//			trace("(_currTime / 10)", (_currTime / 10));
//			return _currBonus + _currDistance + (_currTime / 100);
//			return _currBonus + _currDistance;
			return _currBonus;
		}
	}
}
