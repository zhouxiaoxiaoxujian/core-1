package cactus.common.frame.resource.events
{
	import cactus.common.frame.resource.ResourceVO;
	
	import flash.events.Event;

	/**
	 * 单个资源加载成功事件 
	 * @author Pengx
	 * 
	 */
	public class ResourceLoadEvent extends Event
	{
		/**
		 * 加载完成 
		 */
		public static const LOAD_COMPLETE:String = "load_complete";
		
		/**
		 * 加载的资源结构体 
		 */
		public var vo:ResourceVO;
		
		/**
		 * 
		 * @param type
		 * @param vo			资源结构体
		 * 
		 */
		public function ResourceLoadEvent(type:String, vo:ResourceVO)
		{
			super(type);
			this.vo 			= vo;
		}
		
		override public function clone():Event
		{
			return new ResourceLoadEvent(this.type,this.vo);
		}
		
		override public function toString():String
		{
			return "[ResourceLoadEvent type=" + this.type + " vo=" + vo.toString() + "]";
		}
	}
}