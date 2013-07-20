package lib
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import cactus.ui.base.BasePopupPanel;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Demo2Renderers_UI extends PAutoView
	{

		[Bind]
		public var renderer3:Demo1Renderer_UI=new Demo1Renderer_UI;
		[Bind]
		public var renderer2:Demo1Renderer_UI=new Demo1Renderer_UI;
		[Bind]
		public var renderer1:Demo1Renderer_UI=new Demo1Renderer_UI;

		public function Demo2Renderers_UI(src:*=null)
		{
			super(src)
		}

		override public function getBindObj():Array
		{
			return [{"propertyName": "renderer3"}, {"propertyName": "renderer2"}, {"propertyName": "renderer1"}];
		}

		override public function init():void
		{
			super.init();
		}

		override public function destory():void
		{
			super.destory();
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}
	}
}
