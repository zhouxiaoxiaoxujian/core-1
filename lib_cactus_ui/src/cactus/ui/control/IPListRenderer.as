package cactus.ui.control
{

	/**
	 * ListRenderer
	 * @author Administrator
	 */
	public interface IPListRenderer extends IPTileListRenderer
	{

		function get selected():Boolean;

		function set selected(value:Boolean):void

	}
}
