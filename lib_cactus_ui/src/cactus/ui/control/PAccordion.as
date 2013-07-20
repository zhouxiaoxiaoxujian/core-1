package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import cactus.ui.control.classical.VBox;

	/**
	 *
	 * @author Peng
	 */
	public class PAccordion extends PAutoView
	{
		protected var _windows:Array;
		protected var _vbox:VBox;

		public function PAccordion($sourceName:String = null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			_vbox = new VBox(this);
			_vbox.spacing = 0;
			addChild(_vbox);

			_windows = new Array();
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		public function addWindow(window:PWindow):void
		{
			addWindowAt(window, _windows.length);
		}

		public function addWindowAt(window:PWindow, index:int):void
		{
			index = Math.min(index, _windows.length);
			index = Math.max(index, 0);

			_vbox.addChildAt(window, index);

			window.minimized = true;
			window.addEventListener(Event.SELECT, onWindowSelect);
			_windows.splice(index, 0, window);
			
//			_winHeight = _height - (_windows.length - 1) * 20;
//			setSize(_winWidth, _winHeight);
		}

		override public function draw():void
		{
//			_winHeight = Math.max(_winHeight, 40);
//			for (var i:int = 0; i < _windows.length; i++)
//			{
//				_windows[i].setSize(_winWidth, _winHeight);
//				_vbox.draw();
//			}
			
			_vbox.draw();
		}

		public function getWindowAt(index:int):PWindow
		{
			return _windows[index];
		}


		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		protected function onWindowSelect(event:Event):void
		{
			var window:PWindow = event.target as PWindow;
			if (window.minimized)
			{
				for (var i:int = 0; i < _windows.length; i++)
				{
					_windows[i].minimized = true;
				}
				window.minimized = false;
			}
			_vbox.draw();
		}

	}
}