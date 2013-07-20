package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 窗口
	 * 支持正常化，最小化两种形态
	 *
	 * @author Peng
	 */
	public class PWindow extends PAutoView
	{
		protected var _minimized:Boolean = false;

		protected var _minPanel:Sprite;
		protected var _normalPanel:Sprite;

		public function PWindow($sourceName:* = null)
		{
			super($sourceName);
			
			if (!_minPanel)
			{
				_minPanel = new Sprite();
				_minPanel.addEventListener(MouseEvent.CLICK, onMinPanelClick);
				addChild(_minPanel);
			}
			
			if (!_normalPanel)
			{
				_normalPanel = new Sprite();
				addChild(_normalPanel);
			}
		}

		override public function init():void
		{

		}


		override public function destory():void
		{
			if (_minPanel)
			{
				_minPanel.removeEventListener(MouseEvent.CLICK, onMinPanelClick);	
			}
		}

		/**
		 * 设置Window是否为最小化
		 * 当为最小化时，只有在最小化容器中的部分才会显示
		 * 
		 * @param value
		 */
		public function set minimized(value:Boolean):void
		{
			_minimized = value;

			if (_minimized)
			{
				if (contains(_normalPanel))
					removeChild(_normalPanel);
				
				addChild(_minPanel);
			}
			else
			{
				if (_minPanel && contains(_minPanel))
					removeChild(_minPanel);
				
				addChild(_normalPanel);
			}
			
			dispatchEvent(new Event(Event.RESIZE));
		}

		public function get minimized():Boolean
		{
			return _minimized;
		}

		private function onMinPanelClick(event:MouseEvent):void
		{
			dispatchEvent(new Event(Event.SELECT));
		}
	}
}