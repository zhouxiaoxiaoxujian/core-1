package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;

	/**
	 *
	 * 滚动条
	 * @author Peng
	 */
	public class PScrollBarEx extends PAutoView
	{
		// 素材不使用绑定
		public var btn_up:PButton;
		public var btn_down:PButton;

		public var scrollSlider:PScrollSliderEx;

		protected const DELAY_TIME:int = 500;
		protected const REPEAT_TIME:int = 100;
		protected const UP:String = "up";
		protected const DOWN:String = "down";

		protected var _autoHide:Boolean = false;

		protected var _orientation:String;
		protected var _lineSize:int = 1;

		// 检测鼠标按下不抬起
		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;
		protected var _shouldRepeat:Boolean = false;

		protected var _defaultHandler:Function;
		protected var _scrollBarSize:Number;
		protected var _size:Number = 10;
		
		public function PScrollBarEx($sourceName:* = null, orientation:String = "vertical", defaultHandler:Function = null,scrollBarSize:Number = 1)
		{
			_size = _size * scrollBarSize;
			_scrollBarSize = scrollBarSize;
			_orientation = orientation;

			if (orientation == PSliderEx.VERTICAL)
			{
				$sourceName ||= getDefinitionByName("DefaultVScrollBar") as Class;
			}
			$sourceName = new $sourceName() as MovieClip;
			$sourceName["btn_up"].width = $sourceName["btn_up"].height = _size;
			$sourceName["btn_down"].width = $sourceName["btn_down"].height = _size;
			btn_up = new PButton($sourceName["btn_up"], true, 0);
			btn_down = new PButton($sourceName["btn_down"], true, 0);
			addChild(btn_up);
			addChild(btn_down);

			scrollSlider = new PScrollSliderEx($sourceName["scrollSlider"], _orientation, onChange);
			addChild(scrollSlider);

			super($sourceName);
			if (defaultHandler != null)
			{
				_defaultHandler = defaultHandler;
				addEventListener(Event.CHANGE, defaultHandler);
			}
		}

		override public function init():void
		{
			super.init();
			btn_up.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			btn_down.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);

			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);



		}

		override public function destory():void
		{
			btn_up.removeEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			btn_down.removeEventListener(MouseEvent.MOUSE_DOWN, onDownClick);

			if (_defaultHandler != null)
			{
				removeEventListener(Event.CHANGE, _defaultHandler);
			}

			if (stage.hasEventListener(MouseEvent.MOUSE_UP))
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
			}
			_delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeat);
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			scrollSlider.setSliderParams(min, max, value);
		}

		public function setThumbPercent(value:Number):void
		{
			scrollSlider.setThumbPercent(value);
		}

		override public function draw():void
		{
			super.draw();

			if (_orientation == PSliderEx.VERTICAL)
			{
				scrollSlider.x = 0;
				scrollSlider.y = _size;
				scrollSlider.width = _size;
				scrollSlider.height = height - _size*2;
				btn_down.x = 0;
				btn_down.y = height - _size;
			}
			else
			{
				scrollSlider.x = _size;
				scrollSlider.y = 0;
				scrollSlider.width = width - _size*2;
				scrollSlider.height = _size;

				btn_down.x = width - _size;
				btn_down.y = 0;
			}

			scrollSlider.draw();
			if (_autoHide)
			{	
				visible = scrollSlider.thumbPercent < 1.0;
			}
			else
			{
				visible = true;
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set autoHide(value:Boolean):void
		{
			_autoHide = value;
			invalidate();
		}

		public function get autoHide():Boolean
		{
			return _autoHide;
		}

		public function set value(v:Number):void
		{
			scrollSlider.value = v;
		}

		public function get value():Number
		{
			return scrollSlider.value;
		}

		public function set minimum(v:Number):void
		{
			scrollSlider.minimum = v;
		}

		public function get minimum():Number
		{
			return scrollSlider.minimum;
		}

		public function set maximum(v:Number):void
		{
			scrollSlider.maximum = v;
		}

		public function get maximum():Number
		{
			return scrollSlider.maximum;
		}

		/**
		 * 当上下箭头点击时的 偏移量
		 */
		public function set lineSize(value:int):void
		{
			_lineSize = value;
		}

		public function get lineSize():int
		{
			return _lineSize;
		}

		/**
		 * 当back背景点击时的 偏移量
		 */
		public function set pageSize(value:int):void
		{
			scrollSlider.pageSize = value;
			invalidate();
		}

		public function get pageSize():int
		{
			return scrollSlider.pageSize;
		}



		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		protected function onUpClick(event:MouseEvent):void
		{
			goUp();
			_shouldRepeat = true;
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		protected function goUp():void
		{
			scrollSlider.value -= _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onDownClick(event:MouseEvent):void
		{
			goDown();
			_shouldRepeat = true;
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		protected function goDown():void
		{
			scrollSlider.value += _lineSize;
			dispatchEvent(new Event(Event.CHANGE));
		}

		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
			_shouldRepeat = false;
		}

		protected function onChange(event:Event):void
		{
			dispatchEvent(event);
		}

		protected function onDelayComplete(event:TimerEvent):void
		{
			if (_shouldRepeat)
			{
				_repeatTimer.start();
			}
		}

		protected function onRepeat(event:TimerEvent):void
		{
			if (_direction == UP)
			{
				goUp();
			}
			else
			{
				goDown();
			}
		}
	}
}
