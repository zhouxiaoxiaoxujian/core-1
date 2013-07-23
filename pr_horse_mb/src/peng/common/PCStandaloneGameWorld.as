package peng.common
{
	import cactus.common.Global;
	import cactus.common.tools.Hook;
	import cactus.common.tools.Local;
	import cactus.common.tools.util.ByteArrayAssetFactory;

	public class PCStandaloneGameWorld extends HorseGameWorld implements IGame
	{
		public function PCStandaloneGameWorld()
		{
			super();
		}

		override protected function initManager():void
		{
			Global.platform = Global.PLATFORM_PC;
			Local.parseXML(ByteArrayAssetFactory.createXMLAsset(Engine.langXML));
			Hook.parse(ByteArrayAssetFactory.createXMLAsset(Engine.engineXML));

			super.initManager();
		}

		public function exit():void
		{
		}
	}
}
