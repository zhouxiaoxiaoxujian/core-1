package peng.game.horse.core
{
	import cactus.common.Global;
	import cactus.common.manager.SceneManager;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.cache.single.DisplayCachePool;
	import cactus.common.xx.goem.Vector2D;
	import cactus.common.xx.sprite.BallVehicle;
	
	import flash.display.MovieClip;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import peng.common.Config;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.HUtils;
	import peng.game.horse.manager.HStatManager;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.view.scene.GameOverScene;

	public class Player extends BallVehicle
	{
		// 玩家的检测半径
		private const R:int = 55;


		/**
		 * 上升阶段的最大旋转值
		 * @default
		 */
		private const UP_MAX_DEGREE:Number = -30;

		/**
		 * 下降阶段的最大旋转值
		 * @default
		 */
		private const DOWN_MAX_DEGREE:Number = 45;

		private var _body:MovieClip;

		private var _g:Vector2D = Config.PLAYER_G;



		public function Player()
		{
			super(R);
		}

		override public function init():void
		{
			maxSpeed = Config.PLAYER_MAX_SPEED;
		}

		override protected function draw():void
		{
			_body = HUtils.getBitmapMovieClip("Player");
			normal();
			addChild(_body);
		}

		/**
		 * 吃到苹果时的弹起
		 */
		public function littleBounce():void
		{
			// 若 player在下降，则时速度临时向上，起到“接”的作用
			if (this.velocity.y < 0)
			{
				velocity = velocity.add(new Vector2D(0, -1));
			}
			// 若 player在升起，则给与一定的加速度
			else
			{
				velocity = (new Vector2D(0, -2));
			}
		}

		/**
		 * 一次大弹起
		 * 如踩到牛等
		 */
		public function bigBounce():void
		{

		}

		/**
		 * 一次跌落
		 * 如撞倒敌人等
		 */
		public function collideWithEnemy():void
		{
			var v_x:Number = Global.mapToWidth(0);
			var v_y:Number = Global.mapToHeight(200);

			velocity = velocity.add(new Vector2D(v_x, v_y));
			rotation = DOWN_MAX_DEGREE;
		}

		override public function get body():MovieClip
		{
			return _body;
		}

		override public function update(delay:int):void
		{
			// 重力
			_velocity = _velocity.add(_g);

			super.update(delay);

			wrap();

			// 旋转
			// 向下行进
			if (velocity.y > 0)
			{
				incRotation();
			}
			// 向上行进
			else
			{
				decRotation();
			}
		}

		private function incRotation():void
		{
			rotation += 4;

			if (rotation > DOWN_MAX_DEGREE)
			{
				rotation = DOWN_MAX_DEGREE;
			}
		}

		private function decRotation():void
		{
			// 向上窜的感觉
			rotation += UP_MAX_DEGREE;

			if (rotation < UP_MAX_DEGREE)
			{
				rotation = UP_MAX_DEGREE;
			}
		}

		/**
		 * 具有层次的穿越
		 */
		override protected function wrap():void
		{
			// 如果在第一层，底部需要反弹
			if (position.y + radius > Config.FLOOR_LAYER_HEIGHT)
			{
				if (HStatManager.getIns().currLevel == 1)
				{
					bottomBounce();
				}
				else
				{
					bottomWrap();
				}
			}

			// 如果在最顶层，顶部需要反弹
			else if (position.y - radius < /*0*/ -3)
			{
				if (HStatManager.getIns().currLevel == HStatManager.getIns().maxLevel)
				{
//					topBounce();
					super.wrap();
				}
				else
				{
					topWrap();
				}
			}
		}

		/**
		 * 鼠标按下的一次弹起
		 */
		public function bounceByClick():void
		{
			
			if ( HStatManager.getIns().gameOverStack >= Config.gameOverCount)
			{
				return;
			}
			normal();
//			HStatManager.getIns().gameOverStackReset();
//			velocity = velocity.add(Config.PLAYER_NORMAL_BOUNCE);
			velocity = (Config.PLAYER_NORMAL_BOUNCE);
		}

		/**
		 * 鼠标按下时增加的弹力
		 */
		public function bounceByMouseDown():void
		{
			//	normal();
			velocity = velocity.add(Config.PLAYER_MOUSE_DOWN_BOUNCE);
		}

		/**
		 * 底层 反弹
		 */
		protected function bottomBounce():void
		{
			// 改变玩法啦
			var stack:int = ++HStatManager.getIns().gameOverStack;


			if (!Config.DEBUG_NO_GAME_OVER && HStatManager.getIns().gameOverStack == Config.gameOverCount && Config.bRunning == true)
			{
				// 如果game over了，就一直滚
				// 但是这段时间，Player应该停止Update
				roll2();
				pause = true;
				
				// 等待一段时间，再进入gameover场景
				var timeout:int = setTimeout( function():void
				{
					SceneManager.getInstance().changeScene(GameOverScene);
					Config.bRunning = false;
					clearTimeout(timeout);
				},1000);
				
				return;
			}

			SoundManager.getInstance().playSound(HSoundFlag.SBounce);

			position.y = Config.FLOOR_LAYER_HEIGHT - radius - 5;
			// 	velocity.y*=-1;

			// 三次的弹力不一样哦
			if (stack == 1)
			{
				if (HorseModel.getIns().hasBetterBounce)
					velocity = new Vector2D(0, Global.mapToHeight(-25));
				else
					velocity = new Vector2D(0, Global.mapToHeight(-20));
				roll(); 
			}
			else if (stack == 2)
			{
				if (HorseModel.getIns().hasBetterBounce)
					velocity = new Vector2D(0, Global.mapToHeight(-25));
				else
					velocity = new Vector2D(0, Global.mapToHeight(-15));
				roll2();
			}
			else
			{
				if (Config.DEBUG_NO_GAME_OVER)
				{
					velocity = new Vector2D(0, Global.mapToHeight(-18));
				}
				roll2();
			}
		}

		/**
		 * 顶层 反弹
		 */
		protected function topBounce():void
		{
			position.y = radius;
			//	velocity.y *= -1;
			velocity = new Vector2D(0, 1);
		}

		/**
		 * 顶层wrap ,向上一层楼
		 */
		protected function topWrap():void
		{
			position.y = Config.FLOOR_LAYER_HEIGHT - radius;
			HStatManager.getIns().currLevel++;
		}

		/**
		 * 底层 wrap，向下一层楼
		 */
		protected function bottomWrap():void
		{
			position.y = radius;
			HStatManager.getIns().currLevel--;
		}

		/**
		 * 无敌状态
		 */
		public function zool():void
		{
			body.gotoAndPlay(Config.STATE_PLAYER_ZOOL);
		}

		/**
		 * 正常状态
		 */
		public function normal():void
		{
			if (!HStatManager.getIns().zooling)
			{
				body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
			}
			else
			{
				body.gotoAndPlay(Config.STATE_PLAYER_ZOOL);
			}

		}

		/**
		 * 吸苹果状态
		 */
		public function magnet():void
		{
			// STATE_PLAYER_MAGNET
			body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
		}

		/**
		 * 撞地面的翻滚状态
		 */
		public function roll():void
		{
			body.gotoAndPlay(Config.STATE_PLAYER_ROLL);
		}

		/**
		 * 撞地面的翻滚状态2
		 */
		public function roll2():void
		{
			body.gotoAndPlay(Config.STATE_PLAYER_ROLL2);
		}


	}
}
