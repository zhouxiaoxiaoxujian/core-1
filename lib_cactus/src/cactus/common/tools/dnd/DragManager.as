/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.dnd
{
	import cactus.common.Global;
	import cactus.common.tools.util.ArrayUtils;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.geom.*;

	/**
	 * 通用拖拽管理器
	 *
	 * DropAt的容器必须实现IDropable接口，重叠的容器根据拖拽优先级确定响应目标，即只响应优先级最高的目标事件。
	 *
	 * @author Peng
	 */
	public class DragManager
	{

		public static var DROP_PRIORITY_NIGHTCLUB:int=1;
		public static var DROP_PRIORITY_CHOOSER_BG:int=4;
		public static var DROP_PRIORITY_CHOOSER_LIGHTEN_HOLE:int=5;
		public static var DROP_PRIORITY_SENDBUTTON:int=8
		public static var DROP_PRIORITY_SELLBUTTON:int=8;
		public static var DROP_PRIORITY_NOVICE_GUIDE:int=100;

		/*
		   public static var TYPE_NONE:Number=0;
		   public static var TYPE_MOVE:Number=1;
		   public static var TYPE_COPY:Number=2;

		   public static var DEFAULT_DROP_MOTION:DropMotion=new DirectlyRemoveMotion();
		   public static var DEFAULT_REJECT_DROP_MOTION:DropMotion=new RejectedMotion();
		 */
		private static var s_isDragging:Boolean=false;

		private static var s_dragListener:DragListener;
		private static var s_dragInitiator:IDragable;
		private static var s_sourceData:SourceData;
		private static var s_dragImage:IDraggingImage;

		private static var root:DisplayObjectContainer=null;
		//		private static var dropMotion:DropMotion;
		//		private static var runningMotion:DropMotion;
		private static var dragProxyMC:Sprite;
		private static var mouseOffset:IntPoint;
		private static var enteredComponent:IDropable;

		private static var listeners:Array=new Array();
		private static var curStage:Stage;

		/**
		 * Sets the container to hold the draging image(in fact it will hold the image's parent--a sprite).
		 * By default(if you have not set one), it will be the <code>AsWingManager.getRoot()</code> value.
		 * @param theRoot the container to hold the draging image.
		 * @see org.aswing.AsWingManager#getRoot()
		 */
		public static function setDragingImageContainerRoot(theRoot:DisplayObjectContainer):void
		{
			root=theRoot;
		}

		/**
		 * startDrag(dragInitiator:Component, dragSource, dragImage:MovieClip, lis:DragListener)<br>
		 * startDrag(dragInitiator:Component, dragSource, dragImage:MovieClip)<br>
		 * startDrag(dragInitiator:Component, dragSource)<br>
		 * <p>
		 * Starts dragging a initiator, with dragSource, a dragging Image, and a listener. The drag action will be finished
		 * at next Mouse UP/Down Event(Mouse UP or Mouse Down, generally you start a drag when mouse down, then it will be finished
		 * when mouse up, if you start a drag when mouse up, it will be finished when mouse down).
		 *
		 * @param dragInitiator the dragging initiator
		 * @param sourceData the data source will pass to the listeners and target components
		 * @param dragImage (optional)the image to drag, default is a rectangle image. if null , create default a new Sprite
		 * @param dragListener (optional)the listener added to just for this time dragging action, default is null(no listener)
		 */
		public static function startDrag(dragInitiator:IDragable, sourceData:SourceData, dragImage:IDraggingImage=null, dragListener:DragListener=null, doubleMode:Boolean=true):void
		{
			if (s_isDragging)
			{
				//				throw new Error("The last dragging action is not finished, can't start a new one!");
				return;
			}
			var stage:Stage=Global.stage;
			if (stage == null)
			{
				throw new Error("The drag initiator is not on stage!");
				return;
			}

			curStage=stage;
			if (dragImage == null)
			{
				dragImage=new DefaultDraggingImage(dragInitiator.getDragProxy());
			}

			s_isDragging=true;
			s_dragInitiator=dragInitiator;
			s_sourceData=sourceData;
			s_dragImage=dragImage;
			s_dragListener=dragListener;

			if (s_dragListener != null)
			{
				addDragListener(s_dragListener);
			}
			/*			if (runningMotion)
			   {
			   runningMotion.forceStop();
			   runningMotion=null;
			 }*/
			var container:DisplayObjectContainer=stage;
			if (dragProxyMC == null)
			{
				dragProxyMC=new Sprite();
				dragProxyMC.mouseEnabled=false;
				dragProxyMC.name="drag_image";
			}
			else
			{
				if (dragProxyMC.parent != null)
				{
					dragProxyMC.parent.removeChild(dragProxyMC);
				}
			}
			if (dragProxyMC.numChildren > 0)
			{
				dragProxyMC.removeChildAt(0);
			}
			container.addChild(dragProxyMC);

			// 鼠标当前位置
			var globalPos:IntPoint=new IntPoint(Global.stage.mouseX, Global.stage.mouseY);
			var dp:Point=globalPos.toPoint();
			dragProxyMC.x=dp.x;
			dragProxyMC.y=dp.y;

			//			dragProxyMC.mouseChildren =false;
			//			dragProxyMC.mouseEnabled = false;
			dragProxyMC.addChild(dragImage.getDisplay());
			dragProxyMC.startDrag(false);
			dragProxyMC.visible=true;

			mouseOffset=new IntPoint(container.mouseX - dp.x, container.mouseY - dp.y);
			fireDragStartEvent(s_dragInitiator, s_sourceData, globalPos);

			enteredComponent=null;

			//initial image
			s_dragImage.switchToRejectImage();

			__onMouseMoveOnStage(stage);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown, false, 0, true);

//			if (doubleMode)
//				setTimeout(Delegate.create(lazyMouseUp, stage), 100);
//			else
				stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp /*,false,0,true*/)
		}

		public static function restartLastDrag():void
		{
			startDrag(s_dragInitiator,s_sourceData,s_dragImage,s_dragListener);
		}
		
		
		
		
		public static function drop():void
		{
			if (dragProxyMC)
			{
				dragProxyMC.stopDrag();
				dragProxyMC.visible=false;
			}
			
			var globalPos:IntPoint=new IntPoint(Global.stage.mouseX, Global.stage.mouseY);
			var stage:Stage=curStage;
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			}
			s_isDragging=false;
			
			/*			if (enteredComponent != null)
			{
			setDropMotion(DEFAULT_DROP_MOTION);
			}
			else
			{
			setDropMotion(DEFAULT_REJECT_DROP_MOTION);
			}*/
			
			fireDragDropEvent(s_dragInitiator, s_sourceData, globalPos, enteredComponent);
			if (enteredComponent != null)
			{
				enteredComponent.fireDragDropEvent(s_dragInitiator, s_sourceData, globalPos);
			}
			/*  runningMotion=dropMotion;
			runningMotion.startMotionAndLaterRemove(s_dragInitiator,dragProxyMC);*/
			
			if (s_dragListener != null)
			{
				removeDragListener(s_dragListener);
			}
			//			curStage=null;
			//			s_dragImage=null;
			//			s_dragListener=null;
			//			s_sourceData=null;
			//			enteredComponent=null;
		}
		
		/**
		 * 取消当前拖拽
		 */
		public static function cancel():void
		{
			if (dragProxyMC)
			{
				dragProxyMC.stopDrag();
				dragProxyMC.visible=false;
			}
			
			var globalPos:IntPoint=new IntPoint(Global.stage.mouseX, Global.stage.mouseY);
			var stage:Stage=curStage;
			if (stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
				stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
			}
			s_isDragging=false;
			
			if (s_dragListener != null)
			{
				removeDragListener(s_dragListener);
			}
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		private static function lazyMouseUp(stage:Stage):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp /*,false,0,true*/)
		}

		/**
		 * Adds a drag listener to listener list.
		 * @param lis the listener to be add
		 */
		public static function addDragListener(lis:DragListener):void
		{
			listeners.push(lis);
		}

		/**
		 * Removes the specified listener from listener list.
		 * @param lis the listener to be removed
		 */
		public static function removeDragListener(lis:DragListener):void
		{
			ArrayUtils.removeFromArray(listeners, lis);
		}

		/**
		 * Sets the motion of drag movie clip when a drop acted.
		 * <p>
		 * Generally if you want to do a custom motion of the dragging movie clip when dropped, you may
		 * call this method in the listener's <code>onDragDrop()</code> method.
		 * <p>
		 * Every drop acted, the default motion will be set to <code>DirectlyRemoveMotion</code>
		 * so you need to set to yours every drop time if you want.
		 * @param motion the motion
		 * @see org.aswing.dnd.DropMotion
		 * @see org.aswing.dnd.DirectlyRemoveMotion
		 * @see org.aswing.dnd.RejectedMotion
		 * @see org.aswing.dnd.DragListener#onDragDrop()
		 */
		/*		public static function setDropMotion(motion:DropMotion):void
		   {
		   if (motion == null)
		   motion=DEFAULT_DROP_MOTION;
		   dropMotion=motion;
		 }*/

		/**
		 * Returns the drag image.
		 */
		public static function getCurrentDragImage():IDraggingImage
		{
			return s_dragImage;
		}
		
		/**
		 * 获得拖拽显示对象的真正容器
		 * 
		 * 注意，被拖拽对象的getDragProxy最终是放在了dragProxyMC中的
		 * @return 
		 */
		public static function getCurrentDragProxyMC():Sprite
		{
			return dragProxyMC;
		}

		/**
		 * Returns current drop target of dragging components by startDrag method.
		 * @return the drop target
		 * @see #startDrag()
		 * @see #getDropTarget()
		 */
		public static function getCurrentDropTarget():IDropable
		{
			return getDropTarget(curStage);
		}

		/**
		 * Returns current drop target component of specified position.
		 * @param pos the global point
		 * @return the drop target component
		 * @see #startDrag()
		 * @see #getDropTargetComponent()
		 */
		public static function getDropTargetComponent(pos:Point=null):IDropable
		{
			return getDropTarget(curStage, pos, IDropable) as IDropable;
		}

		/**
		 * Returns current drop target component of dragging components by startDrag method.
		 * @return the drop target component
		 * @see #startDrag()
		 * @see #getDropTargetComponent()
		 */
		/*		public static function getCurrentDropTargetComponent():Component
		   {
		   return getDropTarget(curStage,null,Component) as Component;
		 }*/

		/**
		 * Returns drop target drop trigger component of specified global position.
		 * @param pos the point
		 * @return the drop target drop trigger component
		 * @see #startDrag()
		 * @see #getDropTargetDropTriggerComponent()
		 */
		/*		public static function getDropTragetDropTriggerComponent(pos:Point=null):Component
		   {
		   return getDropTarget(curStage,pos,Component,____dropTargetCheck) as Component;
		 }*/

		/**
		 * Returns current drop target drop trigger component of dragging components by startDrag method.
		 * @return the drop target drop trigger component
		 * @see #startDrag()
		 * @see #getDropTargetDropTriggerComponent()
		 */
		public static function getCurrentDropTargetDropTriggerComponent():IDropable
		{
			return getDropTarget(curStage, null, IDropable, null) as IDropable;
			//			return getDropTarget(curStage,null,IDropable,____dropTargetCheck) as IDropable;
		}

		/*		private static function ____dropTargetCheck(tar:Component):Boolean
		   {
		   return tar.isDropTrigger();
		 }*/

		/**
		 * Returns the drop target of specified position and specified class type.
		 * For example:<br/>
		 * <pre>
		 * getDropTarget(new Point(0, 0), TextField);
		 * will return the first textfield insance under the point, or null if not found.
		 *
		 * getDropTarget(null, null);
		 * will return the first display object insance under the current mouse point, or null if not found.
		 * </pre>
		 * @param stage the stage where the drop target should be in
		 * @param pos The point under which to look, in the coordinate space of the Stage.
		 * @param targetType the class type of the target, default is null, means any display object.
		 * @param addtionCheck, a check function, only return the target when function(target:DisplayOject) return true.
		 * default is null, means no this check.
		 * @return drop target
		 */
		public static function getDropTarget(stage:Stage, pos:Point=null, targetType:Class=null, addtionCheck:Function=null):IDropable
		{
			if (stage == null)
			{
				return null;
			}
			if (pos == null)
			{
				pos=new Point(stage.mouseX, stage.mouseY);
			}
			if (targetType == null)
			{
				targetType=DisplayObject;
			}
			if (addtionCheck == null)
			{

			}
			var targets:Array=stage.getObjectsUnderPoint(pos);
			var startIndex:int=targets.length - 1;

			try
			{
				// 处理复杂动画，减少层次
				while (targets[startIndex] == dragProxyMC || dragProxyMC.contains(targets[startIndex]))
				{
					startIndex--;
				}
			}
			catch (e:Error)
			{
				trace("targets: " + targets.toString());
			}

//			 trace(" 可以的长度：" + findTargets(targets).length + "  ---->" + "end " + targets);
			// 从一个数组中，找到优先级最高的DropTarget
			//			var dropTarget:IDropable=findDropTarget(targets[startIndex]);
			var dropTarget:IDropable=findHightestTarget(targets);
			return dropTarget;
		}

		// 从findTargets的结果中找到优先级最高的物品
		private static function findHightestTarget(targetArray:Array):IDropable
		{
			var array:Array=findTargets(targetArray);
			if (array.length == 0)
				return null;

			array.sortOn("dropPriority", Array.NUMERIC);
//			trace("findHightestTarget array: "+array);
			return array[array.length - 1];
		}

		// 寻找鼠标下，所有IDropable的点
		private static function findTargets(targetArray:Array):Array
		{
			var result:Array=[];
			for (var i:int=0; i < targetArray.length; i++)
			{
				var findItem:IDropable=findDropTarget(targetArray[i]);
				if (findItem && result.indexOf(findItem) == -1)
				{
					// 只加入没有重复的项目
					result.push(findItem);
//					trace("IDropable implements: "+findItem);
				}
			}

			return result;
		}

		// 寻找单个点下的可以被放下的组件
		private static function findDropTarget(target:*):IDropable
		{
			if (target == null)
				return null;

			if (target is IDropable)
			{
				return target;
			}
			else if (target.hasOwnProperty("master")) // 从MovieClip索引UIObject
			{
				if (target.master is IDropable)
				{
					return target.master;
				}
				else
				{
					return findDropTarget(target.parent)
				}
			}
			else
			{
				return (target == undefined) ? null : findDropTarget(target.parent);
			}
		}

		//---------------------------------------------------------------------------------

		private static function __onMouseMoveOnStage(stage:Stage):void
		{
			onMouseMove(stage.mouseX, stage.mouseY);
		}

		// 真正的onMouseMove
		private static function onMouseMove(mx:Number, my:Number):void
		{
			var globalPos:IntPoint=new IntPoint(mx, my);
			var dropC:IDropable=getCurrentDropTargetDropTriggerComponent();
			//trace("dropC: "+dropC+"  enteredComponent:"+enteredComponent);
			// 进入新的可放下区域
			if (dropC != enteredComponent)
			{
				// 退出前一个
				if (enteredComponent != null)
				{
					s_dragImage.switchToRejectImage();
					fireDragExitEvent(s_dragInitiator, s_sourceData, globalPos, enteredComponent, dropC);
					enteredComponent.fireDragExitEvent(s_dragInitiator, s_sourceData, globalPos, dropC);
				}
				if (dropC != null)
				{
					// del 判断是否可以接受目标
					s_dragImage.switchToAcceptImage();
					fireDragEnterEvent(s_dragInitiator, s_sourceData, globalPos, dropC, enteredComponent);
					dropC.fireDragEnterEvent(s_dragInitiator, s_sourceData, globalPos, enteredComponent);
				}
				enteredComponent=dropC;
			}
			// 仍然在原区域 
			else
			{
				if (enteredComponent != null)
				{
					fireDragOverringEvent(s_dragInitiator, s_sourceData, globalPos, enteredComponent);
					enteredComponent.fireDragOverringEvent(s_dragInitiator, s_sourceData, globalPos);
				}
			}

		}

		private static function __onMouseMove(e:MouseEvent):void
		{
			onMouseMove(e.stageX, e.stageY);
		}

		private static function __onMouseUp(e:MouseEvent):void
		{
			drop();
		}

		private static function __onMouseDown(e:MouseEvent):void
		{
			//			drop();
			//why call drop again when mouse down?
			//just because if you released mouse outside of flash movie, then the mouse up
			//was not triggered. So if that happened, when user reclick mouse, the drop will 
			//fire (the right behavor to ensure dragging thing was dropped).
			//Well, if user released mouse rightly in the flash movie, then the drop be called, 
			//and in drop method, the mouse listener was removed, so it will not be called drop 
			//again when next mouse down. :)
		}



		private static function fireDragStartEvent(dragInitiator:IDragable, sourceData:SourceData, pos:IntPoint):void
		{
			var e:DragAndDropEvent=new DragAndDropEvent(DragAndDropEvent.DRAG_START, dragInitiator, sourceData, pos);
			for (var i:int=0; i < listeners.length; i++)
			{
				var lis:DragListener=listeners[i];
				lis.onDragStart(e);
			}
		}

		private static function fireDragEnterEvent(dragInitiator:IDragable, sourceData:SourceData, pos:IntPoint, targetComponent:IDropable, relatedTarget:IDropable):void
		{
			var e:DragAndDropEvent=new DragAndDropEvent(DragAndDropEvent.DRAG_ENTER, dragInitiator, sourceData, pos, targetComponent, relatedTarget);
			for (var i:int=0; i < listeners.length; i++)
			{
				var lis:DragListener=listeners[i];
				lis.onDragEnter(e);
			}
		}

		private static function fireDragOverringEvent(dragInitiator:IDragable, sourceData:SourceData, pos:IntPoint, targetComponent:IDropable):void
		{
			var e:DragAndDropEvent=new DragAndDropEvent(DragAndDropEvent.DRAG_OVERRING, dragInitiator, sourceData, pos, targetComponent);
			for (var i:int=0; i < listeners.length; i++)
			{
				var lis:DragListener=listeners[i];
				lis.onDragOverring(e);
			}
		}

		private static function fireDragExitEvent(dragInitiator:IDragable, sourceData:SourceData, pos:IntPoint, targetComponent:IDropable, relatedTarget:IDropable):void
		{
			var e:DragAndDropEvent=new DragAndDropEvent(DragAndDropEvent.DRAG_EXIT, dragInitiator, sourceData, pos, targetComponent, relatedTarget);
			for (var i:int=0; i < listeners.length; i++)
			{
				var lis:DragListener=listeners[i];
				lis.onDragExit(e);
			}
		}

		private static function fireDragDropEvent(dragInitiator:IDragable, sourceData:SourceData, pos:IntPoint, targetComponent:IDropable):void
		{
			var e:DragAndDropEvent=new DragAndDropEvent(DragAndDropEvent.DRAG_DROP, dragInitiator, sourceData, pos, targetComponent);
			for (var i:int=0; i < listeners.length; i++)
			{
				var lis:DragListener=listeners[i];
				lis.onDragDrop(e);
			}
		}
	}
}