/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 * @create		2010-8-19 下午02:19:45
 * @update
 **/
package cactus.common.tools.dnd
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;

	/**
	 * 拖拽代理默认实现
	 * @author Peng
	 */
	public class DefaultDraggingImage implements IDraggingImage
	{
		private var _display:DisplayObject; // 默认面朝西南

		public function DefaultDraggingImage(display:DisplayObject = null /*,display2:DisplayObject=null*/)
		{
			if (!display)
				_display = new Sprite
			else
				_display = display;

			// 新增物件时 的偏移量
//			_display.y = Core.DRAG_OFFSET_Y;
		}

		public function getDisplay():DisplayObject
		{
			return _display;
		}

		public function switchToAcceptImage():void
		{
//			_display.transform.colorTransform = ObjectPoolFactory.createDefaultColorTransformWhenMove();
		}

		public function switchToRejectImage():void
		{
//			_display.transform.colorTransform = ObjectPoolFactory.createRedColorTransform();
		}

	}
}