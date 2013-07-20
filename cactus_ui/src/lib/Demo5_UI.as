package lib
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import cactus.ui.base.BasePopupPanel;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Demo5_UI extends PAutoView
	{

		[Bind]
		public var nsp_example2:PNumericStepper=new PNumericStepper;
		[Bind]
		public var nsp_example1:PNumericStepper=new PNumericStepper;

		public function Demo5_UI(src:*=null)
		{
			super(src)
		}

		override public function getBindObj():Array
		{
			return [{"propertyName": "nsp_example2"}, {"propertyName": "nsp_example1"}];
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
