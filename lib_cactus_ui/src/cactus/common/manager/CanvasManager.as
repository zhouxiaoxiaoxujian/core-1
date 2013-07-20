///////////////////////////////////////////////////////////
//  CanvasManager.as
//  Macromedia ActionScript Implementation of the Class CanvasManager
//  Generated by Enterprise Architect
//  Created on:      03-八月-2010 14:19:08
//  Original author: Pengx
///////////////////////////////////////////////////////////

package cactus.common.manager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;

	/**
	 * 画布容器管理
	 * @author Pengx
	 * @version 1.0
	 * @created 03-八月-2010 14:19:08
	 */
	public class CanvasManager extends EventDispatcher
	{
		/**
		 * 画布(容器) 
		 */
		protected var _canvas:DisplayObjectContainer;
		
		public function CanvasManager(){

		}

		/**
		 * 获得画布(容器)  
		 * 
		 */
	    public function get canvas(): DisplayObjectContainer
	    {
			return _canvas;
	    }

	    /**
	     * 设置画布(容器)  
	     * @param canvas
	     */
	    public function setCanvas(canvas:DisplayObjectContainer): void
	    {
			if(_canvas != null)
			{
				// throw new Error("不能重复设置画布（容器）!");
			}
			_canvas = canvas;
	    }

	}//end CanvasManager

}