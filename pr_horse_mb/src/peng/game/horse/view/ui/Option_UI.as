package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import cactus.ui.bind.PAutoView;
	import cactus.ui.bind.PView;
	import cactus.ui.control.*;

	/**
	 * 首页 功能选择UI 
	 * @author supperhpxd
	 */
	public class Option_UI extends PToggleView
	{
		public var optionContent_PB:OptionContent_UI=new OptionContent_UI;

		public function Option_UI(src:*=null) 
		{
			super(src)
		}

		override public function init():void
		{
			super.init();
		}
		
		override public function destory():void 
		{
			super.destory();
		}

		override public function getContent():PView
		{
			return optionContent_PB;
		}

	}
}
