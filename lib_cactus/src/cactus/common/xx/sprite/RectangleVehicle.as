package cactus.common.xx.sprite
{
	import flash.display.Graphics;

	/**
	 * 矩形机车 
	 * @author supperhpxd
	 */	
	public class RectangleVehicle extends Vehicle
	{
		private var _width:Number;
		private var _height:Number;
		private var _color:uint;
		
		public function RectangleVehicle($width:Number=50,$height:Number=50,$color:uint=0x000000)
		{
			setSize($width,$height);
			color = $color;
			super();
		}

		public function setSize($width:Number,$height:Number):void
		{
			width = $width;
			height = $height;
			draw();
		}
		
		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
			draw();
		}

		override public function get height():Number
		{
			return _height;
		}

		override public function set height(value:Number):void
		{
			_height = value;
			draw();
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set width(value:Number):void
		{
			_width = value;
			draw();
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
			g.drawRect(0,0,width,height);
			g.endFill();
		}
		
		// ----------------------------------------------------------------------------------------
		//
		// private
		//
		// ----------------------------------------------------------------------------------------

	}
}