package cactus.common.frame.resource.interfaces
{
	import cactus.common.frame.resource.ResourceVO;

	/**
	 * 资源加载功能接口 
	 * @author Pengx
	 * 
	 */
	public interface IAssetLoad
	{
		/**
		 * 获取加载的数据
		 * @param vo	资源结构体
		 * @return 
		 * 
		 */
		function getData(vo:ResourceVO):*;
		
		/**
		 * 加载 
		 * @param loadList		加载列表
		 * @param completeFun	加载完成回调函数
		 * 
		 */
		function load(loadList:Vector.<ResourceVO>,completeFun:Function = null):void;
		
		/**
		 * 卸载 
		 * @param loadList	卸载列表
		 * 
		 */
		function unload(loadList:Vector.<ResourceVO>):void;
		
		/**
		 * 加载的字节数 
		 * @param loadList	加载列表
		 * @return 
		 * 
		 */
		function getBytesLoaded(loadList:Vector.<ResourceVO>):uint;

		/**
		 * 预计总字节数 
		 * @param loadList	加载列表
		 * @return 
		 * 
		 */
		function getBytesTotal(loadList:Vector.<ResourceVO>):uint;
		
		/**
		 * 加载进度(0~1) 
		 * @param loadList	加载列表
		 * @return 
		 * 
		 */
		function getProgress(loadList:Vector.<ResourceVO>):Number;
	}
}