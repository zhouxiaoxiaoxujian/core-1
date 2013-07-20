/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.tools.cache
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author ｋａｋａ
	 * 位图缓存类
	 */
	public class BitmapCacher
	{
		/**
		 * 缓存单张位图
		 * @param	source			要被绘制的目标对象
		 * @param	transparent	是否透明
		 * @param	fillColor			填充色
		 * @return
		 */
		static public function cacheBitmap(source : DisplayObject, transparent : Boolean = true, fillColor : uint = 0x00000000) : BitmapFrameInfo
		{
			var rect : Rectangle = source.getBounds(source);
			var x : int = Math.round(rect.x);
			var y : int = Math.round(rect.y);
			var bitData : BitmapData = new BitmapData(Math.ceil(rect.width), Math.ceil(rect.height), transparent, fillColor);
			bitData.draw(source, new Matrix(1, 0, 0, 1, -x, -y));

			var bitInfo : BitmapFrameInfo = new BitmapFrameInfo();
			bitInfo.x = x;
			bitInfo.y = y;
			bitInfo.bitData = bitData;

			return bitInfo;
		}

		/**
		 * 缓存位图动画
		 * @param	mc				要被绘制的影片剪辑
		 * @param	transparent	是否透明
		 * @param	fillColor			填充色
		 * @return
		 */
		static public function cacheSingleBitmapMovie(mc : MovieClip, transparent : Boolean = true, fillColor : uint = 0x00000000) : Vector.<BitmapFrameInfo>
		{
			var i : int = 0;
			var c : int = mc.totalFrames;

			var v_bitInfo : Vector.<BitmapFrameInfo> = new Vector.<BitmapFrameInfo>(c, true);

			for (i = 0; i < mc.totalFrames; i++)
			{
				mc.gotoAndStop((i + 1));
				v_bitInfo[i] = cacheBitmap(mc, transparent, fillColor);
			}

			return v_bitInfo;
		}

		/**
		 * 缓存位图动画
		 * @param mc
		 * @param transparent
		 * @param fillColor
		 * @return
		 */
		static public function cacheBitmapMovie(mc : MovieClip, transparent : Boolean = true, fillColor : uint = 0x00000000) : Vector.<Vector.<BitmapFrameInfo>>
		{
			var length : int = mc.totalFrames;
			var result : Vector.<Vector.<BitmapFrameInfo>> = new Vector.<Vector.<BitmapFrameInfo>>;

			// 先放入第一层时间轴
			result.push(cacheSingleBitmapMovie(mc));

			// 逐帧放入第二层时间轴
			for (var i : int = 0; i < mc.totalFrames; i++)
			{
				mc.gotoAndStop((i + 1));
				var innerMc : MovieClip = mc.getChildAt(mc.numChildren - 1) as MovieClip;

				// 逐帧播放innerMc，并缓存外层mc
				var innerResult : Vector.<BitmapFrameInfo> = new Vector.<BitmapFrameInfo>;
				if (innerMc && innerMc.totalFrames > 1)
				{
					for (var j : int = 0; j < innerMc.totalFrames; j++)
					{
						innerMc.gotoAndStop((j + 1));
						innerResult.push(cacheBitmap(mc));

					}
					result.push(innerResult);
				}

					// 是动画再缓存
				/*				if (innerMc && innerMc.totalFrames > 1)
								{
									result.push( cacheSingleBitmapMovie(innerMc) );
								}*/

			}

			return result;
		}


	}

}
