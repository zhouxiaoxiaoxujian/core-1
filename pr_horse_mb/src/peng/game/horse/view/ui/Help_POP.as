package peng.game.horse.view.ui
{
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.control.*;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 帮助页
	 * @author supperhpxd
	 */
	public class Help_POP extends BasePopupPanel
	{

		public var btn_back_PB_A:PButton;
		
		public var mmc_bg_PB_S:MovieClip;

		public function Help_POP(src:*=null)
		{
			super("Help_POP");
		}

		override public function init():void
		{
			super.init();
			btn_back_PB_A.addEventListener(MouseEvent.CLICK, btn_backClick);
			this.addEventListener(MouseEvent.CLICK,onPopClick);
		}
		
		override public function destory():void
		{
			super.destory()
			btn_back_PB_A.removeEventListener(MouseEvent.CLICK, btn_backClick);
			this.removeEventListener(MouseEvent.CLICK,onPopClick);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		private function btn_backClick(evt:MouseEvent):void
		{
			close();
		}

		protected function onPopClick(event:MouseEvent):void
		{
			close();
		}

		override public function showOut():void
		{
			TweenLite.to(this, 0.5, {x: -1000, onComplete: onShowOuted});
		}
	}
}
