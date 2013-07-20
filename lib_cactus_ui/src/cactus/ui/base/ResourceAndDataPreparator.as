
package cactus.ui.base
{
	import cactus.ui.PUIConfig;
	import cactus.ui.data.IDataProxy;
	import cactus.ui.events.DataEvent;

	/**
	 * 资源和数据准备器
	 * @author Pengx
	 * @version 1.0
	 * @created 12-八月-2010 15:26:13
	 */
	public class ResourceAndDataPreparator
	{
	    private var _dataProxyArr:Array;
		private var _relateObjectArr:Array;
		
		private var _completeFun:Function;
		private var _errorFun:Function;

		public function ResourceAndDataPreparator(){
			_dataProxyArr = [];
			_relateObjectArr = [];			
		}

		public function destory():void
		{
			_dataProxyArr = [];
			_relateObjectArr = [];	
			_completeFun = null;
			_errorFun = null;
		}
		
	    /**
	     * 添加一个数据代理
	     * 
	     * @param dataProxy    数据代理
	     */
	    public function addDataProxy(dataProxy:IDataProxy): void
	    {
			_dataProxyArr.push(dataProxy);
			dataProxy.addEventListener(DataEvent.DATA_READY,onOneDataReady);
	    }
		
		private function onOneDataReady(e:DataEvent):void
		{
			//移除监听
			e.currentTarget.removeEventListener(DataEvent.DATA_READY,onOneDataReady);
			var index:int = _dataProxyArr.indexOf(e.currentTarget);
			_dataProxyArr.splice(index,1);
			if(_dataProxyArr.length == 0)
			{
				onDataReady();
			}
		}

	    /**
	     * 添加关联对象（一般是配置文件里面的string)
	     * 
	     * @param obj    关联对象
	     */
	    public function addRelateObject(obj:*): void
	    {
			// trace("准备素材",obj);
			_relateObjectArr.push(obj);
	    }

	    /**
	     * 全部开始准备
	     * 
	     * @param completeFun    完成函数
	     * @param errorFun    出错函数
	     */
	    public function prepareAll(completeFun:Function, errorFun:Function = null): void
	    {
			_completeFun = completeFun;
			_errorFun	 = errorFun;
			//先加载资源
			if(_relateObjectArr.length == 0)
			{
				// trace("全部加载完成");
				onResourceReady();
			}
			else
			{
				// trace("动态加载素材");
//				ResourceLoadHelper.loadByRelateObjectArr(_relateObjectArr,onResourceReady);
				PUIConfig.loadByRelateObjectArr.apply(null,[_relateObjectArr,onResourceReady]);
			}
	    }
		
		/**
		 * 资源加载完成
		 * 再加载数据 
		 * 
		 */
		private function onResourceReady():void
		{
			if(_dataProxyArr.length == 0)
			{
				onDataReady();
			}
			else
			{
				for(var i:int = 0 ; i < _dataProxyArr.length; i++)
				{
					IDataProxy(_dataProxyArr[i]).prepareReady();
				}
			}
		}
		
		/**
		 * 数据加载完成
		 * 调用完成函数 
		 * 
		 */
		private function onDataReady():void
		{
			_completeFun();
		}

	}//end ResourceAndDataPreparator

}