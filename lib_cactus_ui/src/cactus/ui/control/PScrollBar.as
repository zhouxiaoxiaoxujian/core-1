package cactus.ui.control
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import cactus.ui.bind.PAutoView;

	/**
	 *
	 * 滚动条
	 * @author Peng
	 */
	public class PScrollBar extends PAutoView
	{
		// 素材均不使用绑定
		public var btn_up_PB:PButton;
		public var btn_down_PB:PButton;
		public var scrollSlider_PB:PScrollSlider = new PScrollSlider(null, _orientation, onChange);

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

		public function PScrollBar($sourceName:* = null, orientation:String = "vertical", defaultHandler:Function = null)
		{
			_orientation = orientation;
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

			btn_up_PB.addEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			btn_down_PB.addEventListener(MouseEvent.MOUSE_DOWN, onDownClick);

			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(REPEAT_TIME);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);
		}

		override public function destory():void
		{
			btn_up_PB.removeEventListener(MouseEvent.MOUSE_DOWN, onUpClick);
			btn_down_PB.removeEventListener(MouseEvent.MOUSE_DOWN, onDownClick);

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
			scrollSlider_PB.setSliderParams(min, max, value);
		}

		public function setThumbPercent(value:Number):void
		{
			scrollSlider_PB.setThumbPercent(value);
		}

		override public function draw():void
		{
			super.draw();
			scrollSlider_PB.draw();
			if (_autoHide)
			{
				visible = scrollSlider_PB.thumbPercent < 1.0;
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
			scrollSlider_PB.value = v;
		}

		public function get value():Number
		{
			return scrollSlider_PB.value;
		}

		public function set minimum(v:Number):void
		{
			scrollSlider_PB.minimum = v;
		}

		public function get minimum():Number
		{
			return scrollSlider_PB.minimum;
		}

		public function set maximum(v:Number):void
		{
			scrollSlider_PB.maximum = v;
		}

		public function get maximum():Number
		{
			return scrollSlider_PB.maximum;
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
			scrollSlider_PB.pageSize = value;
			invalidate();
		}

		public function get pageSize():int
		{
			return scrollSlider_PB.pageSize;
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
			scrollSlider_PB.value -= _lineSize;
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
			scrollSlider_PB.value += _lineSize;
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
