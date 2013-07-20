package lib
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import cactus.ui.base.BasePopupPanel;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Demo7_UI extends PAutoView
	{

		[Bind]
		public var mmc_ok2:MovieClip;

		[Bind]
		public var btn_ok:PButton;

		public function Demo7_UI(src:*=null)
		{
			super(src)
		}

		// 需要使用反射属性的，这里还需要改进
		override public function getBindObj():Array
		{
			return [{"propertyName": "mmc_ok2", "align": "right"}, {"propertyName": "btn_ok", "align": "right", "ref": "b"}];
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
