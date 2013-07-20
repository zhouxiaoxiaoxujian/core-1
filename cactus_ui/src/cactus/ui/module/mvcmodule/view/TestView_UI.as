package cactus.ui.module.mvcmodule.view
{
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PButtonGroup;
	import cactus.ui.control.PTweenButton;
	import cactus.ui.events.ViewEvent;

	import flash.events.MouseEvent;


	/**
	 * ShowCase的界面
	 * 本界面分为多个tab页
	 * @author Cactus
	 */
	public class TestView_UI extends PAutoView
	{
		// tab标签按钮
		[Bind]
		public var ttn_type1:PTweenButton;
		[Bind]
		public var ttn_type2:PTweenButton;
		[Bind]
		public var ttn_type3:PTweenButton;
		[Bind]
		public var ttn_type4:PTweenButton;
		[Bind]
		public var ttn_type5:PTweenButton;

		// tab页
		[Bind]
		public var tabTileList:TabTileList_UI = new TabTileList_UI;
		[Bind]
		public var tabScroll:TabScroll_UI = new TabScroll_UI;
		[Bind]
		public var tabList:TabList_UI = new TabList_UI; 
		[Bind]
		public var tabSmallControl:TabSmallControl_UI = new TabSmallControl_UI;
		[Bind]
		public var tabAccordion:TabAccordion_UI = new TabAccordion_UI;

		// 按钮组
		private var group:PButtonGroup = new PButtonGroup;

		public function TestView_UI($sourceName:* = null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			super.init();

			ttn_type1.data = 1;
			ttn_type2.data = 2;
			ttn_type3.data = 3;
			ttn_type4.data = 4;
			ttn_type5.data = 5;

			ttn_type1.setText("Tile");
			ttn_type2.setText("Scroll");
			ttn_type3.setText("List");
			ttn_type4.setText("Control");
			ttn_type5.setText("Accordion");

			group.addChild(ttn_type1);
			group.addChild(ttn_type2);
			group.addChild(ttn_type3);
			group.addChild(ttn_type4);
			group.addChild(ttn_type5);
			group.addEventListener(ViewEvent.GROUP_ITEM_CHANGE, onItemChange);

			// 默认
			ttn_type1.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}

		override public function destory():void
		{
			super.destory();
		}

		// ==============================================================
		//						protected 
		// ==============================================================

		/**
		 * 改变标签页
		 * @param event
		 */
		protected function onItemChange(event:ViewEvent):void
		{
			var tabId:int = int(group.selectItem.data);

			// 先隐藏所有的tab
			tabTileList.visible = false;
			tabScroll.visible = false;
			tabList.visible = false;
			tabSmallControl.visible = false;
			tabAccordion.visible = false;

			switch (tabId)
			{
				case 1:
				{
					tabTileList.visible = true;
					break;
				}
				case 2:
				{
					tabScroll.visible = true;
					break;
				}
				case 3:
				{
					tabList.visible = true;
					break;
				}
				case 4:
				{
					tabSmallControl.visible = true;
					break;
				}
				case 5:
				{
					tabAccordion.visible = true;
					break;
				}
				default:
				{
					break;
				}
			}
		}

	}
}
