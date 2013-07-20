package cactus.ui.module.mvcmodule.view
{
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PAccordion;
	import cactus.ui.module.mvcmodule.view.part.WindowTile;
	
	import flash.events.MouseEvent;

	public class TabAccordion_UI extends PAutoView
	{
//		public var win1_PB:WindowTile = new WindowTile();
//		public var win2_PB:WindowTile = new WindowTile();
		[Bind]
		public var acc_test:PAccordion = new PAccordion(); 

		public function TabAccordion_UI($sourceName:* = null)
		{
			super($sourceName);
		}

		override public function init():void
		{
//			win1_PB.minimized = true;
//			win2_PB.minimized = false;

//			win1_PB.addEventListener(MouseEvent.CLICK, onWin1Click);
//			win2_PB.addEventListener(MouseEvent.CLICK, onWin2Click);
			
			// 非绑定
			acc_test.addWindow( new WindowTile(ResourceFacade.getMC("WindowTile")));
			acc_test.addWindow( new WindowTile(ResourceFacade.getMC("WindowTile")));
			acc_test.addWindow( new WindowTile(ResourceFacade.getMC("WindowTile")));
		}

//		protected function onWin2Click(event:MouseEvent):void
//		{
//			win2_PB.minimized = !win2_PB.minimized;
//		}
//
//		protected function onWin1Click(event:MouseEvent):void
//		{
//			win2_PB.minimized = !win2_PB.minimized;
//		}
	}
}