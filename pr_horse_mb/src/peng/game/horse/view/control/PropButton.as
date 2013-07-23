package peng.game.horse.view.control
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import peng.game.horse.event.HorseEvent;
	import cactus.ui.control.PButton;

	/**
	 * 道具按钮
	 * @author Peng
	 */
	public class PropButton extends PButton
	{
		public function PropButton(mc:MovieClip)
		{
			super(mc);
		}

		override public function init():void
		{
			super.init();
//			addEventListener(MouseEvent.CLICK, onThisClick);
		}

		override public function destory():void
		{
			super.destory();
//			removeEventListener(MouseEvent.CLICK, onThisClick);
		}

		override protected function onThisFirstClick(event:MouseEvent):void
		{
			dispatchEvent(new HorseEvent(HorseEvent.CLICK_PROP_INNER_BUTTON, null, true));
			
		}
	}
}
