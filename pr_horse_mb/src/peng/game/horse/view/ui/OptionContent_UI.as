package peng.game.horse.view.ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import peng.common.Config;
	import cactus.common.manager.PopupManager;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.util.Debugger;
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.model.HorseModel;
	import cactus.ui.bind.PAutoView;
	import cactus.ui.control.*;

	/**
	 * 系统功能按钮 
	 * @author Peng
	 */
	public class OptionContent_UI extends PAutoView
	{

		public var btn_info_PB:PButton = new PLazyClickButton;
		public var btn_help_PB:PButton = new PLazyClickButton;
		public var btn_sound_PB:PToggleButton = new PToggleButton;

		public function OptionContent_UI(src:*=null)
		{
			super(src)
		}

		override public function init():void
		{
			super.init();
			btn_info_PB.addEventListener(MouseEvent.CLICK,btn_infoClick);
			btn_help_PB.addEventListener(MouseEvent.CLICK, btn_helpClick);
			btn_sound_PB.addEventListener(MouseEvent.CLICK, btn_soundClick);
			
			// 默认不出现
			this.visible = false;
			
			if ( SoundManager.soundEnable == false)
			{
				btn_sound_PB.open = false;
			}
			else
			{
				btn_sound_PB.open = true;
			}
		}
		
		override public function destory():void
		{
			super.destory();
			btn_info_PB.removeEventListener(MouseEvent.CLICK,btn_infoClick);
			btn_help_PB.removeEventListener(MouseEvent.CLICK, btn_helpClick);
			btn_sound_PB.removeEventListener(MouseEvent.CLICK, btn_soundClick);
		}

		override public function fireDataChange():void
		{
			super.fireDataChange();
		}

		protected function btn_infoClick(event:MouseEvent):void
		{
			Debugger.info("-- 版权信息");
			PopupManager.getInstance().showPanel( Copyright_POP); 
		}
		
		private function btn_helpClick(evt:MouseEvent):void
		{
			Debugger.info("-- 帮助");
			PopupManager.getInstance().showPanel( Help_POP);
		}

		private function btn_soundClick(evt:MouseEvent):void
		{
			if (btn_sound_PB.open)
			{
				Debugger.debug("----- 打开音乐 -----");
				
				Config.service.setSoundEnable(1);
				
				SoundManager.soundEnable = SoundManager.bgSoundEnable = true;
				SoundManager.getInstance().playBgSound(HSoundFlag.BgSound);
			}
			else
			{
				Debugger.debug("----- 关闭音乐 -----");
				
				Config.service.setSoundEnable(-1);
				
				SoundManager.soundEnable = SoundManager.bgSoundEnable = false;
				SoundManager.getInstance().stopBgSound();
			}
		}
		
		
		override public function showIn():void
		{
			super.showIn();
		}
		
		override public function showOut():void
		{
			super.showOut();
		}
		
		override protected function onShowIned():void
		{
		}
		
		override protected function onShowOuted():void
		{
		}
	}
}
