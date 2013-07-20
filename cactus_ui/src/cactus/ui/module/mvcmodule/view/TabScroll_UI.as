package cactus.ui.module.mvcmodule.view
{
	import flash.events.Event;

	import cactus.common.frame.resource.ResourceFacade;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PScrollPane;
	import cactus.ui.control.PSlider;

	/**
	 *
	 * @author Cactus
	 */
	public class TabScroll_UI extends PAutoView
	{
		// 滚动区域
		public var scp_panel_PB:PScrollPane=new PScrollPane;

		// 普通滚动条
		public var vslider_PB:PSlider=new PSlider();
		public var hslider_PB:PSlider=new PSlider();

		public function TabScroll_UI($sourceName:*=null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			vslider_PB.setDirection(PSlider.VERTICAL);
			hslider_PB.setDirection(PSlider.HORIZONTAL);  
			
			vslider_PB.addEventListener(Event.CHANGE, onVSliderChange);
			hslider_PB.addEventListener(Event.CHANGE, onHSliderChange);

			// panel中必须放入超过滚动区域(viewport)的东东就行
			scp_panel_PB.addContent(ResourceFacade.getMC("TestMC500"));
		}

		protected function onHSliderChange(event:Event):void
		{
			trace("hslider_PB.value", hslider_PB.value);
		}

		protected function onVSliderChange(event:Event):void
		{
			trace("vslider_PB.value", vslider_PB.value);
		}

		override public function destory():void
		{
			super.destory();
		}
	}
}

