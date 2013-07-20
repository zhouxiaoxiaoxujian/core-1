package cactus.ui.module.mvcmodule.view
{
	import cactus.common.Global;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.PComboBox;
	import cactus.ui.control.PList;
	import cactus.ui.control.classical.PRectangle;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.getDefinitionByName;

	public class TabList_UI extends PAutoView
	{
		[Bind]
		public var lst:PList=new PList();
		[Bind]
		public var lst2:PList=new PList();  
		[Bind]
//		public var cbb:PComboBox=new PComboBox(null, PRectangle, [100, 30], 40, 5);
		public var cbb:PComboBox=new PComboBox(); 

		public function TabList_UI($sourceName:*=null)
		{
			super($sourceName);  
		}
 
		private var i:int;
		override public function init():void
		{
			cbb.setStandard(40, 5);
			cbb.setRenderer(PRectangle, [100, 30]); 
			
			lst.setStandard(30, 5, null, 5);  
			lst.setRenderer(PRectangle, [100, 30, 0x0000ff]);

			lst2.setStandard(30, 5, Class(getDefinitionByName("TestVScrollBar")));
			lst2.setRenderer(PRectangle, [100, 30, 0x0000ff]);

			var listData:Array=[];
			for (i=0; i < 20; i++)
			{
				listData.push(i);  
			}
			var listData2:Array = [];
			for (i=0; i < 40; i++)
			{
				listData2.push(i);  
			}
			
			lst.data=listData;
			lst.autoHideScrollBar=true;

			lst2.data=listData2;
			lst2.autoHideScrollBar=true;

			var cpListData:Array=[];
			for (i=0; i < 10; i++)
			{
				cpListData.push({"label": "吼" + i.toString(), "value": i});
			}

			// ComboBox
			cbb.data=cpListData;
			cbb.addEventListener(Event.SELECT, onCbbSelect);
			cbb.selectedIndex=5;

//			Global.stage.addEventListener(MouseEvent.MOUSE_DOWN, onKeyDown);
		}

		private function onKeyDown(event:MouseEvent):void
		{
			if (i < 30)
			{
				lst.addItem(++i);
				lst.selectedIndex=lst.items.length - 1;

				trace("data", lst.data);
			}

		}

		protected function onCbbSelect(event:Event):void
		{
//			Debugger.info("comboBox选中", cbb_PB.selectedItem.toString());
		}

		override public function destory():void
		{
			super.destory();
		}
	}
}
