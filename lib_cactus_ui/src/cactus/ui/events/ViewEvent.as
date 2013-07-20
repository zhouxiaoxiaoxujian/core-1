package cactus.ui.events
{
	import flash.events.Event;

	/**
	 * @author Pengx
	 * @version 1.0
	 */
	public class ViewEvent extends Event
	{
		/**
		 * 都准备好了
		 */
		static public const ALL_READY:String="allReady";
		/**
		 * AllReady并且BindComplete之后，可以开始播放特效
		 */
		static public const SHOW_IN:String = "showIn";
		/**
		 * 完全显示
		 */
		static public const SHOW_INED:String="showIned";
		/**
		 * 完全隐藏
		 */
		static public const SHOW_OUTED:String="showOuted";

		/**
		 * PButtonGroup中的元素被选中
		 * @default
		 */
		static public const GROUP_ITEM_SELECT:String="GROUP_ITEM_SELECT";

		/**
		 * PButtonGroup中选中的元素改变
		 * @default
		 */
		static public const GROUP_ITEM_CHANGE:String="GROUP_ITEM_CHANGE";

		/**
		 * PView销毁
		 * @default
		 */
		public static var VIEW_DESTORY:String="VIEW_DESTORY";

		/**
		 * 关闭模块
		 * @default
		 */
		public static var CLOSE_MODULE:String="CLOSE_MODULE";

		public function ViewEvent(type:String, bubbles:Boolean=false)
		{
			super(type, bubbles);
		}

	} //end ViewEvent

}
