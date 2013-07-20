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
	 * 拖拽观察者
	 * @author Peng
	 */
	public interface DragListener
	{

		/**
		 * When a drag action started.
		 * @param e the event.
		 * @see Component#isDragEnabled()
		 */
		function onDragStart(e:DragAndDropEvent):void;

		/**
		 * Called while a drag operation is ongoing, when the mouse pointer enters a
		 * drop trigger component area.
		 * @param e the event.
		 * @see Component#isDropTrigger()
		 */
		function onDragEnter(e:DragAndDropEvent):void;

		/**
		 * Called when a drag operation is ongoing(mouse is moving), while the mouse
		 * pointer is still over the entered component area.
		 * @param e the event.
		 * @see Component#isDropTrigger()
		 */
		function onDragOverring(e:DragAndDropEvent):void;

		/**
		 * Called while a drag operation is ongoing, when the mouse pointer has exited
		 * the entered a drop trigger component.
		 * @param e the event.
		 * @see Component#isDropTrigger()
		 */
		function onDragExit(e:DragAndDropEvent):void;

		/**
		 * Called when drag operation finished.
		 * <p>
		 * Generally if you want to do a custom motion of the dragging movie clip when
		 * dropped, you may call the DragManager.setDropMotion() method to achieve.
		 * </p>
		 * @param e the event.
		 * @see Component#isDropTrigger()
		 * @see org.aswing.dnd.DragManager#setDropMotion()
		 */
		function onDragDrop(e:DragAndDropEvent):void;

	}
}