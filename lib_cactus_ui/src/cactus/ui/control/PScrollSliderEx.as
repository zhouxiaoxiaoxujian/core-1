package cactus.ui.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 滚动条上的滚动块 和 背景
	 * @author Administrator
	 */
	public class PScrollSliderEx extends PSliderEx
	{
		// 素材绑定见父类

		protected var _thumbPercent:Number = 1.0;
		protected var _pageSize:int = 1;

		public function PScrollSliderEx($sourceName:* = null, orientation:String = PSliderEx.VERTICAL, defaultHandler:Function = null)
		{
			super($sourceName, orientation, defaultHandler);
			// 和PScrollSlider有所不同，因为Slider在ListEx中是new出来的,有一个异步的绑定周期
			setSliderParams(1, 1, 0);
		}

		override public function init():void
		{
			super.init();
			
		}

		override protected function positionHandle():void
		{
			var range:Number;
			if (_orientation == HORIZONTAL)
			{
				range = mmc_back.width - mmc_handle.width;
				mmc_handle.x = (_value - _min) / (_max - _min) * range;
			}
			else
			{
				range = mmc_back.height - mmc_handle.height;
				mmc_handle.y = (_value - _min) / (_max - _min) * range;
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		public function setThumbPercent(value:Number):void
		{
			_thumbPercent = Math.min(value, 1.0);
		}

		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		/**
		 * 重绘handle_PB
		 */
		override protected function drawHandle():void
		{
			var size:Number;
			if (_orientation == HORIZONTAL)
			{
				size = Math.round(mmc_back.width * _thumbPercent);
				size = Math.max(mmc_back.height, size);
				mmc_handle.width = size - 2;
				mmc_handle.height = _height - 2;
			}
			else
			{
				size = Math.round(mmc_back.height * _thumbPercent);
				size = Math.max(mmc_back.width, size);
				mmc_handle.width = _width - 2;
				mmc_handle.height = size - 2;
			}
			positionHandle();
		}

		/**
		 * 点击背景
		 * @param event
		 */
		override protected function onBackClick(event:MouseEvent):void
		{
			if (_orientation == HORIZONTAL)
			{
				if (mouseX < mmc_handle.x)
				{
					if (_max > _min)
					{
						_value -= _pageSize;
					}
					else
					{
						_value += _pageSize;
					}
					correctValue();
				}
				else
				{
					if (_max > _min)
					{
						_value += _pageSize;
					}
					else
					{
						_value -= _pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			else
			{
				if (mouseY < mmc_handle.y)
				{
					if (_max > _min)
					{
						_value -= _pageSize;
					}
					else
					{
						_value += _pageSize;
					}
					correctValue();
				}
				else
				{
					if (_max > _min)
					{
						_value += _pageSize;
					}
					else
					{
						_value -= _pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			dispatchEvent(new Event(Event.CHANGE));

		}

		override protected function onDrag(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSlide);
			if (_orientation == HORIZONTAL)
			{
				mmc_handle.startDrag(false, new Rectangle(0, 0, mmc_back.width - mmc_handle.width, 0));
			}
			else
			{
				mmc_handle.startDrag(false, new Rectangle(0, 0, 0, mmc_back.height - mmc_handle.height));
			}
		}

		protected override function onSlide(event:MouseEvent):void
		{

			var oldValue:Number = _value;
			if (_orientation == HORIZONTAL)
			{
				if (width == mmc_handle.width)
				{
					_value = _min;
				}
				else
				{
					_value = mmc_handle.x / (mmc_back.width - mmc_handle.width) * (_max - _min) + _min;
				}
			}
			else
			{
				if (height == mmc_handle.height)
				{
					_value = _min;
				}
				else
				{
					_value = mmc_handle.y / (mmc_back.height - mmc_handle.height) * (_max - _min) + _min;
				}
			}

			if (_value != oldValue)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set pageSize(value:int):void
		{
			_pageSize = value;
		}

		public function get pageSize():int
		{
			return _pageSize;
		}

		public function get thumbPercent():Number
		{
			return _thumbPercent;
		}
	}
}
