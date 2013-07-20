/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.resource
{
	import flash.display.MovieClip;

	public interface IResourceHelper
	{
		
		
		/**
		 * 获得当前域中的资源
		 * 
		 * @param name	资源链接名
		 * @return		该资源的Movieclip实例
		 *
		 */
		function getMC(name:String):MovieClip;
			
			
		/**
		 * 根据链接名数组，加载对应的素材
		 * @param arr					要加载的素材链接名数组,比如加载Link1，Link2，则传递数组[Link1,Link2]
		 * @param completeFun			加载完成的回调方法。如果当前域中存在这些资源，则不用加载，直接调用回调方法
		 *
		 */
		function loadByRelateObjectArr(arr:Array, completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void;
	}
}