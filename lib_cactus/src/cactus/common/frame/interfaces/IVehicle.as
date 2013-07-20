/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.interfaces
{
	import cactus.common.xx.goem.Vector2D;

	/**
	 * 机车接口
	 * 2D平面内的活动对象
	 * @author Peng
	 */
	public interface IVehicle extends IDisplayObject
	{
		function set velocity(value:Vector2D):void;

		function get velocity():Vector2D;

		function set position(value:Vector2D):void

		function get position():Vector2D
	}
}
