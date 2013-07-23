package peng.game.horse.prop
{
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.tools.Hook;
	import cactus.common.tools.cache.single.DisplayCachePool;
	
	import flash.geom.Point;
	
	import peng.common.Config;
	import peng.game.horse.HUtils;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HStatManager;

	/**
	 * 中等敌人
	 * 碰撞一次掉2个苹果哦
	 * @author Peng
	 */
	public class MiddleEnemy extends Enemy
	{
		public function MiddleEnemy()
		{
			super(Hook.getNumber("radius_middle_enemy"));
		}

		override public function getEnemyType():int
		{
			return TYPE_MIDDLE;
		}
		
		override protected function draw():void
		{
			_body = HUtils.getBitmapMovieClip("MiddleEnemy");
			_body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
			addChild(_body);
		}

		/**
		 * 和player发生碰撞
		 * @param player
		 */
		override public function collide($player:IVehicle):void
		{
			// 掉2个苹果
			HStatManager.getIns().currChance -= 2;

			super.collide($player);
		}

		override public function showOut():void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SHOW_SUB_APPLE, [new Point(this.x, this.y), 2]));
			super.showOut();
		}
	}
}
