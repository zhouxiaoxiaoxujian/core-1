package cactus.ui.control
{
	import flash.events.MouseEvent;
	
	import cactus.ui.bind.PAutoView;
	import cactus.ui.bind.PView;
	
	/**
	 * 只有两个状态的视图 
	 * btn_open 开启视图状态的按钮
	 * getContent() 视图状态对象
	 * @author supperhpxd
	 */
	public class PToggleView extends PAutoView
	{
		public var btn_open_PB:PButton;

		protected var _open:Boolean;
		
		public function PToggleView($sourceName:String=null)
		{
			super($sourceName);
		}
		
		override public function init():void
		{
			super.init();
			btn_open_PB.addEventListener(MouseEvent.CLICK,btn_openClick)
			open = false;
		}
		
		override public function destory():void
		{
			super.destory();
			btn_open_PB.removeEventListener(MouseEvent.CLICK, btn_openClick);
		}
		
		/**
		 * 视图状态对象 
		 * @return 
		 */
		public function getContent():PView
		{
			return null;
		}
		
		public function get open():Boolean
		{
			return _open;
		}
		
		public function set open(value:Boolean):void
		{
			_open=value;
			
			if (_open)
			{
				getContent().showIn();
			}
			else
			{
				getContent().showOut();
			}
		}
		
		private function btn_openClick(evt:MouseEvent):void
		{
			open=!open;
		}
		
		
	}
}