/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.factory
{
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;

	/**
	 *
	 * @author Peng
	 */
	public class ColorTransformFactory
	{
		private static var defaultColorTransform:ColorTransform = new ColorTransform(1, 1, 1);
		private static var defaultColorTransformWhenMove:ColorTransform = new ColorTransform(1, 1, 1, .5);
		private static var redTransform:ColorTransform = new ColorTransform(1, 0, 0, .5);
		private static var blackAndWhiteTransform:ColorTransform = new ColorTransform(1, 0, 0, .5);

		public function ColorTransformFactory()
		{
		}

		/**
		 * 默认原色变换
		 * @return
		 */
		public static function createDefaultColorTransform():ColorTransform
		{
			return defaultColorTransform;
		}

		/**
		 * 带有透明度的默认原色变换
		 * @return
		 */
		public static function createDefaultColorTransformWhenMove():ColorTransform
		{
			return defaultColorTransformWhenMove;
		}

		/**
		 * 红色变换
		 * @return
		 */
		public static function createRedColorTransform():ColorTransform
		{
			return redTransform;
		}

		/**
		 * 黑白变换
		 * @return
		 */
		public static function createBlackAndWhiteTransform():ColorTransform
		{
			return blackAndWhiteTransform;
		}

		/**
		 * 黑白滤镜
		 * @return
		 */
		public static function createBlackAndWhiteFilter():ColorMatrixFilter
		{
//			用颜色矩阵滤镜
			var red:Number = 0.3086;
			var green:Number = 0.694;
			var blue:Number = 0.0820; //这三个值是提供标准的黑白效果
			return new ColorMatrixFilter([red, green, blue, 0, 0, red, green, blue, 0, 0, red, green, blue, 0, 0, 0, 0, 0, 1, 0]);
		}




	}
}