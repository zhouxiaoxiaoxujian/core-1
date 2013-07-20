/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.tools.cache
{
	import flash.display.BitmapData;

	/**
	 * ...
	 * @author ｋａｋａ
	 * 位图帧信息
	 *
	 * Modify by Peng
	 */
	public class BitmapFrameInfo
	{
		/**
		 * x轴偏移
		 */
		public var x:Number;

		/**
		 * y轴偏移
		 */
		public var y:Number;

		/**
		 * 位图数据
		 */
		public var bitData:BitmapData;

		public function toString():String
		{
			return "x: " + x + " y: " + y + " width: " + bitData.width + " height: " + bitData.height;
		}

	}

}