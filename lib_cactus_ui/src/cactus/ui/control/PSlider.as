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
	public class PSlider extends PAutoView
	{
		// 素材绑定
		// 柄
		public var mmc_handle_PB:MovieClip;
		// 背景
		public var mmc_bg_PB:MovieClip;

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
		public function PSlider($sourceName:*=null, orientation:String=PSlider.VERTICAL, defaultHandler:Function=null)
		{
			_orientation=orientation;
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
			mmc_handle_PB.addEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			mmc_handle_PB.buttonMode=true;
			mmc_bg_PB.addEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
		}

		override public function destory(): void
		{
			if (_defaultHandler != null)
			{
				removeEventListener(Event.CHANGE, _defaultHandler);
			}
			
			mmc_handle_PB.removeEventListener(MouseEvent.MOUSE_DOWN, onDrag);
			mmc_bg_PB.removeEventListener(MouseEvent.MOUSE_DOWN, onBackClick);
		}
		

		override public function draw():void
		{
			super.draw();
			drawHandle();
		}

		/**
		 * 设置滑动条的方向
		 * @param dir
		 */
		public function setDirection(dir:String ):void
		{
			_orientation = dir;
		}
		
		/**
		 * 重绘handle_PB
		 */
		protected function drawHandle():void
		{

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
				mmc_handle_PB.x=(_value - _min) / (_max - _min) * range;
			}
			else
			{
				range=height - width;
				mmc_handle_PB.y=height - width - (_value - _min) / (_max - _min) * range;
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
				mmc_handle_PB.x=mouseX - height / 2;
				mmc_handle_PB.x=Math.max(mmc_handle_PB.x, 0);
				mmc_handle_PB.x=Math.min(mmc_handle_PB.x, width - height);
				_value=mmc_handle_PB.x / (width - height) * (_max - _min) + _min;
			}
			else
			{
				mmc_handle_PB.y=mouseY - width / 2;
				mmc_handle_PB.y=Math.max(mmc_handle_PB.y, 0);
				mmc_handle_PB.y=Math.min(mmc_handle_PB.y, height - width);
				_value=(height - width - mmc_handle_PB.y) / (height - width) * (_max - _min) + _min;
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
				mmc_handle_PB.startDrag(false, new Rectangle(0, 0, mmc_bg_PB.width - mmc_bg_PB.height, 0));
			}
			else
			{
				mmc_handle_PB.startDrag(false, new Rectangle(0, 0, 0, mmc_bg_PB.height - mmc_bg_PB.width));
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
				_value=mmc_handle_PB.x / (mmc_bg_PB.width - mmc_bg_PB.height) * (_max - _min) + _min;
			}
			else
			{
				_value=(mmc_bg_PB.height - mmc_bg_PB.width - mmc_handle_PB.y) / (mmc_bg_PB.height - mmc_bg_PB.width) * (_max - _min) + _min;
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
