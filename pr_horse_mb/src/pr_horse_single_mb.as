package
{
	import flash.display.Graphics;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.system.Capabilities;

	import peng.common.AndroidGameWorld;
	import peng.common.Engine;
	import cactus.common.Global;
	import cactus.common.frame.scheduler.Scheduler;
	import cactus.common.manager.SceneManager;
	import peng.common.platform.PlatformAdapter;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.view.scene.SelectScene;

//	[SWF(width=750, height=600, backgroundColor="#000000", frameRate="30")]
	public class pr_horse_single_mb extends Engine
	{
		public function pr_horse_single_mb()
		{
			// 最简单的解决全屏的方法一
			// stage.scaleMode = StageScaleMode.EXACT_FIT;

			// 自适应屏幕方案
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 30;
			super(gameStart, AndroidGameWorld);
		}

		private function gameStart() : void
		{
			PlatformAdapter.getIns().init(PlatformAdapter.ANDROID_APPCHINA, function() : void
			{
				// PopupManager.getInstance().showTopPanel(Loading_POP);
				SceneManager.getInstance().changeScene(SelectScene);
			});
		}


		// ========================================================
		// 					调试
		// ========================================================
		private function traceDebug() : void
		{
			trace("Capabilities.serverString", Capabilities.serverString);
			trace("Capabilities.screenResolutionX", Capabilities.screenResolutionX);
			trace("Capabilities.screenResolutionY", Capabilities.screenResolutionY);
			trace("stage.stageWidth", stage.stageWidth);
			trace("stage.stageHeight", stage.stageHeight);

			trace("Capabilities.os", Capabilities.os);
			trace("Capabilities.screenDPI", Capabilities.screenDPI);
			trace("Capabilities.manufacturer", Capabilities.manufacturer);
			trace("stage.scaleMode", stage.scaleMode);
			trace("stage.quality", stage.quality);
			trace("Capabilities.language", Capabilities.language);

			// Capabilities.serverString A=t&SA=t&SV=t&EV=t&MP3=t&AE=t&VE=t&ACC=f&PR=f&SP=f&SB=f&DEB=t&V=AND%2011%2C1%2C112%2C60&M=Android%20Linux&R=480x800&COL=color&AR=1.0&OS=Linux%202.6.37.6-cyanogenmod-g8913be8&ARCH=ARM&L=zh-CN&IME=true&PR32=true&PR64=false&PT=Desktop&AVD=f&LFD=f&WD=t&TLS=t&ML=5.1&DP=240
		}
	}
}
