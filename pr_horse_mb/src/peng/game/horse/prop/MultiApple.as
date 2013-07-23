package peng.game.horse.prop
{
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.tools.Hook;
	import cactus.common.tools.cache.single.DisplayCachePool;
	
	import flash.geom.Point;
	
	import peng.common.Config;
	import peng.game.horse.HUtils;
	import peng.game.horse.core.Player;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HStatManager;

	/**
	 * 多次弹射机会的苹果
	 * @author Peng
	 */
	public class MultiApple extends Apple
	{
		public function MultiApple()
		{
			super(Hook.getNumber("radius_multi_apple"));
		}

		override protected function draw():void
		{
			_body =HUtils.getBitmapMovieClip("PropMultiApple");
			_body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
			addChild(_body);
		}

		override public function showOut():void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SHOW_APPLE_CORE, new Point(this.x, this.y)));

			dispatchEvent(new HorseEvent(HorseEvent.ADD_BOUNS, [new Point(this.x, this.y), Config.BOUNS_MULTI_APPLE]));

			super.showOut();
		}

		/**
		 * 和player发生碰撞
		 * @param player
		 */
//		override public function collide($player:IVehicle):void
//		{
//			var player:Player = $player as Player;
//			player.littleBounce();
//			player.normal();
//
//			HStatManager.getIns().currChance += 2;
//			showOut();
//			
//			//
//			
//		}
		
		override protected function addApples():void
		{
			HStatManager.getIns().currChance+=2;
		}
	}
}
