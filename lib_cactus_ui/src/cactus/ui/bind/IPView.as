package cactus.ui.bind
{
	import flash.display.MovieClip;

	/**
	 *
	 * @author Peng
	 */
	public interface IPView
	{
		function set source(clip:*):void
		
		function get source():*
		
		function bind():void
			
		function unbind():void
	}
}