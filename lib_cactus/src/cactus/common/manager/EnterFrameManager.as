/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.manager
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * 帧循环管理器 
	 * @author kaka
	 * @modi   Pengx
	 * 
	 */
	public class EnterFrameManager
	{
		///舞台实例
		private var _stage:Stage;
		///注册列表
		private var _list:Vector.<Function>;
		//时间间隔记录
		private var lastTime:Number = 0;
		
		static private var _instance:EnterFrameManager;
		
		public function EnterFrameManager(param:SingletonEnforcer){
			_list = new Vector.<Function>();
		}
		
		/**
		 * 单例 
		 * @return 
		 * 
		 */
		public static function getInstance():EnterFrameManager
		{
			if(_instance==null)
			{
				_instance = new EnterFrameManager(new SingletonEnforcer());			
			}
			return _instance;
		}		
		
		/**
		 * 注册侦听元素(舞台) 
		 * @param _stage
		 * 
		 */
		public function registerStage(_stage:Stage):void
		{
			this._stage = _stage;
		}
		
		/**
		 * 注册帧频调用函数
		 * @param fun 函数中传入两帧间的时间间隔
		 * 
		 */		
		public function registerEnterFrameFunction(fun:Function):void
		{
			var index:int=_list.indexOf(fun);
			if(index != -1)
			{
				return;
			}
			
			_list.push(fun);
		}
		
		/**
		 * 移除帧频调用函数
		 * @param fun
		 * 
		 */		
		public function removeEnterFrameFunction(fun:Function):void
		{
			var index:int=_list.indexOf(fun);
			if(index==-1)
			{
				return;
			}
			
			_list.splice(index,1);
		}
		
		/**
		 *	开始调度帧频事件 
		 * 
		 */
		public function startEnterFrame():void
		{
			_stage.addEventListener(Event.ENTER_FRAME, enterFramehandler);
			lastTime = getTimer();
		}
		
		/**
		 * 停止调度帧频事件 
		 * 
		 */		
		public function stopEnterFrame():void
		{
			_stage.removeEventListener(Event.ENTER_FRAME,enterFramehandler);
		}		
		
		private function enterFramehandler(evt:Event):void
		{
 			doEnterFrame();
		}
		
		public function doEnterFrame():void
		{
			///备份函数列表  防止在列表函数中执行registerEnterFrameFunction和removeEnterFrameFunction导致遍历列表出错
			var _list_copy:Vector.<Function> = _list.concat();
			
			var curTime:Number = getTimer();
			var delay:Number = curTime-lastTime;
			
			var n:int = _list_copy.length;
			while (--n > -1)
			{
				_list_copy[n](delay);
			}
			
			lastTime = curTime;
		}
		
	}
}
class SingletonEnforcer
{
	
}