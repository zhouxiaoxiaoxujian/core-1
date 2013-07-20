/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 * @create		2010-8-19 上午11:40:57
 * @update		暂时不用
 **/
package cactus.common.tools.dnd
{
	import flash.display.Sprite;

	public class DropabelSprite extends Sprite implements IDropable
	{
		public function DropabelSprite()
		{
			super();
		}

		/**
		 * @private
		 * Fires ON_DRAG_ENTER event.(Note, this method is only for DragManager use)
		 */
		public function fireDragEnterEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint,relatedTarget:IDropable):void
		{
			trace("fireDragEnterEvent");
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_ENTER,dragInitiator,sourceData,mousePos,this,relatedTarget));
		}

		/**
		 * @private
		 * Fires DRAG_OVERRING event.(Note, this method is only for DragManager use)
		 */
		public function fireDragOverringEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint):void
		{
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_OVERRING,dragInitiator,sourceData,mousePos,this));
		}

		/**
		 * @private
		 * Fires DRAG_EXIT event.(Note, this method is only for DragManager use)
		 */
		public function fireDragExitEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint,relatedTarget:IDropable):void
		{
			trace("fireDragExitEvent");
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT,dragInitiator,sourceData,mousePos,this,relatedTarget));
		}

		/**
		 * @private
		 * Fires DRAG_DROP event.(Note, this method is only for DragManager use)
		 */
		public function fireDragDropEvent(dragInitiator:IDragable,sourceData:SourceData,mousePos:IntPoint):void
		{
			trace("fireDragDropEvent");
			dispatchEvent(new DragAndDropEvent(DragAndDropEvent.DRAG_DROP,dragInitiator,sourceData,mousePos,this));
		}
		
		public function get dropPriority():int
		{
			return 1;
		}
	}
}