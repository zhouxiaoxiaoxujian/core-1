
package cactus.ui.events
{
	import flash.events.Event;

	/**
	 * @author Pengx
	 * @version 1.0
	 * @created 11-八月-2010 15:07:01
	 */
	public class DataEvent extends Event
	{
	    /**
	     * 数据改变了
	     */
	    static public const DATA_CHANGE: String = "dataChange";
	    /**
	     * 数据准备好
	     */
	    static public const DATA_READY: String = "dataReady";
		/**
		 * 数据出错啦
		 */
		static public const DATA_ERROR: String = "dataError";

		public function DataEvent(type:String){
			super(type);
		}

	}//end DataEvent

}