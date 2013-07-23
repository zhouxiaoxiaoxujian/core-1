package peng.common
{
	import cactus.common.Global;
	import cactus.common.tools.Hook;
	import cactus.common.tools.Local;
	import cactus.common.tools.util.ByteArrayAssetFactory;
	import cactus.common.tools.util.Debugger;
	import cactus.ui.control.PAlert;

//	import com.hdi.nativeExtensions.NativeAds;

	import flash.desktop.NativeApplication;
	import flash.events.KeyboardEvent;
	import flash.media.StageWebView;

	public class AndroidGameWorld extends HorseGameWorld implements IGame
	{
		// setup variables
		private var _stageWebView : StageWebView;
		private var myAdvertURL : String = "http://cactusgame.comli.com/androidmob.html";

		public function AndroidGameWorld()
		{
			super();
		}

		override protected function initManager() : void
		{
			Global.platform = Global.PLATFORM_ANDROID;
			Local.parseXML(ByteArrayAssetFactory.createXMLAsset(Engine.langXML));
			Hook.parse(ByteArrayAssetFactory.createXMLAsset(Engine.engineXML));

			super.initManager();
			keyBackCallBack = onKeyBack;
			keyHomeCallBack = onKeyHome;

			// 初始化
			initAd();
		}

		public function onKeyBack(e : KeyboardEvent) : void
		{
			Debugger.info("Back键按下");

			e.preventDefault();
			PAlert.show(Local.getString("sys_if_exit"), 2, [exit]);
		}

		public function onKeyHome(e : KeyboardEvent) : void
		{
			Debugger.info("Home键按下");

			exit();
		}


		public function exit() : void
		{
			Debugger.info("退出程序");
			NativeApplication.nativeApplication.exit();
		}

		private function initAd() : void
		{
//			NativeAds.setUnitId("a14f2a58077d7e4");
//			NativeAds.setAdMode(true); //put the ads in real mode
//			NativeAds.initAd(0, 0, 320, 50);
		}

		/**
		 * 创建Admob
		 */
		override public function createAdmob($x : int, $y : int, $width : int, $height : int, delay : int = 0) : void
		{
//			NativeAds.showAd($x, $y, $width, $height);
		}

		/**
		 * 销毁Admob
		 */
		override public function destroyAdmob() : void
		{
//			NativeAds.hideAd();
		}

//		private function onLocationChange(event:LocationChangeEvent):void
//		{
//			// check that it's not our ad URL loading
//			if (_stageWebView.location != myAdvertURL)
//			{
//				// stop the content from loading within StageWebView
//				event.preventDefault();
//
//				// since e.preventDefault() doesn't work for me, I set the webView to back to previous page.
//				_stageWebView.historyBack();
//
//				// Launch a normal browser window with the captured  URL;
//				navigateToURL(new URLRequest(event.location));
//			}
//		}


	}
}
