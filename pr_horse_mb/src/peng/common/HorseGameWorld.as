package peng.common
{

	import cactus.common.Global;
	import cactus.common.frame.DefaultResourceHelper;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.frame.resource.helper.ResourceLoadHelper;
	import cactus.common.manager.PopupManager;
	import cactus.common.manager.SceneManager;
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.Hook;
	import cactus.common.tools.Local;
	import cactus.common.tools.util.ByteArrayAssetFactory;
	import cactus.common.tools.util.StringUtil;
	import cactus.ui.PUIConfig;
	
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;
	
	import flash.events.KeyboardEvent;
	import flash.text.Font;
	import flash.ui.Keyboard;
	
	import peng.game.horse.HSoundFlag;
	import peng.game.horse.manager.HCache;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.HorseServiceLocal;
	import peng.game.horse.model.PropVO;
	import peng.game.horse.view.scene.GameOverScene;
	import peng.game.horse.view.scene.GamePlayScene;
	import peng.game.horse.view.scene.SelectScene;
	import peng.game.horse.view.ui.Help_POP;
	import peng.game.horse.view.ui.Rank_POP;

	public class HorseGameWorld extends DefaultGameWorld
	{
		public function HorseGameWorld()
		{
			super();
		}

		override protected function initManager():void
		{
//			Global.dataCenterURL = "http://cactusgame.comli.com/stat.php";

			TweenPlugin.activate([VolumePlugin]);
			
			Global.initCapabilities(750, 600, true);

			// 初始化UI框架
			PUIConfig.initResourceHelper(new DefaultResourceHelper);
			
			super.initManager();

			HSoundFlag.initSoundInSoundManager();

			HCache.getIns().init();

			Config.service = new HorseServiceLocal();

			// load complete
			Config.service.loadGlobalData(loadComplete);

			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN, onGlobalKeyDown);
		}

		// for debug
		protected function onGlobalKeyDown(event:KeyboardEvent):void
		{
			if (event.shiftKey && event.keyCode == Keyboard.A)
			{
				SceneManager.getInstance().changeScene(SelectScene);
			}
			if (event.shiftKey && event.keyCode == Keyboard.S)
			{
				SceneManager.getInstance().changeScene(GamePlayScene);
			}
			if (event.shiftKey && event.keyCode == Keyboard.D)
			{
				SceneManager.getInstance().changeScene(GameOverScene);
			}
			if (event.shiftKey && event.keyCode == Keyboard.R)
			{
				PopupManager.getInstance().showTopPanel(Rank_POP);
			}

		}

		protected function loadComplete():void
		{
			// 加载的数据
			HorseModel.getIns().soundEnable = (Config.service.getSoundEnable() > 0 ? true : false);

			Config.service.getUserFlyDistance(function(value:Object):void
			{
				HorseModel.getIns().userFlyDistance = int(value);
			});

			Config.service.getUserPlayCount(function(value:Object):void
			{
				HorseModel.getIns().userPlayCount = int(value); 

				if (HorseModel.getIns().userPlayCount < 1)
				{
					PopupManager.getInstance().showPanel(Help_POP);
				}
			});

			Config.service.getUserEquipsServerStr(function(value:Object):void
			{
				var userEquipsStr:String = value.toString();
				if (StringUtil.trim(userEquipsStr) != "")
				{
					var propIdArray:Array = userEquipsStr.split(",");
					var ret:Array = [];
					for each (var id:String in propIdArray)
					{
						ret.push(PropVO.getVOById(int(id)));
					}
					HorseModel.getIns().setUserEquips(ret);
				}
			});
			Config.service.getData(HorseServiceLocal.SHARE_OBJ_RECORD_BEST_SCORE, function(value:String):void
			{
				HorseModel.getIns().bestScore = (value == "" ? 0 : int(value));
			});


			HorseModel.getIns().init();
		}
	}
}
