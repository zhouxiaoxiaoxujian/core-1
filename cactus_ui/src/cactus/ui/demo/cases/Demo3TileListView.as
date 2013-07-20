package cactus.ui.demo.cases
{
	import cactus.ui.control.*;
	import cactus.ui.demo.cases.Demo1View;
	import cactus.ui.demo.vo.Demo1RendererVO;

	import lib.Demo1Renderer_UI;
	import lib.Demo3TileList_UI;

	public class Demo3TileListView extends Demo3TileList_UI
	{

		public function Demo3TileListView(src:*=null)
		{
			super("Demo3TileList_UI")
		}

		override public function init():void
		{
			// must call super	
			super.init();

			slt_list.setStandard(3, 1);
			slt_list.setRenderer(Demo1View);

			// set data
			var dataProvider:Array=[];
			for (var i:int=0; i < 10; i++)
			{
				var vo:Demo1RendererVO=new Demo1RendererVO();
				vo.title=i.toString();
				dataProvider.push(vo);
			}
			slt_list.data=dataProvider;
		}

		override public function destory():void
		{
			// must call super
			super.destory();
		}

		override public function fireDataChange():void
		{
		}
	}
}
