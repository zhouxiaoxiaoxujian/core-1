package lib
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;
	import cactus.ui.base.BasePopupPanel;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public class Demo3TileList_UI extends PAutoView
	{

		[Bind]
		public var slt_list:PTileList=new PTileList;

		public function Demo3TileList_UI(src:*=null)
		{
			super(src)
		}

		override public function getBindObj():Array
		{
			return [{"propertyName": "slt_list"}];
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
