package lib
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import cactus.ui.base.BasePopupPanel;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Movie_POP extends BasePopupPanel
	{

		[Bind]
		public var btn_play:PButton;
		[Bind]
		public var btn_close:PButton;
		[Bind]
		public var mmc_movie:MovieClip;

		public function Movie_POP(src:*=null)
		{
			super(src)
		}

		override public function getBindObj():Array
		{
			return [{"propertyName": "btn_play"}, {"propertyName": "btn_close"}, {"propertyName": "mmc_movie"}];
		}

		override public function init():void
		{
			super.init();
			btn_play.addEventListener(MouseEvent.CLICK, btn_playClick);
			btn_close.addEventListener(MouseEvent.CLICK, btn_closeClick);
		}

		override public function destory():void
		{
			super.destory();
			btn_play.removeEventListener(MouseEvent.CLICK, btn_playClick);
			btn_close.removeEventListener(MouseEvent.CLICK, btn_closeClick);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		protected function btn_playClick(evt:MouseEvent):void
		{
		}

		protected function btn_closeClick(evt:MouseEvent):void
		{
		}
	}
}
