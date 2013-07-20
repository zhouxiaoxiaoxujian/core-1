/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.dnd
{
	
	import flash.display.Sprite;
	import flash.display.Stage;
	
	/**
	 * 可拖动元素的接口
	 * @author Pengx
	 *
	 * modify by Peng
	 *
	 */
	public interface IDragable
	{
		/**
		 * 开始拖动
		 */
		function dragStart(event:DragAndDropEvent):void;
		
		/**
		 * 完成拖动
		 */
		function dragComplete(event:DragAndDropEvent):void;
		
		/**
		 * 拖动携带数据
		 * @return
		 *
		 */
		function getDragData():*;
		
		/**
		 * 拖动显示代理
		 * @return
		 *
		 */
		function getDragProxy():Sprite;
		
	}
}