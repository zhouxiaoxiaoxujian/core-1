package peng.game.horse.prop
{
	import flash.geom.Point;
	
	import peng.common.Config;
	import peng.game.horse.HUtils;
	import peng.game.horse.event.HorseEvent;

	/**
	 * 大苹果
	 * @author Peng
	 */
	public class BigApple extends Apple
	{
		public function BigApple()
		{
			super(40);
		}

		override protected function draw():void
		{
			_body = HUtils.getBitmapMovieClip("PropBigApple");
			_body.gotoAndPlay(Config.STATE_PLAYER_NORMAL);
			addChild(_body);
		}

		override public function showOut():void
		{
			dispatchEvent(new HorseEvent(HorseEvent.SHOW_APPLE_CORE, new Point(this.x, this.y)));
			
			dispatchEvent(new HorseEvent(HorseEvent.ADD_BOUNS, [new Point(this.x, this.y), Config.BOUNS_BIG_APPLE]));

			super.showOut();
		}
	}
}
