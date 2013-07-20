/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.util
{
	import flash.display.BitmapData;

	/**
	 * 调试管理
	 * @author Peng
	 */
	public class TraceUtil
	{
		public function TraceUtil()
		{
		}

		public static function traceArray2(arr:Array):void
		{
			trace("----- trace a array -----");
			for (var i:int = 0;i < arr.length;i++)
			{
				trace(arr[i]);
			}
			trace("----- trace a array end -----");
		}

		/**
		 * 一维数组输出二维格式
		 * @param arr
		 */
		public static function traceVector1by2(arr:Vector.<String>):void
		{
			trace("----- trace a vector -----");
			//			for (var i:int=0;i < arr.length;i++)
			//			{
			//				trace(arr[i]);
			//			}
			trace("----- trace a vector end -----");
		}

		public static function traceBitmapData(data:BitmapData):void
		{
			trace("data width is" + data.width + " height is " + data.height);
			for (var i:int = 0;i < data.height;i++)
			{
				var line:String = "";
				for (var j:int = 0;j < data.width;j++)
				{
					line +=   data.getPixel32(j,i).toString(16);
//					line += "\t";
				}
//				trace();
				trace(line);
			}
		}
//
//		/**
//		 * 打印位图缓存对象的像素值
//		 * @param tile
//		 * @param rows
//		 * @param cols
//		 */
//		public static function traceTilePixel(tile:AbstractImageTile,rows:int,cols:int):void
//		{
//			trace("----- trace a tile -----");
//			for (var i:int = 0;i < 1;i++)
//			{
//				var line:String = "";
//				for (var j:int = 0;j < cols;j++)
//				{
//					line += String(j) + "列" + "\t";
//				}
//				trace("line" + i + ": " + line);
//			}
//
//			for (var i:int = 0;i < rows;i++)
//			{
//				var line:String = "";
//				for (var j:int = 0;j < cols;j++)
//				{
//					line += tile.getBitmapData().getPixel(j,i).toString(16) + "\t";
//				}
//				trace("line" + i + ": " + line);
//			}
//			trace("----- trace a tile end-----");
//		}
	}
}