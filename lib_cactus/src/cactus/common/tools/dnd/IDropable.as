/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.dnd
{

	/**
	 * 可以释放对象的地方
	 * @author Peng
	 */
	public interface IDropable
	{
		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		function fireDragEnterEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint,relatedTarget:IDropable):void
		/**
		 * @private
		 * Fires DRAG_OVERRING event.(Note, this method is only for DragManager use)
		 */
		function fireDragOverringEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint):void
		/**
		 * @private
		 * Fires DRAG_EXIT event.(Note, this method is only for DragManager use)
		 */
		function fireDragExitEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint,relatedTarget:IDropable):void
		/**
		 * @private
		 * Fires DRAG_DROP event.(Note, this method is only for DragManager use)
		 */
		function fireDragDropEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint):void

		/**
		 * 获得拖放优先级，数值越高，越先触发
		 * @return 
		 */
		function get dropPriority():int;
	}
}