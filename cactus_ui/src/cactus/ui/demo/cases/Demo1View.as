package cactus.ui.demo.cases
{
	import cactus.ui.control.*;
	import cactus.ui.demo.vo.Demo1RendererVO;

	import lib.Demo1Renderer_UI;

	public class Demo1View extends Demo1Renderer_UI implements IPTileListRenderer
	{
		public function Demo1View(src:*=null)
		{
			super("Demo1Renderer_UI")
		}

		override public function init():void
		{
			// must call super
			super.init();

			// some logic
			txt_title.text="titleTes";
		}

		override public function destory():void
		{
			// must call super
			super.destory();
		}

		override public function fireDataChange():void
		{
			var vo:Demo1RendererVO;
			if (data)
			{
				vo=this.data as Demo1RendererVO;
				txt_title.text="title" + vo.title.toString();
			}
		}

		override public function get width():Number
		{
			return 150;
		}

		override public function get height():Number
		{
			return 300;
		}

	}
}
