package cactus.common.frame.interfaces
{
	import flash.events.IEventDispatcher;

	/**
	 * 可以选中的组件
	 * @author Peng
	 */
	public interface ISelected extends IEventDispatcher
	{
		/**
		 * 是否已选中
		 * @return
		 */
		function isSelected():Boolean
	}
}
