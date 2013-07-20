package cactus.common.xx.sprite
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;

	import cactus.common.frame.interfaces.IDisposeAble;

	/**
	 * 可视化组件基类
	 * 加入显示列表进行初始化,从显示列表移除进行卸载工作
	 * 此类被设计为一次性,从舞台删除后,需要再次实例化方可再加入舞台
	 * */
	public class GameDispose extends Sprite implements IDisposeAble
	{
		//所有的监听器
		private var listenerDict:Dictionary=new Dictionary(true);
		private var listenerDictCapture:Dictionary=new Dictionary(true);

		public function GameDispose()
		{
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
		}

		protected function addToStage(event:Event):void
		{
			addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			init();
		}

		protected function removeFromStage(event:Event):void
		{
			destory();
			removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			removeEventListener(Event.ADDED_TO_STAGE, addToStage);
			dispose();
		}

		/**
		 * 初始化工作
		 * */
		public function init():void
		{

		}

		/**
		 * 卸载工作
		 * */
		public function destory():void
		{
		}

		/**
		 * 销毁
		 * */
		public function dispose():void
		{
			removeAllEventListeners();
			removeAllChildren(this);
		}

		/**
		 * 删除全部的子类
		 * */
		public function removeAllChildren(container:DisplayObjectContainer=null):void
		{
			container=container == null ? this : container;
			while (container.numChildren != 0)
			{
				container.removeChildAt(0);
			}
		}

		/////////////////////
		//重写
		/////////////////////
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			//添加
			var dict:Dictionary=listenerDict;
			if (useCapture)
				dict=listenerDictCapture;
			dict[listener]=type;
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			super.removeEventListener(type, listener, useCapture);
			//清理
			var dict:Dictionary=listenerDict;
			if (useCapture)
				dict=listenerDictCapture;
			dict[listener]=null;
			delete dict[listener];
		}

		///////////////////////
		//公共方法
		///////////////////////
		/**
		 * 移除 已记录的所有的监听器,不过,闭包方式的监听还是无法移除
		 * 所以,添加监听时不要用闭包.
		 * */
		public function removeAllEventListeners():void
		{
			for (var k:* in listenerDict)
			{
				removeEventListener(listenerDict[k], k);
			}
			for (k in listenerDictCapture)
				removeEventListener(listenerDictCapture[k], k);
		}

		/**
		 * 此对象,有没有listener这个方法的监听器?
		 * */
		public function hasThisListener(listener:Function, useCapture:Boolean=false):Boolean
		{
			var dict:Dictionary=listenerDict;
			if (useCapture)
				dict=listenerDictCapture;
			for (var k:* in dict)
			{
				if (k == listener)
					return true;
			}
			return false;
		}

		/**
		 * 字符串形式
		 * */
		override public function toString():String
		{
			var str:String="children:" + numChildren + ",events:{";
			for (var k:Object in listenerDict)
			{
				str+="type:" + k + ",listener:" + listenerDict[k] + "\n";
			}
			str+="}";
			return str;
		}

		/**
		 * 获取 监听器的数量
		 * */
		public function get listenerCount():int
		{
			var count:int=0;
			for (var k:Object in listenerDict)
			{
				count++;
			}
			return count;
		}
	}
}
