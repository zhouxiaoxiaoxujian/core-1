package cactus.common.manager
{
	/**
	 * 声音信息 
	 * @author Pengx
	 * 
	 */
	public class SoundFlag
	{
		/**
		 * 过关
		 */
		public static const sound_win:String = "m_win";
		/**
		 * 失败
		 */
		public static const sound_fail:String = "m_fail";
		/**
		 * 交换位置
		 */
		public static const sound_swap:String = "m_swap";
		/**
		 * 交换消除 
		 */
		public static const sound_delete:String = "m_delete";
		/**
		 * 取消 
		 */
		public static const sound_bg:String = "m_bg";
		
		// 时间快到了，开始闪烁
		public static const sound_time_flash:String = "m_time_flash";
		
		
		/**
		 * 在声音管理器中注册嵌入的声音 
		 * 
		 */
		public static function initSoundInSoundManager():void
		{
			SoundManager.getInstance().addSound(sound_win,sound_win);
			SoundManager.getInstance().addSound(sound_fail,sound_fail);
			SoundManager.getInstance().addSound(sound_swap,sound_swap);
			SoundManager.getInstance().addSound(sound_delete,sound_delete);
			SoundManager.getInstance().addSound(sound_bg,sound_bg);
			SoundManager.getInstance().addSound(sound_time_flash,sound_time_flash);
		}
	}
}