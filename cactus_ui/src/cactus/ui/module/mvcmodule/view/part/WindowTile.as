package cactus.ui.module.mvcmodule.view.part
{
	import cactus.ui.control.PWindow;

	import flash.display.MovieClip;
	import flash.text.TextField;

	public class WindowTile extends PWindow
	{
		public var txt_title_PB:TextField;
		public var mmc_content_PB:MovieClip;

		public function WindowTile($sourceName:* = null)
		{
			super($sourceName);
		}


		override public function init():void
		{
			super.init();

			_minPanel.addChild(txt_title_PB);
			_normalPanel.addChild(mmc_content_PB);
		}


	}
}