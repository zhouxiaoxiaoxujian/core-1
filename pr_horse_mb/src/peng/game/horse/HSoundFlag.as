package peng.game.horse
{
	import cactus.common.manager.SoundManager;

	/**
	 * 声音信息 
	 * @author Pengx
	 * 
	 */
	public class HSoundFlag
	{
		/**
		 * bg
		 */
		public static const BgSound:String = "BgSound";
		
		/**
		 * 装地板
		 * @default 
		 */
		public static const SBounce:String = "SBounce";
		
		/**
		 * 更换楼层
		 * @default 
		 */
		public static const SChangeLevel:String = "SChangeLevel";
		
		/**
		 * 吃无敌
		 * @default 
		 */
		public static const SEatZool:String = "SEatZool";
		
		/**
		 * 吃苹果
		 * @default 
		 */
		public static const SEatApple:String = "SEatApple";
		
		/**
		 * 游戏结束
		 * @default 
		 */
		public static const SGameOver:String = "SGameOver";
		
		/**
		 * 撞鸡的声音
		 * @default 
		 */
		public static const SCollideHen:String = "SCollideHen";
		
		/**
		 * 在声音管理器中注册嵌入的声音 
		 * 
		 */
		public static function initSoundInSoundManager():void
		{
			SoundManager.getInstance().addSound(BgSound,BgSound);
			SoundManager.getInstance().addSound(SBounce,SBounce);
			SoundManager.getInstance().addSound(SChangeLevel,SChangeLevel);
			SoundManager.getInstance().addSound(SEatZool,SEatZool);
			SoundManager.getInstance().addSound(SEatApple,SEatApple);
			SoundManager.getInstance().addSound(SGameOver,SGameOver);
			SoundManager.getInstance().addSound(SCollideHen,SCollideHen);
		}
	}
}