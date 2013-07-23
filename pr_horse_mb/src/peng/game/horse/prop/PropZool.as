package peng.game.horse.prop
{
	import cactus.common.Global;
	import cactus.common.behaviour2d.SpringBehaviour2d;
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.Hook;
	import cactus.common.tools.cache.single.DisplayCachePool;
	import cactus.common.tools.util.MathUtil;
	
	import flash.display.MovieClip;
	
	import peng.common.Config;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.HUtils;
	import peng.game.horse.core.Player;
	import peng.game.horse.manager.HStatManager;

	/**
	 * 无敌道具
	 * @author Peng
	 */
	public class PropZool extends BaseProp
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

		public function PropZool()
		{
			super(Hook.getNumber("radius_zool_prop"));
		}

		override public function init():void
		{
			_behaviour = new SpringBehaviour2d(this);

			_springRangeY = MathUtil.random(Global.mapToWidth(15), Global.mapToHeight(50));
		}

		override public function destory():void
		{
			_body.stop();
			super.destory();
		}

		override protected function draw():void
		{
			_body = HUtils.getBitmapMovieClip("PropZool");
			_body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
			addChild(_body);
		}

		override public function get body():MovieClip
		{
			return _body;
		}

		override public function update(delay:int):void
		{
			_behaviour.targetX = x;
			_behaviour.targetY = _initPosition.y - _springRangeY;
			_behaviour.springV();
			_behaviour.update(delay);

			super.update(delay);
		}

		/**
		 * 和player发生碰撞
		 * @param player
		 */
		override public function collide($player:IVehicle):void
		{
//			HStatManager.getIns().gameOverStackReset();
			SoundManager.getInstance().playSound(HSoundFlag.SEatZool);

			var player:Player = $player as Player;
			player.normal();

			HStatManager.getIns().zooling = true;
			showOut();
		}
	}
}