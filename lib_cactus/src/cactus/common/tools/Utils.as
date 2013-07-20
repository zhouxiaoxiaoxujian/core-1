package cactus.common.tools
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class Utils
	{
		/**
		 * 删除所有孩子节点
		 * @param container
		 */
		public static function removeAll(container : DisplayObjectContainer) : void
		{
			while (container.numChildren > 0)
			{
				container.removeChildAt(0);
			}
		}

		public static function jumpToUrl(url : String, windows : String = "_blank") : void
		{
			navigateToURL(new URLRequest(url), windows);
		}

		/**
		 * 有一个固定大小的矩形容器，有一张任意大小的图片或者视频，要做的是将图片等比例Resize后正好填充到这个容器里，这样的Resize尺寸叫做最大内切尺寸；
		 * @param pImageW
		 * @param pImageH
		 * @param pBoxW
		 * @param pBoxH
		 * @return
		 */
		public static function getMaxSize(pImageW : Number, pImageH : Number, pBoxW : Number, pBoxH : Number) : Rectangle
		{
			var rect : Rectangle = new Rectangle(0, 0, 10, 10);
			//求得图片的宽高比例，然后和容器的宽高比例相对比，来决定到底是按照容器的宽还是高来resize图片
			var rate : Number = pImageW / pImageH;
			var rateBox : Number = pBoxW / pBoxH;
			if (rate > rateBox)
			{
				rect.width = pBoxW;
				rect.height = pBoxW / rate;
			}
			else
			{
				rect.height = pBoxH;
				rect.width = pBoxH * rate;
			}
			rect.x = pBoxW / 2 - rect.width / 2;
			rect.y = pBoxH / 2 - rect.height / 2;
			return rect;
		}

		/**
		 * 另一种需求是将图片Resize后正好覆盖住容器，这样的尺寸叫做最小外切尺寸。（我比较懒，希望不用通过图片也能把问题说清楚）
		 * @param pImageW
		 * @param pImageH
		 * @param pBoxW
		 * @param pBoxH
		 * @return
		 */
		public static function getMinSize(pImageW : Number, pImageH : Number, pBoxW : Number, pBoxH : Number) : Rectangle
		{
			var rect : Rectangle = new Rectangle(0, 0, 10, 10);
			var rate : Number = pImageW / pImageH;
			var rateBox : Number = pBoxW / pBoxH;
			if (rate > rateBox)
			{
				rect.height = pBoxH;
				rect.width = pBoxH * rate;
			}
			else
			{
				rect.width = pBoxW;
				rect.height = pBoxW / rate;
			}
			rect.x = pBoxW / 2 - rect.width / 2;
			rect.y = pBoxH / 2 - rect.height / 2;
			return rect;
		}
	}
}
