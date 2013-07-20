/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.util
{

	/**
	 * 创建多参数事件监听器代理
	 * 
	 * 
	 * @Usage 
	 * sp.addEventListener(MouseEvent.MOUSE_DOWN, Delegate.create(__dotterMouseDown, xMove, yMove, xScale, yScale, move));
	 * 
	 * 
	 * 	private function __dotterMouseDown(e:MouseEvent, xMove:int, yMove:int,xScale:int, yScale:int, move:Boolean):void
	 *  {
		}
	 * 
	 * 
	 * @author Peng
	 */
	public class Delegate
	{

		public static function create(func:Function, ... args):Function
		{
			var fun:Function=function(... arg):void
				{
					var ar:Array=arg;
					func.apply(null, ar.concat(args));
				}
			return fun;
		}

	}
}