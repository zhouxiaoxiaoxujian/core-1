/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.tools.input
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class MouseManager
	{
		private static var st : Stage;
		/**鼠标是否按下*/
		public static var isMouseDown : Boolean;
		/**是否可以 追踪鼠标*/
		public static var isMouseTrackable : Boolean = true;
		/**鼠标在舞台上的坐标*/
		public static var mousePosition : Point = new Point(-1000, -1000);
		/**此时,鼠标下面的 显示对象数组*/
		public static var underMouseObjects : Array;

		public function MouseManager()
		{
			throw new Error("Static Class");
		}

		/**
		 * 开始 鼠标的监听工作
		 * */
		public static function startMouseListening(st : Stage) : void
		{
			MouseManager.st = st;
			st.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown, false, 0, true);
			st.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp, false, 0, false);
			st.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, 0, true);
			st.addEventListener(Event.DEACTIVATE, onDeactivate, false, 0, true);
			st.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, 0, true);
		}

		/**
		 * 停止 鼠标的监听工作
		 * */
		public static function stopMouseListening() : void
		{
			st.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
			st.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
			st.removeEventListener(Event.MOUSE_LEAVE, onMouseLeave);
			st.removeEventListener(Event.DEACTIVATE, onDeactivate);
			st.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			MouseManager.st = null;
		}

		/**
		 * 获取do2d上面的鼠标坐标
		 * */
		public static function getMousePosition(do2d : DisplayObject) : Point
		{
			return do2d.globalToLocal(mousePosition);
		}

		/**
		 * 获取 最顶层的 显示对象
		 * */
		public static function getTopsideDo2d(index : int = 1) : DisplayObject
		{
			var id : int = underMouseObjects.length - index;
			if (id < 0)
				id = 0;
			else if (id > underMouseObjects.length)
				id = underMouseObjects.length - 1;

			return underMouseObjects[id].parent;
		}

		/**
		 * 鼠标是否碰到 do2d的矩形区域
		 * */
		public static function collisionRect(do2d : DisplayObject) : Boolean
		{
			var rect : Rectangle = do2d.getRect(st);
			return rect.contains(st.mouseX, st.mouseY);
		}

		//////////////////
		//事件
		//////////////////
		private static function onStageMouseDown(e : MouseEvent) : void
		{
			isMouseDown = true;
			loop(e);
		}

		private static function onStageMouseUp(e : MouseEvent) : void
		{
			isMouseDown = false;
			loop(e);
		}

		private static function onMouseLeave(e : Event) : void
		{
			isMouseDown = false;
			isMouseTrackable = false;
		}

		private static function onDeactivate(e : Event) : void
		{
			onMouseLeave(e);
		}

		private static function onMouseMove(e : MouseEvent) : void
		{
			loop(e);
		}

		private static function loop(e : MouseEvent) : void
		{
			if (Math.abs(e.stageX) < 900000)
			{ /// Strage bug where totally bogus mouse positions are reported... ?
				mousePosition.x = e.stageX < 0 ? 0 : e.stageX > st.stageWidth ? st.stageWidth : e.stageX;
				mousePosition.y = e.stageY < 0 ? 0 : e.stageY > st.stageHeight ? st.stageHeight : e.stageY;
			}
			isMouseTrackable = true;

			underMouseObjects = st.getObjectsUnderPoint(new Point(st.mouseX, st.mouseY));
		}

	}
}
