/**
 *
 *@author <a href="mailto:Pengxu.he@happyelements.com">Peng</a>
 *@version $Id: IPTileListRenderer.as 115190 2012-12-19 03:01:32Z pengxu.he $
 *
 **/
package cactus.ui.control
{
	import flash.events.IEventDispatcher;

	/**
	 * PTileList中的渲染组件
	 * @author: Peng
	 */
	public interface IPTileListRenderer extends IEventDispatcher
	{

		function get x():Number;

		function set x(value:Number):void;

		function get y():Number;

		function set y(value:Number):void;

		function get width():Number;

		function get height():Number;

		function set data(value:Object):void
		function get data():Object;
		function set visible(value:Boolean):void

		/**
		 * 获得该Renderer所属的PTileList
		 * @return
		 */
		function get master():PTileList;
		function set master(value:PTileList):void;

		/**
		 * 获得Renderer在PTileList中的索引号
		 * @return	如果没有该Renderer，返回-1
		 */
		function getRenderIndex():int

		/**
		 * 获得Renderer的数据在PTileList中的索引号
		 * @return 如果没有该Data，返回-1
		 */
		function getDataIndex():int
	}
}
