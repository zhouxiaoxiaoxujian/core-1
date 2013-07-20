/** 
 * 
 *@author <a href="mailto:Pengxu.he@happyelements.com">Peng</a> 
 *@version $Id: IPGroupItem.as 115190 2012-12-19 03:01:32Z pengxu.he $ 
 * 
 **/ 
package cactus.ui.control
{
	import flash.events.IEventDispatcher;
	
	/**
	 * 可以加入PGroup的对象，确保在PGroup中的选择唯一性
	 * @author: Peng
	 */
	public interface IPGroupItem extends IEventDispatcher
	{
		/**
		 * 设置选中状态 
		 * @param value
		 */
		function set selected(value:Boolean):void
			
		/**
		 * 
		 * @return 
		 */
		function get selected():Boolean
			
			
		/**
		 * 元件持有的值
		 * @return 
		 */
		function get data():Object
		
		function set data(value:Object):void
	}
}