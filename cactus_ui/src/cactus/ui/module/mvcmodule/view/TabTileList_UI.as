package cactus.ui.module.mvcmodule.view
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	import cactus.common.control.LanguageSelectBox;
	import cactus.common.tools.Local;
	import cactus.common.tools.util.ArrayUtils;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.CTextField;
	import cactus.ui.control.PButton;
	import cactus.ui.control.PLanguageSelectBox;
	import cactus.ui.control.PTextField;
	import cactus.ui.control.PTileList;
	import cactus.ui.control.PTweenTileList;
	import cactus.ui.control.classical.PRectangle;

	public class TabTileList_UI extends PAutoView
	{
		[Bind]
		public var slt_list : PTileList = new PTileList(null, 5, 1, PRectangle, [50, 50], 10, 10, 5, 20);

		[Bind]
//		public var tlt_list:PTweenTileList = new PTweenTileList(null, 5, 1, PRectangle, [100, 150], 10, 10, 10, 10);
		public var tlt_list : PTweenTileList = new PTweenTileList();

		[Bind]
		public var slt_leftToRight : PTileList = new PTileList();

		[Bind]
		public var slt_rightToLeft : PTileList = new PTileList();

		[Bind]
		public var txt_i18n1 : PTextField = new PTextField;

		[Bind]
		public var txt_i18n2 : TextField = new CTextField;

		[Bind]
		public var txt_i18n3 : TextField;

		[Bind]
		public var langBox1 : PLanguageSelectBox = new PLanguageSelectBox();

		[Bind]
		public var langBox2 : PLanguageSelectBox = new PLanguageSelectBox();

		[Bind]
		public var btn_test1 : PButton;

		[Bind]
		public var btn_test2 : PButton;

		public function TabTileList_UI($sourceName : * = null)
		{
			super($sourceName);
		}

		override public function init() : void
		{

			// new feather
			slt_leftToRight.setStandard(5, 1, 10, 10, 5, 20);
			slt_leftToRight.setRenderer(PRectangle, [50, 50]);

			slt_rightToLeft.setStandard(5, 1, 10, 10, 5, 20, false);
			slt_rightToLeft.setRenderer(PRectangle, [50, 50]);

			tlt_list.setStandard(4, 1, 10, 10, 10, 10);
			tlt_list.setRenderer(PRectangle, [100, 150]);

			// 给TileList赋值
			var dataProvider : Array = [];
			for (var i : int = 0; i < 5; i++)
			{
				dataProvider.push(i);
//				dataProvider.push({"id": i, "iid": i * 100});
			}
			slt_list.paddingLastPage = true;
			slt_list.data = dataProvider;
			tlt_list.data = dataProvider;

			slt_leftToRight.data = dataProvider;
			slt_rightToLeft.data = dataProvider;

			txt_i18n1.text = "{shop_item1_normal}";
			txt_i18n2.text = "{shop_item2_normal}";
			txt_i18n3.text = Local.getString("shop_item2_normal");

			langBox1.dir = LanguageSelectBox.DIR_DOWN;
			langBox2.dir = LanguageSelectBox.DIR_UP;

//			trace("slt_list_PB.getRenderer(0)", slt_list_PB.getRenderer(0).x, slt_list_PB.getRenderer(0).y);
//			trace("slt_list_PB.getRenderer(3)", slt_list_PB.getRenderer(3).x, slt_list_PB.getRenderer(3).y);
//			trace("slt_list_PB.getRenderer(32)", slt_list_PB.getRenderer(32).x, slt_list_PB.getRenderer(32).y);

			btn_test1.addEventListener(MouseEvent.CLICK, onBtnTest1Click);
			btn_test1.addEventListener(MouseEvent.MOUSE_OVER, onTestMouseOver);
			btn_test1.addEventListener(MouseEvent.ROLL_OUT, onTestMouseOut);

			btn_test2.addEventListener(MouseEvent.CLICK, onBtnTest2Click);



		}



		override public function destory() : void
		{
			super.destory();
		}

		// ==============================================================
		//						protected 
		// ==============================================================

		protected function onBtnTest1Click(event : MouseEvent) : void
		{
			trace("onBtnTest1Click");

			trace(ArrayUtils.exportField(slt_list.getCurrPageModel(), "iid"));
		}

		protected function onBtnTest2Click(event : MouseEvent) : void
		{
			btn_test1.enabled = !btn_test1.enabled;
		}

		private function onTestMouseOut(event : MouseEvent) : void
		{
			trace("mouse can out");
		}

		private function onTestMouseOver(event : MouseEvent) : void
		{
			trace("mouse can over");
		}

	}
}
