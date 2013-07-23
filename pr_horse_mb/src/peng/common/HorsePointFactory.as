package peng.common
{
	import peng.common.platform.PlatformAdapter;

	/**
	 * 神马打点 
	 * @author Peng
	 */
	public class HorsePointFactory extends DCPointFactory
	{
		public function HorsePointFactory()
		{
			super();
		}
		
		public static function login():void
		{
			createDCPoint().put("game_id", "1").put("pos", "1").put("platform", PlatformAdapter.getIns().currPlatform).send();
		}
	}
}