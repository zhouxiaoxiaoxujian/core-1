
package cactus.ui.control
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.classical.PComponent;

	/**
	 * 进度条
	 * @author Peng
	 */
	[Event(name = "change", type = "flash.events.Event")]
	public class PProgressBar extends PAutoView
	{
		/**
		 * 水平
		 */
		public static const DIR_HORIZONTAL:int = 1;

		/**
		 * 垂直
		 */
		public static const DIR_VERTICAL:int = 2;

		/**
		 * 进度条
		 */
		public var mmc_bar_PB:MovieClip;
		/**
		 * 进度条遮罩
		 */
		public var viewport_PB:MovieClip;

		protected var _value:Number;
		protected var _max:Number;
		protected var _dir:int;

		public function PProgressBar($sourceName:String = null, $dir:int = 1, $max:Number = 1, $value:Number = 0)
		{
			_max = $max;
			_value = $value;
			_dir = $dir
			super($sourceName);
		}

		override public function init():void
		{
			mmc_bar_PB.mask = viewport_PB;
			invalidate();
		}

		///////////////////////////////////
		// public methods
		///////////////////////////////////

		override public function draw():void
		{
			if (_dir == DIR_HORIZONTAL)
			{
				viewport_PB.scaleX = _value / _max;
			}
			else
			{
				viewport_PB.scaleY = _value / _max;
			}
		}

		public function setStandard($dir:int = 1, $max:Number = 1, $value:Number = 0):void
		{
			_max = $max;
			_value = $value;
			_dir = $dir;
			invalidate();
		}
			
		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		public function set maximum(m:Number):void
		{
			_max = m;
			_value = Math.min(_value, _max);
			invalidate();
		}

		public function get maximum():Number
		{
			return _max;
		}

		public function set value(v:Number):void
		{
			_value = Math.min(v, _max);
			invalidate();
		}

		public function get value():Number
		{
			return _value;
		}

	}
}
