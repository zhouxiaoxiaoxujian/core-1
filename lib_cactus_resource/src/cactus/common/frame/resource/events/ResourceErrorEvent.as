package cactus.common.frame.resource.events
{
	import cactus.common.frame.resource.ResourceVO;
	
	import flash.events.Event;
	
	/**
	 * 资源出错事件 
	 * @author Pengx
	 * 
	 */
	public class ResourceErrorEvent extends Event
	{
		/**
		 * 加载失败 
		 */
		public static const LOAD_ERROR:String = "load_error";
		
		/**
		 * 出错的资源结构体 
		 */
		public var vo:ResourceVO;
		
		/**
		 * 关联的事件 
		 */
		public var relateEvent:Event;
		
		/**
		 * 关联错误 
		 */
		public var relateError:Error;
		
		/**
		 * 携带的数据 
		 */
		public var data:*;
				
		
		/**
		 * 
		 * @param type
		 * @param vo			资源结构体
		 * @param relateEvent	关联的事件 
		 * @param relateError	关联的错误
		 * @param data			携带的数据 
		 * 
		 */
		public function ResourceErrorEvent(type:String, vo:ResourceVO, relateEvent:Event, relateError:Error = null, data:* = null)
		{
			super(type);
			this.vo 			= vo;
			this.relateEvent 	= relateEvent;
			this.relateError	= relateError;
			this.data 			= data;
		}
		
		override public function clone():Event
		{
			return new ResourceErrorEvent(this.type,this.vo,this.relateEvent,this.data);
		}
		
		override public function toString():String
		{
			return "[ResourceErrorEvent type=" + this.type + " vo=" + vo.toString() + " data=" + this.data + "]";
		}
	}
}