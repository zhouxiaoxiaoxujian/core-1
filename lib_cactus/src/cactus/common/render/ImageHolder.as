package cactus.common.render
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.net.URLRequest;

	/**
	 * 加载图片
	 * @author: Peng
	 */
	public class ImageHolder extends Sprite
	{
		private var loader:Loader
		private var _width:int;
		private var _height:int;

		public function ImageHolder(url:String, $width:int, $height:int)
		{
			super();
			_width = $width;
			_height = $height;

			loader = new Loader();

			configureListeners(loader.contentLoaderInfo);
			var request:URLRequest = new URLRequest(url);
			loader.load(request);
			addChild(loader);

		}

		public function destory():void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			loader.contentLoaderInfo.removeEventListener(Event.INIT, initHandler);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.removeEventListener(Event.OPEN, openHandler);
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.contentLoaderInfo.removeEventListener(Event.UNLOAD, unLoadHandler);
		}

		private function configureListeners(dispatcher:IEventDispatcher):void
		{
			dispatcher.addEventListener(Event.COMPLETE, completeHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			dispatcher.addEventListener(Event.INIT, initHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(Event.UNLOAD, unLoadHandler);
		}

		private function completeHandler(event:Event):void
		{
			loader.width = _width;
			loader.height = _height;
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
		}

		private function initHandler(event:Event):void
		{
		}

		private function ioErrorHandler(event:IOErrorEvent):void
		{
		}

		private function openHandler(event:Event):void
		{
		}

		private function progressHandler(event:ProgressEvent):void
		{
		}

		private function unLoadHandler(event:Event):void
		{
		}

	}
}
