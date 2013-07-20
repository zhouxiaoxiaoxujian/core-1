/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.dnd
{

	import flash.display.DisplayObject;

	/**
	 * 拖拽代理对象
	 * @author Peng
	 */
	public interface IDraggingImage
	{

		/**
		 * Returns the display object for the representation of dragging.
		 */
		function getDisplay():DisplayObject;

		/**
		 * Paints the image for accept state of dragging.(means drop allowed)
		 */
		function switchToAcceptImage():void;

		/**
		 * Paints the image for reject state of dragging.(means drop not allowed)
		 */
		function switchToRejectImage():void;
		
		
		// 对于两帧动画的处理，如墙壁
		/**
		 * Paints the image for accept state of dragging.(means drop allowed)
		 */
//		function switchToAcceptImage2():void;
		
		/**
		 * Paints the image for reject state of dragging.(means drop not allowed)
		 */
//		function switchToRejectImage2():void;
	}
}