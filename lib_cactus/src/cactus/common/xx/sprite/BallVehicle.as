/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.xx.sprite
{
	import flash.display.Graphics;
	import flash.display.Sprite;

	/**
	 * 圆球
	 * @author Administrator
	 */
	public class BallVehicle extends Vehicle
	{
		private var _color:uint;
		private var _radius:Number;

		public function BallVehicle(pRadius:Number=10, pColor:uint=0x000000)
		{
			_color=pColor;
			_radius=pRadius;
			super();
		}

		override public function destory():void
		{
			super.destory();
			this.graphics.clear();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color=value;
		}

		public function get radius():Number
		{
			return _radius;
		}

		public function set radius(value:Number):void
		{
			_radius=value;
		}

		// ----------------------------------------------------------------------------------------
		//
		// protected
		//
		// ----------------------------------------------------------------------------------------

		override protected function draw():void
		{
			var g:Graphics=this.graphics;
			g.clear();
			g.beginFill(_color);
			g.drawCircle(0, 0, _radius);
			g.endFill();
		}

		// ----------------------------------------------------------------------------------------
		//
		// private
		//
		// ----------------------------------------------------------------------------------------

	}
}
