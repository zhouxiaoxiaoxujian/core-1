package cactus.common.tools.util
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import cactus.common.Global;


	/**
	 * 全局事件管理器
	 * @author Peng
	 */
	public class EventBus extends EventDispatcher
	{
		private static var _instance:EventBus = new EventBus;

		public function EventBus()
		{
		}

		public static function getIns():EventBus
		{
			return _instance;
		}

		public function get stage():Stage
		{
			return Global.stage;
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			stage.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function dispatchEvent(event:Event):Boolean
		{
			return stage.dispatchEvent(event);
		}

		override public function hasEventListener(type:String):Boolean
		{
			return stage.hasEventListener(type);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			stage.removeEventListener(type, listener, useCapture);
		}

		override public function toString():String
		{
			return stage.toString();
		}

		override public function willTrigger(type:String):Boolean
		{
			return stage.willTrigger(type);
		}

	}
}
