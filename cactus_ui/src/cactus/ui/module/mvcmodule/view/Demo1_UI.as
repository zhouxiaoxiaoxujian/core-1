package cactus.ui.module.mvcmodule.view
{
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PButton;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Demo1_UI extends PAutoView
	{
		[Bind(align="left", ref="ltrba",scale="true")]
		public var mmc_icon:MovieClip;
		[Bind]
		public var txt_name:TextField;
		[Bind]
		public var btn_b2:PButton;
		[Bind]
		public var btn_b1:PButton;

		public function Demo1_UI(src:* = null)
		{
			super(src)
		}

		override public function init():void
		{
			super.init();
			btn_b2.addEventListener(MouseEvent.CLICK, btn_b2Click);
			btn_b1.addEventListener(MouseEvent.CLICK, btn_b1Click);
			mmc_icon.addEventListener(MouseEvent.CLICK, mmcClick);
			txt_name.text = "aaa";
		}

		protected function mmcClick(event:MouseEvent):void
		{
			trace("mmcClick");
		}

		override public function destory():void
		{
			super.destory();
			btn_b2.removeEventListener(MouseEvent.CLICK, btn_b2Click);
			btn_b1.removeEventListener(MouseEvent.CLICK, btn_b1Click);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		private function btn_b2Click(evt:MouseEvent):void
		{
			trace("btn_b2Click");
		}

		private function btn_b1Click(evt:MouseEvent):void
		{
			trace("btn_b1Click");
		}
	}
}
