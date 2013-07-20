package cactus.common.xx.formation
{
	import flash.events.EventDispatcher;

	/**
	 * 基本阵型系统
	 *
	 *
	 * @author Peng
	 */
	public class BaseFormation
	{

		private var _dispatcher:EventDispatcher;

		// 阵型的x坐标
		private var _offsetX:Number;
		// 阵型的y坐标
		private var _offsetY:Number;


		public function BaseFormation(params:Object = null)
		{
			if (params)
			{
				for (var key:String in params)
				{
					this[key] = params[key];
				}
			}
		}

		/**
		 * 将目标items应用到阵型
		 *
		 * @param items	与游戏逻辑相关的具体Sprites
		 */
		public function load(items:Array, $offsetX:Number = 0, $offsetY:Number = 0):void
		{
			loadItems(items);
			setItemsOffset(items, $offsetX, $offsetY);
		}

		protected function setItemsOffset(items:Array, $offsetX:Number, $offsetY:Number):void
		{
			_offsetX = $offsetX;
			_offsetY = $offsetY;

			var item:*;
			// 设置偏移值
			if (offsetX != 0 || offsetY != 0)
			{
				for each (item in items)
				{
					item.x += offsetX;
					item.y += offsetY;
				}
			}
		}

		protected function loadItems(items:Array):void
		{
			throw new Error("NO IMPL");
		}



		public function get dispatcher():EventDispatcher
		{
			if (!_dispatcher)
			{
				_dispatcher = new EventDispatcher;
			}
			return _dispatcher;
		}

		public function set dispatcher(value:EventDispatcher):void
		{
			_dispatcher = value;
		}

		public function get offsetY():Number
		{
			return _offsetY;
		}

		public function set offsetY(value:Number):void
		{
			_offsetY = value;
		}

		public function get offsetX():Number
		{
			return _offsetX;
		}

		public function set offsetX(value:Number):void
		{
			_offsetX = value;
		}

	}
}