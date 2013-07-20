package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	[Event(name="change", type="flash.events.Event")]

	/**
	 * PSlider 基类
	 * 支持水平，垂直方向的滑动值
	 * 注意，对应绑定的素材必须非常的“细”
	 * @author Administrator
	 */
	public class PSliderEx extends PAutoView
	{
		// 素材均不使用绑定
		// 柄
		public var mmc_handle:MovieClip;
		// 背景
		public var mmc_back:MovieClip;

		// 属性 
		protected var _value:Number=0;
		protected var _max:Number=100;
		protected var _min:Number=0;
		protected var _orientation:String;
		protected var _tick:Number=0.01;

		public static const HORIZONTAL:String="horizontal";
		public static const VERTICAL:String="vertical";

		protected var _defaultHandler : Function;
		
		/**
		 * @param orientation 		朝向
		 * @param defaultHandler 	change事件发出的默认处理
		 */
		public function PSliderEx($sourceName:*=null, orientation:String="vertical", defaultHandler:Function=null)
		{
			_orientation=orientation;
			
			mmc_handle = $sourceName["mmc_handle"];
			mmc_back = $sourceName["mmc_back"];
			
			mmc_handle.x = mmc_back.x = 0;
			addChildAt(mmc_handle,0);
			addChildAt(mmc_back,0);
			
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
			mmc_handle.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			mmc_handle.buttonMode=true;
			mmc_back.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
		}

		override public function destory(): void
		{
			if (_defaultHandler != null)
			{
				removeEventListener(Event.CHANGE, _defaultHandler);
			}
			
			mmc_handle.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			mmc_back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
		}
		

		override public function draw():void
		{
			super.draw();
			drawBack();
			drawHandle();
		}

		/**
		 */
		protected function drawBack():void
		{
			mmc_back.width = width;
			mmc_back.height = height;
		}
		
		/**
		 */
		protected function drawHandle():void
		{	
			if(_orientation == HORIZONTAL)
			{
				mmc_handle.x = mmc_handle.y = 1;
				mmc_handle.width = mmc_handle.height =  _height - 2;
			}
			else
			{
				mmc_handle.x = mmc_handle.y = 1;
				mmc_handle.width = mmc_handle.height =  _width - 2;
				
			}
			positionHandle();
		}

		/**
		 * 调整value，使之介于min和max之间
		 */
		protected function correctValue():void
		{
			if (_max > _min)
			{
				_value=Math.min(_value, _max);
				_value=Math.max(_value, _min);
			}
			else
			{
				_value=Math.max(_value, _max);
				_value=Math.min(_value, _min);
			}
		}

		/**
		 * Adjusts position of handle when value, maximum or minimum have changed.
		 * TODO: Should also be called when slider is resized.
		 */
		protected function positionHandle():void
		{
			var range:Number;
			if (_orientation == HORIZONTAL)
			{
				range=width - height;
				mmc_handle.x=(_value - _min) / (_max - _min) * range;
			}
			else
			{
				range=height - width;
				mmc_handle.y=height - width - (_value - _min) / (_max - _min) * range;
			}
		}


		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * 一句话搞定设置slider的min，max，value
		 * @param min
		 * @param max
		 * @param value
		 */
		public function setSliderParams(min:Number, max:Number, value:Number):void
		{
			this.minimum=min;
			this.maximum=max;
			this.value=value;
		}




		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * 点击滚动条背景
		 * @param event
		 */
		protected function onBackClick(event:MouseEvent):void
		{
			if (_orientation == HORIZONTAL)
			{
				mmc_handle.x=mouseX - height / 2;
				mmc_handle.x=Math.max(mmc_handle.x, 0);
				mmc_handle.x=Math.min(mmc_handle.x, width - height);
				_value=mmc_handle.x / (width - height) * (_max - _min) + _min;
			}
			else
			{
				mmc_handle.y=mouseY - width / 2;
				mmc_handle.y=Math.max(mmc_handle.y, 0);
				mmc_handle.y=Math.min(mmc_handle.y, height - width);
				_value=(height - width - mmc_handle.y) / (height - width) * (_max - _min) + _min;
			}
			dispatchEvent(new Event(Event.CHANGE));
		}

		/**
		 * 拖拽开始MouseDown
		 * 对于滚动条，需要在子类PScrollBar中重写
		 * @param event
		 */
		protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if (_orientation == HORIZONTAL)
			{
				mmc_handle.startDrag(false, new Rectangle(0, 0, mmc_back.width - mmc_back.height, 0));
			}
			else
			{
				mmc_handle.startDrag(false, new Rectangle(0, 0, 0, mmc_back.height - mmc_back.width));
			}
		}

		/**
		 * 拖拽结束MouseUp
		 * @param event
		 */
		protected function onDrop(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			stopDrag();
		}

		/**
		 * 拖拽时的MouseMove
		 * @param event The MouseEvent passed by the system.
		 */
		protected function onSlide(event:MouseEvent):void
		{
			var oldValue:Number=_value;
			if (_orientation == HORIZONTAL)
			{
				_value=mmc_handle.x / (mmc_back.width - mmc_back.height) * (_max - _min) + _min;
			}
			else
			{
				_value=(mmc_back.height - mmc_back.width - mmc_handle.y) / (mmc_back.height - mmc_back.width) * (_max - _min) + _min;
			}

			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}




		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set value(v:Number):void
		{
			_value=v;
			correctValue();
			positionHandle();
		}

		public function get value():Number
		{
//			trace(Math.round(_value / _tick) * _tick,_value);
			return Math.round(_value / _tick) * _tick;
		}

		/**
		 * 直接取value的值，未经tick处理
		 */
		public function get rawValue():Number
		{
			return _value;
		}

		public function set maximum(m:Number):void
		{
			_max=m;
			correctValue();
			positionHandle();
		}

		public function get maximum():Number
		{
			return _max;
		}

		public function set minimum(m:Number):void
		{
			_min=m;
			correctValue();
			positionHandle();
		}

		public function get minimum():Number
		{
			return _min;
		}

		public function set tick(t:Number):void
		{
			_tick=t;
		}

		public function get tick():Number
		{
			return _tick;
		}

	}
}
