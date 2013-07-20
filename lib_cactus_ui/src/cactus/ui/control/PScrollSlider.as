package cactus.ui.control
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * 滚动条上的滚动块 和 背景
	 * @author Administrator
	 */
	public class PScrollSlider extends PSlider
	{
		// 素材绑定见父类

		protected var _thumbPercent:Number=1.0;
		protected var _pageSize:int=1;

		public function PScrollSlider($sourceName:*=null, orientation:String=PSlider.VERTICAL, defaultHandler:Function=null)
		{
			super($sourceName, orientation, defaultHandler);
		}

		override public function init():void
		{
			super.init();
			setSliderParams(1, 1, 0);
		}

		override protected function positionHandle():void
		{
			var range:Number;
			if (_orientation == HORIZONTAL)
			{
				range=mmc_bg_PB.width - mmc_handle_PB.width;
				mmc_handle_PB.x=(_value - _min) / (_max - _min) * range;
			}
			else
			{
				range=mmc_bg_PB.height - mmc_handle_PB.height;
				mmc_handle_PB.y=(_value - _min) / (_max - _min) * range;
			}
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		public function setThumbPercent(value:Number):void
		{
			_thumbPercent=Math.min(value, 1.0);
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
				size=Math.round(mmc_bg_PB.width * _thumbPercent);
				size=Math.max(mmc_bg_PB.height, size);
				mmc_handle_PB.width=size;
			}
			else
			{
				size=Math.round(mmc_bg_PB.height * _thumbPercent);
				size=Math.max(mmc_bg_PB.width, size);
				mmc_handle_PB.height=size;
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
				if (mouseX < mmc_handle_PB.x)
				{
					if (_max > _min)
					{
						_value-=_pageSize;
					}
					else
					{
						_value+=_pageSize;
					}
					correctValue();
				}
				else
				{
					if (_max > _min)
					{
						_value+=_pageSize;
					}
					else
					{
						_value-=_pageSize;
					}
					correctValue();
				}
				positionHandle();
			}
			else
			{
				if (mouseY < mmc_handle_PB.y)
				{
					if (_max > _min)
					{
						_value-=_pageSize;
					}
					else
					{
						_value+=_pageSize;
					}
					correctValue();
				}
				else
				{
					if (_max > _min)
					{
						_value+=_pageSize;
					}
					else
					{
						_value-=_pageSize;
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
				mmc_handle_PB.startDrag(false, new Rectangle(0, 0, mmc_bg_PB.width - mmc_handle_PB.width, 0));
			}
			else
			{
				mmc_handle_PB.startDrag(false, new Rectangle(0, 0, 0, mmc_bg_PB.height - mmc_handle_PB.height));
			}
		}

		protected override function onSlide(event:MouseEvent):void
		{

			var oldValue:Number=_value;
			if (_orientation == HORIZONTAL)
			{
				if (width == mmc_handle_PB.width)
				{
					_value=_min;
				}
				else
				{
					_value=mmc_handle_PB.x / (mmc_bg_PB.width - mmc_handle_PB.width) * (_max - _min) + _min;
				}
			}
			else
			{
				if (height == mmc_handle_PB.height)
				{
					_value=_min;
				}
				else
				{
					_value=mmc_handle_PB.y / (mmc_bg_PB.height - mmc_handle_PB.height) * (_max - _min) + _min;
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
			_pageSize=value;
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
