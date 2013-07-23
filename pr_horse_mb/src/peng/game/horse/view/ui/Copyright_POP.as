package peng.game.horse.view.ui
{
	import cactus.ui.base.BasePopupPanel;
	import cactus.ui.control.*;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 版权信息页
	 * @author supperhpxd
	 */
	public class Copyright_POP extends BasePopupPanel
	{

		public var mmc_title_PB_T:MovieClip;
		
		public var btn_back_PB_A:PButton = new PLazyClickButton;

		public var mmc_bg_PB_S:MovieClip;

		public function Copyright_POP(src:* = null)
		{
			super("Copyright_POP");
		}

		override public function init():void
		{
			super.init();
			btn_back_PB_A.addEventListener(MouseEvent.CLICK, onBackClick);
			this.addEventListener(MouseEvent.CLICK, onPopClick);
		}

		protected function onPopClick(event:MouseEvent):void
		{
			close();
		}

		protected function onBackClick(event:MouseEvent):void
		{
			close();
		}

		override public function destory():void
		{
			super.destory();
			btn_back_PB_A.removeEventListener(MouseEvent.CLICK, onBackClick);
			this.removeEventListener(MouseEvent.CLICK, onPopClick);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		override public function showOut():void
		{
			TweenLite.to(this, 0.5, {x: -1000, onComplete: onShowOuted});
		}
	}
}
