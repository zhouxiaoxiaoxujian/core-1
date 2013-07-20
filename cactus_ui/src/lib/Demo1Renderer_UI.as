package lib
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import cactus.ui.base.BasePopupPanel;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Demo1Renderer_UI extends PAutoView
	{

		[Bind]
		public var mmc_movie:MovieClip;
		[Bind]
		public var txt_title:TextField;
		[Bind]
		public var btn_ok:PButton;

		public function Demo1Renderer_UI(src:*=null)
		{
			super(src)
		}

		override public function getBindObj():Array
		{
			return [{"propertyName": "mmc_movie"}, {"propertyName": "txt_title"}, {"propertyName": "btn_ok"}];
		}

		override public function init():void
		{
			super.init();
			btn_ok.addEventListener(MouseEvent.CLICK, btn_okClick);
		}

		override public function destory():void
		{
			super.destory();
			btn_ok.removeEventListener(MouseEvent.CLICK, btn_okClick);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		protected function btn_okClick(evt:MouseEvent):void
		{
		}
	}
}
