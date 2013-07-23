package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;

	public class Rank_POP extends BasePopupPanel
	{

		public var slt_rank_PB:PTileList = new PTileList(null,1,3,RankRender_UI,null);

		public function Rank_POP(src:* = null)
		{
			super("Rank_POP");
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
	}
}
