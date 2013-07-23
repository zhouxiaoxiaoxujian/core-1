package peng.game.horse.prop
{
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.tools.Hook;
	
	import flash.geom.Point;
	
	import peng.common.Config;
	import peng.game.horse.HUtils;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HStatManager;

	/**
	 * 普通敌人
	 * 碰撞一次掉一个苹果哦
	 * @author Peng
	 */
	public class CommonEnemy extends Enemy
	{
		public function CommonEnemy()
		{
			super(Hook.getNumber("radius_common_enemy"));
		}

		override public function getEnemyType():int
		{
			return TYPE_COMMON;
		}
		
		override protected function draw():void
		{
			_body = HUtils.getBitmapMovieClip("CommonEnemy");
			_body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
			addChild(_body);
		}

		/**
		 * 和player发生碰撞
		 * @param player
		 */
		override public function collide($player:IVehicle):void
		{
			// 掉一个苹果
			HStatManager.getIns().currChance--;

			super.collide($player);
		}

		override public function showOut():void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SHOW_SUB_APPLE, [new Point(this.x, this.y), 1]));

			super.showOut();
		}
	}
}
