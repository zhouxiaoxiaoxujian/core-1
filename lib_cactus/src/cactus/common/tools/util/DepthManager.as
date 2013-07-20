/**
 * Copyright (c) 2010 
 *
 *
 * @version
 **/
package cactus.common.tools.util
{

	import flash.display.*;


	/**
	 * 管理display object的深度，和游戏排序无关
	 * @author Peng
	 */
	public class DepthManager
	{

		/**
		 * 将mc设置到所有平级元件的最底层
		 * @param mc the mc to be set to bottom
		 * @see #isBottom()
		 */
		public static function bringToBottom(mc:DisplayObject):void
		{
			var parent:DisplayObjectContainer=mc.parent;

			if (parent == null)
			{
				return;
			}

			if (parent.getChildIndex(mc) != 0)
			{
				parent.setChildIndex(mc, 0);
			}
		}

		/**
		 * 将mc设置到所有平级元件的最上层
		 */
		public static function bringToTop(mc:DisplayObject):void
		{
			var parent:DisplayObjectContainer=mc.parent;

			if (parent == null)
				return;
			var maxIndex:int=parent.numChildren - 1;

			if (parent.getChildIndex(mc) != maxIndex)
			{
				parent.setChildIndex(mc, maxIndex);
			}
		}

		/**
		 * Returns is the mc is on the top depths in DepthManager's valid depths.
		 * Valid depths is that depths from MIN_DEPTH to MAX_DEPTH.
		 */
		public static function isTop(mc:DisplayObject):Boolean
		{
			var parent:DisplayObjectContainer=mc.parent;

			if (parent == null)
				return true;
			return (parent.numChildren - 1) == parent.getChildIndex(mc);
		}

		/**
		 * Returns if the mc is at bottom depth.
		 * @param mc the mc to be set to bottom
		 * @return is the mc is at the bottom
		 */
		public static function isBottom(mc:DisplayObject):Boolean
		{
			var parent:DisplayObjectContainer=mc.parent;

			if (parent == null)
				return true;
			var depth:int=parent.getChildIndex(mc);

			if (depth == 0)
			{
				return true;
			}
			return false;
		}

		/**
		 * Return if mc is just first bebow the aboveMC.
		 * if them don't have the same parent, whatever depth they has just return false.
		 */
		public static function isJustBelow(mc:DisplayObject, aboveMC:DisplayObject):Boolean
		{
			var parent:DisplayObjectContainer=mc.parent;

			if (parent == null)
				return false;

			if (aboveMC.parent != parent)
				return false;

			return parent.getChildIndex(mc) == parent.getChildIndex(aboveMC) - 1;
		}

		/**
		 * Returns if mc is just first above the belowMC.
		 * if them don't have the same parent, whatever depth they has just return false.
		 * @see #isJustBelow
		 */
		public static function isJustAbove(mc:DisplayObject, belowMC:DisplayObject):Boolean
		{
			return isJustBelow(belowMC, mc);
		}
	}

}