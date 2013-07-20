///////////////////////////////////////////////////////////
//  DataManager.as
//  Macromedia ActionScript Implementation of the Class DataManager
//  Generated by Enterprise Architect
//  Created on:      11-八月-2010 14:51:59
//  Original author: Pengx
///////////////////////////////////////////////////////////

package cactus.ui.data
{
	import flash.utils.Dictionary;
	
	/**
	 * 数据代理管理器
	 * 负责统一返回实现IDataProxy接口的数据
	 * 在内部切换真实和模拟数据累
	 * @author Pengx
	 * @version 1.0
	 * @created 11-八月-2010 14:51:59
	 */
	public class DataProxyMap
	{
		//单例引用
		private static var _instance:DataProxyMap;
		
		private var _dic:Dictionary;
		
		public function DataProxyMap(param:SingletonEnforcer){
			_dic = new Dictionary();
		}
		
		/**
		 * 单例 
		 * @return 
		 * 
		 */
		public static function getInstance():DataProxyMap
		{
			if(_instance==null)
			{
				_instance = new DataProxyMap(new SingletonEnforcer());	
			}
			return _instance;
		}
		
//		public function getResourceProxy():IResourceDataProxy
//		{
//			return buildProxy(ResourceDataProxy);
//		}
		
		/**
		 * 构建代理 
		 * @param proxyClass	代理类
		 * @return 
		 * 
		 */
		private function buildProxy(proxyClass:Class):*
		{
			if(_dic[proxyClass] == null)
			{
				_dic[proxyClass] = new proxyClass();
			}
			return _dic[proxyClass];
		}
		
		
	}//end DataManager
}
class SingletonEnforcer{};