package cactus.ui.module.mvcmodule.view
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PButton;
	import cactus.ui.control.PButtonGroup;
	import cactus.ui.control.PCheckBox;
	import cactus.ui.control.PNumericStepper;
	import cactus.ui.control.PProgressBar;
	import cactus.ui.control.PToggleButton;
	import cactus.ui.events.ViewEvent;

	/**
	 *
	 * @author Cactus
	 */
	public class TabSmallControl_UI extends PAutoView
	{
		// 步进器
		public var nsp_example1_PB:PNumericStepper = new PNumericStepper;

		// 复选框
		public var chb_box1_PB:PCheckBox = new PCheckBox;
		public var chb_box2_PB:PCheckBox = new PCheckBox;

		// 进度条
//		public var pgb_h_PB:PProgressBar = new PProgressBar(null, PProgressBar.DIR_HORIZONTAL, 100, 30);
		public var pgb_h_PB:PProgressBar = new PProgressBar();

		// 一个普通的按钮
		public var btn_common_PB:PButton;
		// 一个实例化的普通按钮
		public var btn_common2_PB:PButton = new PButton;
		// 一个开关按钮
		public var btn_toggle1_PB:PToggleButton = new PToggleButton;
		
		private var _group:PButtonGroup = new PButtonGroup;
		
		

		public function TabSmallControl_UI($sourceName:* = null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			btn_common2_PB.autoDestory = false;
			btn_common2_PB.autoDestory = false;
			btn_common2_PB.autoDestory = false;
			btn_common2_PB.autoDestory = false;
			btn_common2_PB.lazyTime = 5000;
			
			
			pgb_h_PB.setStandard(PProgressBar.DIR_HORIZONTAL, 100, 30);
			
			nsp_example1_PB.minimum = 2;
			nsp_example1_PB.step = 10;
			nsp_example1_PB.maximum = 100;
			nsp_example1_PB.addEventListener(Event.CHANGE, onStepperChange);

			chb_box1_PB.setLabel("cb1");
			chb_box2_PB.setLabel("cb2");

			_group.addChild(chb_box1_PB);
			_group.addChild(chb_box2_PB);
			_group.addEventListener("GROUP_ITEM_CHANGE", onGroupChange);
			
			btn_common_PB.addEventListener(MouseEvent.CLICK,onBtnCommonClick);
			btn_common2_PB.addEventListener(MouseEvent.CLICK,onBtnCommonClick2);
			btn_toggle1_PB.addEventListener(MouseEvent.CLICK,onBtnToggleClick);

			addEventListener(Event.ENTER_FRAME,onEnter);
		}
		
		protected function onBtnToggleClick(event:MouseEvent):void
		{
			if (btn_toggle1_PB.open)
			{
				trace("open false");
				btn_toggle1_PB.open = false;
			}
			else
			{
				trace("open true");
				btn_toggle1_PB.open = true;
			}
		}
		
		
		
		protected function onBtnCommonClick(event:MouseEvent):void
		{
			trace("btn common click");			
		}
		
		protected function onBtnCommonClick2(event:MouseEvent):void
		{
			trace("new * btn common");			
		}
		
		protected function onEnter(event:Event):void
		{
			pgb_h_PB.value+=0.1;
		}
		
		protected function onGroupChange(event:ViewEvent):void
		{
			trace("onGroupChange", _group.selectItem);
		}

		override public function destory():void
		{
			super.destory();
		}

		protected function onStepperChange(event:Event):void
		{
			trace(nsp_example1_PB.value);
		}
	}
}
