/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.manager
{
	import flash.media.Sound;

	/**
	 * 声音记录
	 * @author Pengx
	 */
	internal class SoundObj
	{
		/**
		 * 名字
		 */
		public var name : String = null;
		/**
		 * 声音
		 */
		public var sound : Sound = null;
		/**
		 * 播放此声音的通道们
		 */
		public var channels : Array = new Array;

		public function SoundObj()
		{
		}


		/**
		 * 在声音中查找某个id对于的通道
		 * @param id
		 * @return 			通道信息
		 *
		 */
		public function findChannel(id : int) : ChannelObj
		{
			for (var i : int = 0; i < channels.length; i++)
			{
				if (channels[i].id == id)
				{
					return channels[i];
				}
			}
			return null;
		}

		public function toString() : String
		{
			return "[SoundObj name=" + name + " sound=" + sound + "]";
		}
	}
}
