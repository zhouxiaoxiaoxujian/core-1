package peng.game.horse.prop
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import peng.common.Config;
	import cactus.common.Global;
	import cactus.common.behaviour2d.SpringBehaviour2d;
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.manager.ComboManager;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.cache.single.DisplayCachePool;
	import cactus.common.tools.util.MathUtil;
	import cactus.common.xx.goem.Vector2D;
	import cactus.common.xx.sprite.BallVehicle;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.core.Player;
	import peng.game.horse.enumerate.EnumCombo;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HAIManager;
	import peng.game.horse.manager.HStatManager;

	/**
	 * 苹果基类
	 * @author Peng
	 */
	public class Apple extends BaseProp implements IProp
	{
		/**
		 *
		 */
		protected var _body:MovieClip;

		/**
		 * 行为
		 */
		private var _behaviour:SpringBehaviour2d;

		/**
		 * Y轴的振动幅度
		 */
		private var _springRangeY:Number;

		public function Apple(pRadius:Number = 10)
		{
			super(pRadius);
		}

		override public function init():void
		{
			_behaviour = new SpringBehaviour2d(this);
			_behaviour.maxSpeed = 100;

			_springRangeY = MathUtil.random(Global.mapToHeight(20), Global.mapToHeight(80));
		}

		override public function destory():void
		{
			_body.stop();
			super.destory();
		}

		override public function get body():MovieClip
		{
			return _body;
		}

		override public function update(delay:int):void
		{
			if (!HStatManager.getIns().doingMagnet)
			{
				_behaviour.targetX = x;
				_behaviour.targetY = _initPosition.y - _springRangeY;
				_behaviour.springV();
			}
			else
			{
				// 具有吸铁石，向player方向seek动作
				_behaviour.seek(new Vector2D(HAIManager.getIns().player.x, HAIManager.getIns().player.y));
			}
			_behaviour.update(delay);

			super.update(delay);
		}

		/**
		 * 和player发生碰撞
		 * @param player
		 */
		override public function collide($player:IVehicle):void
		{
			var eatAppleCombo:int = ComboManager.getIns().activeCombo(EnumCombo.EAT_APPLE);
			
//			HStatManager.getIns().gameOverStackReset();
			SoundManager.getInstance().playSound(HSoundFlag.SEatApple);

			var player:Player = $player as Player;
			player.littleBounce();
			player.normal();

			addApples();
			showOut();
		}

		// 默认新增一个苹果，有可能不同的苹果种类新增不同个数的苹果
		protected function addApples():void
		{
			HStatManager.getIns().currChance++;
		}
	}
}
