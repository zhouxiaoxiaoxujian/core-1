package cactus.ui.demo.cases
{
	import cactus.ui.control.*;

	import flash.events.Event;

	import lib.Demo5_UI;

	public class Demo5View extends Demo5_UI
	{

		public function Demo5View(src:*=null)
		{
			super("Demo5_UI")
		}

		override public function init():void
		{
			// must call super
			super.init();

			nsp_example1
			nsp_example1.minimum=0;
			nsp_example1.maximum=100;
			nsp_example1.addEventListener(Event.CHANGE, onStepperChange);


			nsp_example2.minimum=50;
			nsp_example2.maximum=60;
			nsp_example2.addEventListener(Event.CHANGE, onStepperChange);
		}

		override public function destory():void
		{
			// must call super
			super.destory();
		}

		override public function fireDataChange():void
		{
		}

		protected function onStepperChange(event:Event):void
		{
			trace("nsp_example1_PB.value", nsp_example1.value);
			trace("nsp_example2_PB.value", nsp_example2.value);
		}
	}
}
