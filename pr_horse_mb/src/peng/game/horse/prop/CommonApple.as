package peng.game.horse.prop
{
	import cactus.common.tools.Hook;
	import cactus.common.tools.cache.single.DisplayCachePool;
	
	import flash.geom.Point;
	
	import peng.common.Config;
	import peng.game.horse.HUtils;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.manager.HStatManager;

	/**
	 * 普通的苹果
	 * @author Peng
	 */
	public class CommonApple extends Apple
	{
		public function CommonApple()
		{
			super(Hook.getNumber("radius_common_apple"));
		}

		override protected function draw():void
		{
			_body = HUtils.getBitmapMovieClip("PropApple");
			_body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);

			addChild(_body);
		}

		override public function showOut():void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SHOW_APPLE_CORE, new Point(this.x, this.y)));

			dispatchEvent(new HorseEvent(HorseEvent.ADD_BOUNS, [new Point(this.x, this.y), Config.BOUNS_COMMON_APPLE]));

			super.showOut();
		}
	}
}
