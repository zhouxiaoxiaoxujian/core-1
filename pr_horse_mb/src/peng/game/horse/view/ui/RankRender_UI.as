package peng.game.horse.view.ui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class RankRender_UI extends PAutoView
	{

		public var txt_score_PB:TextField;

		public function RankRender_UI(src:* = null)
		{
			super("RankRender_UI");
		}

		override public function init():void
		{
			super.init();
		}

		override public function destory():void
		{
			super.destory();
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		override public function get width():Number
		{
			return 340;
		}

		override public function get height():Number
		{
			return 100;
		}
	}
}
