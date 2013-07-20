/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.interfaces
{

	/**
	 * 舞台显示对象接口
	 * @author Peng
	 */
	public interface IDisplayObject
	{
		function get x() : Number;

		function set x(value : Number) : void;

		function get y() : Number;

		function set y(value : Number) : void;
	}
}
