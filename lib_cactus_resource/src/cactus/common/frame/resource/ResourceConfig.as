package cactus.common.frame.resource
{
	/**
	 * 资源框架配置 
	 * @author Pengx
	 * 
	 */
	public class ResourceConfig
	{
		/**
		 * 加载失败重试次数
		 * 指定某个资源加载失败的情况下会重试几次 
		 */
		public static var RETRY_TIME:uint = 3;
		
		/**
		 * 是否使用队列单线加载
		 * 如果为true,使用队列加载，加载速度会慢一点并且不能获取精确的整体进度。
		 * 如果为false,加载时指定的列表资源会同时加载。
		 */
		public static var USE_QUEUE:Boolean = true;
	}
}