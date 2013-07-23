package peng.common
{
	import cactus.common.Global;
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.tools.Hook;
	import cactus.common.tools.Local;

	public class PCConfigableGameWorld extends HorseGameWorld implements IGame
	{
		public function PCConfigableGameWorld()
		{
			super();
		}

		override protected function initManager():void
		{
			Global.platform = Global.PLATFORM_PC;
			Local.parseXML(new XML(ResourceFacade.getContent("lang")));
			Hook.parse(new XML(ResourceFacade.getContent("engine"))); 
			
			super.initManager();
		}

		public function exit():void
		{
		}
	}
}


