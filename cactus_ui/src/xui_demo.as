package
{
	import cactus.common.Global;
	import cactus.common.frame.DefaultResourceHelper;
	import cactus.ui.PUIConfig;
	import cactus.ui.demo.EngineMulti;
	import cactus.ui.demo.cases.Demo2RenderersView;
	import cactus.ui.demo.cases.Demo3TileListView;
	import cactus.ui.demo.cases.Demo5View;
	import cactus.ui.demo.cases.Demo6View;
	import cactus.ui.demo.cases.Demo7View;

	import flash.system.Security;
	import flash.utils.getDefinitionByName;

	import lib.Demo2Renderers_UI;

	[SWF(width=800, height=480, backgroundColor="#ffffff")]
	public class xui_demo extends EngineMulti
	{
		public function xui_demo()
		{
			Security.allowDomain("*");
			super(gameStart);
		}

		private function gameStart():void
		{
			// 初始化UI框架
			PUIConfig.registeStage(this.stage);
			PUIConfig.initResourceHelper(new DefaultResourceHelper);

			// Demo1 一个渲染器
			// 最基本的绑定，TextField，MovieClip和PButton
//			var demo1:Demo1View = new Demo1View();
//			addChild(demo1);

			// Demo2 嵌套结构
			// 基本的嵌套结构
//			var demo2:Demo2RenderersView = new Demo2RenderersView();
//			addChild(demo2);

			// Demo3 TileList控件
			// 使用控件完成Demo2的显示，并丰富title属性
//			var demo3:Demo3TileListView=new Demo3TileListView();
//			addChild(demo3);

			// Demo5
			// 同一个控件，变化为不同的样式
//			var demo5:Demo5View=new Demo5View();
//			addChild(demo5);

			// Demo6
			// 动态加载
			// 证明这个东东是没有加载到当前域的
//			try
//			{
//				trace("getDefinitionByName", getDefinitionByName("Demo6_UI"));
//			}
//			catch (error:Error)
//			{
//				trace(error);
//			}
//			// 保留对素材，数据加载的接口
//			var demo6:Demo6View=new Demo6View();
//			addChild(demo6);

			// Demo7
			// 向手机靠拢，不同屏幕大小的自动布局
			// 屏幕宽高
			// 原始宽高
			Global.initCapabilities(200, 200, true);
			var demo7:Demo7View=new Demo7View();
			addChild(demo7);


			// ==============================================
			// ================ JSFL 部分  ==================
			// ==============================================
			// 生成一个普通弹窗
//			PopupManager.getInstance().showTopPanel(MovieView);
		}
	}
}