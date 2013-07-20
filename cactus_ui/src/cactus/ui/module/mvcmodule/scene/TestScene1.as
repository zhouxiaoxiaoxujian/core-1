package cactus.ui.module.mvcmodule.scene
{
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.ui.base.BaseScene;
	import cactus.ui.module.mvcmodule.view.TestView_UI;

	/**
	 * ShowCase场景
	 * @author Administrator
	 */
	public class TestScene1 extends BaseScene
	{
		public function TestScene1() 
		{
			super();  
		}

		override public function destory():void
		{
			super.destory();
			
		}

		override protected function onAllReady():void
		{
			super.onAllReady();
			buildUI();
		}

		private function buildUI():void
		{
			// 控件集合
			var ui:TestView_UI = new TestView_UI(ResourceFacade.getMC("TestView_UI"));
			addChild(ui);

			// 新绑定的界面，使用元数据
//			var ui2:Demo1_UI = new Demo1_UI("Demo1_UI");
//			addChild(ui2);

		}

	}
}