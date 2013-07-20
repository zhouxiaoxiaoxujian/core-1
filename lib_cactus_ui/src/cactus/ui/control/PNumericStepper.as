package cactus.ui.control
{

	import cactus.ui.bind.PAutoView;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Timer;

	[Event(name="change", type="flash.events.Event")]
	/**
	 * 数字步进器
	 * @author Peng
	 */
	public class PNumericStepper extends PAutoView
	{
		// 绑定的按钮
		public var btn_plus_PB:PButton;
		public var btn_minus_PB:PButton;
		public var txt_label_PB:TextField;

		protected const UP:String = "up";
		protected const DOWN:String = "down";
		protected const DELAY_TIME:int = 500;
		protected var _repeatTime:int = 100;

		protected var _value:Number = 0;
		protected var _step:Number = 1;
		protected var _labelPrecision:int = 1;

		protected var _maximum:Number = Number.POSITIVE_INFINITY;
		protected var _minimum:Number = Number.NEGATIVE_INFINITY;

		protected var _delayTimer:Timer;
		protected var _repeatTimer:Timer;
		protected var _direction:String;

		public function PNumericStepper($source:String = null)
		{
			super($source);
		}

		override public function init():void
		{
			super.init();

			_delayTimer = new Timer(DELAY_TIME, 1);
			_delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			_repeatTimer = new Timer(_repeatTime);
			_repeatTimer.addEventListener(TimerEvent.TIMER, onRepeat);

			btn_minus_PB.addEventListener(MouseEvent.MOUSE_DOWN, onMinus);
			btn_plus_PB.addEventListener(MouseEvent.MOUSE_DOWN, onPlus);
			txt_label_PB.addEventListener(Event.CHANGE, onValueTextChange);
			txt_label_PB.selectable = true;
			txt_label_PB.type = TextFieldType.INPUT;
			txt_label_PB.restrict = "0-9";
			// 默认
			value = 1;
			dispatchEvent(new Event(Event.CHANGE));
		}

		override public function destory():void
		{
			super.destory();

			if (_delayTimer.hasEventListener(TimerEvent.TIMER_COMPLETE))
				_delayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, onDelayComplete);
			if (_repeatTimer.hasEventListener(TimerEvent.TIMER))
				_repeatTimer.removeEventListener(TimerEvent.TIMER, onRepeat);

			btn_minus_PB.removeEventListener(MouseEvent.MOUSE_DOWN, onMinus);
			btn_plus_PB.removeEventListener(MouseEvent.MOUSE_DOWN, onPlus);
			txt_label_PB.removeEventListener(Event.CHANGE, onValueTextChange);

			if (stage.hasEventListener(MouseEvent.MOUSE_UP))
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}


		/**
		 * 加
		 */
		protected function increment():void
		{
			if (_value + _step <= _maximum)
			{
				_value += _step;
				invalidate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		/**
		 * 减
		 */
		protected function decrement():void
		{
			if (_value - _step >= _minimum)
			{
				_value -= _step;
				invalidate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		override public function draw():void
		{
			txt_label_PB.text = value.toString();
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * 当减号按钮按下时
		 */
		protected function onMinus(event:MouseEvent):void
		{
			decrement();
			_direction = DOWN;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		/**
		 * 当加号按钮按下时
		 */
		protected function onPlus(event:MouseEvent):void
		{
			increment();
			_direction = UP;
			_delayTimer.start();
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseGoUp);
		}

		protected function onMouseGoUp(event:MouseEvent):void
		{
			_delayTimer.stop();
			_repeatTimer.stop();
		}

		/**
		 * 当手动改变Text文字时
		 */
		protected function onValueTextChange(event:Event):void
		{
			event.stopImmediatePropagation();
			var newVal:Number = Number(txt_label_PB.text);
			newVal = Math.min(newVal, maximum);
			newVal = Math.max(newVal, minimum);

			if (newVal <= _maximum && newVal >= _minimum)
			{
				_value = newVal;
				invalidate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		protected function onDelayComplete(event:TimerEvent):void
		{
			_repeatTimer.start();
		}

		protected function onRepeat(event:TimerEvent):void
		{
			if (_direction == UP)
			{
				increment();
			}
			else
			{
				decrement();
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set value(val:Number):void
		{
			if (val <= _maximum && val >= _minimum)
			{
				_value = val;
				invalidate();
			}
		}

		public function get value():Number
		{
			return _value;
		}

		public function set step(value:Number):void
		{
			if (value < 0)
			{
				throw new Error("NumericStepper step must be positive.");
			}
			_step = value;
		}

		public function get step():Number
		{
			return _step;
		}

		/**
		 * 设置精度
		 */
		public function set labelPrecision(value:int):void
		{
			_labelPrecision = value;
			invalidate();
		}

		public function get labelPrecision():int
		{
			return _labelPrecision;
		}

		public function set maximum(value:Number):void
		{
			_maximum = value;
			if (_value > _maximum)
			{
				_value = _maximum;
				invalidate();
			}
		}

		public function get maximum():Number
		{
			return _maximum;
		}

		public function set minimum(value:Number):void
		{
			_minimum = value;
			if (_value < _minimum)
			{
				_value = _minimum;
				invalidate();
			}
		}

		public function get minimum():Number
		{
			return _minimum;
		}

		public function get repeatTime():int
		{
			return _repeatTime;
		}

		public function set repeatTime(value:int):void
		{
			// shouldn't be any need to set it faster than 10 ms. guard against negative.
			_repeatTime = Math.max(value, 10);
			_repeatTimer.delay = _repeatTime;
		}
	}
}
