package peng.common
{
	import peng.common.platform.PlatformAdapter;

	public class DCPointFactory
	{
		public function DCPointFactory()
		{
		}


		protected static function createDCPoint():DCPoint
		{
			return new DCPoint();
		}

	}
}
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.Dictionary;

import cactus.common.Global;

class DCPoint
{
	private var _params:Dictionary = new Dictionary();

	/**
	 *
	 * @param key
	 * @param value
	 * @return
	 */
	public function put(key:String, value:String):DCPoint
	{
		_params[key] = value;
		return this;
	}

	/**
	 * 发送请求
	 */
	public function send():void
	{
//		var loader:URLLoader = new URLLoader();
//		var req:URLRequest = new URLRequest();
//		req.url = Global.dataCenterURL;
//		req.method = URLRequestMethod.POST;
//
//		var uvb:URLVariables = new URLVariables();
//		for (var key:String in _params)
//		{
//			uvb[key] = _params[key];
//		} 
//		req.data = uvb;
//		loader.addEventListener(Event.COMPLETE, onComplete);
//		loader.addEventListener(IOErrorEvent.IO_ERROR,onError);
//		loader.load(req);
//
//
//		function onComplete(event:Event):void
//		{
//			loader.removeEventListener(Event.COMPLETE, onComplete);
//			trace("request onComplete", loader.data); 
//		}
//		
//		function onError(event:IOErrorEvent):void
//		{
//			trace("request error",event);			
//		}
	}
}






