package cactus.common.frame.resource.helper
{
	import cactus.common.frame.resource.ResourceConfig;
	import cactus.common.frame.resource.ResourceMap;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	/**
	 * 配置文件加载和自动适配器 
	 * @author Pengx
	 * 
	 */
	public class ResourceConfigLoadHelper
	{
		private static var _urlLoader:URLLoader;
		private static var _url:String;
		private static var _completeFun:Function;
		private static var _errorFun:Function
		
		private static var _config:XML;
		private static var _retryTime:int = ResourceConfig.RETRY_TIME;
		
		public function ResourceConfigLoadHelper()
		{
		}
		

		/**
		 * 加载配置文件(txt,xml格式判定为文本加载，其他格式判定为压缩后的二进制加载)
		 * @param url			链接地址
		 * @param completeFun	完成调用函数
		 * @param errorFun		加载失败调用函数
		 * 
		 */
		public static function load(url:String,completeFun:Function,errorFun:Function):void
		{
			_retryTime 		= ResourceConfig.RETRY_TIME;
			_url 			= url;
			_completeFun 	= completeFun;
			_errorFun  		= errorFun;
			doLoad();
		}
		
		/**
		 * 获得配置文件 
		 * @return 
		 * 
		 */
		public static function get config():XML
		{
			return _config.copy();
		}
		
		private static function doLoad():void
		{
			_urlLoader = new URLLoader();
			if(ifBinary())
			{
				_urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			}
			_urlLoader.addEventListener(Event.COMPLETE,onLoadComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
			_urlLoader.load(new URLRequest(_url));
		}
		
		private static function ifBinary():Boolean
		{
			var type:String = _url.slice(_url.lastIndexOf(".") + 1);
			if(type == "txt" || type == "xml")
			{
				return false;
			}
			return true;
		}
		
		private static function onLoadComplete(e:Event):void
		{
			if(ifBinary())
			{
				var bytes:ByteArray = e.currentTarget.data as ByteArray;
				bytes.uncompress();
				//解析
				_config = new XML(bytes);
			}
			else
			{
				_config = new XML(e.currentTarget.data);
			}
			var resoursePath:String = _config.resourcePath.attribute("root").toString();
			//trace(_config);
			var resourceList:XMLList = _config.resources.resource;
			var resItem:XML;
			var resName:String;
			var resSrc:String;
			var resType:String;
			var resWeight:String;
			var resRelateList:Array
			for each(resItem in resourceList) 
			{
				resName 	= resItem.attribute("name");
				resSrc 		= resoursePath + resItem.attribute("src");
				resType 	= resItem.attribute("type");
				resWeight   = resItem.attribute("weight");
				resRelateList 	= String(resItem.attribute("relateList")).split(",");
				
				//添加到Map
				ResourceMap.getInstance().addResourceVO(resName,resType,resSrc,resRelateList,int(resWeight));
			}
			//调用完成函数
			_completeFun();
			_completeFun = null;
			_errorFun = null;
		}
		
		private static function onLoadError(e:Event):void
		{
			if(_retryTime > 0)
			{
				_retryTime--;
				doLoad();
			}
			else
			{
				//调用错误函数
				_errorFun();
				_completeFun = null;
				_errorFun = null;
			}
		}
	}
}