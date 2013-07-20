package cactus.ui.events
{
	import flash.events.Event;
	
	
	/**
	 *
	 * @author Peng
	 */
	public class BindEvent extends Event
	{
		public static const BIND_COMPLETE:String="bind_complete";
		
		
		public function BindEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}