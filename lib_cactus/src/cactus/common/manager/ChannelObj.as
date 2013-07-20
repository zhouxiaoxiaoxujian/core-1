package cactus.common.manager
{
	import flash.media.SoundChannel;
	
	/**
	 * 通道记录 
	 * @author Pengx
	 * 
	 */
	internal class ChannelObj
	{
		/**
		 * 编号 
		 */
		public var id:int				 	= 0;
		/**
		 * 声音通道
		 */
		public var channel:SoundChannel 	= null;
		/**
		 * 声音记录引用 
		 */
		public var soundObj:SoundObj 	 	= null;		
		/**
		 * 停止时播放头位置 
		 */
		public var position:Number     	= 0;
		/**
		 * 音量 
		 */
		public var	volume:Number  				= 1;
		/**
		 * 开始播放时间 
		 */
		public var startTime:Number 				= 0;
		/**
		 * 循环次数 
		 */
		public var	loops:Number	 				= 1;
		/**
		 * 是否暂停中 
		 */
		public var paused:Boolean					= true;
		
		public function ChannelObj()
		{
		}
		
		public function toString() : String
		{
			return "[ChannelObj id=" + id + " channel=" + channel + " soundObj=" + soundObj + "]";
		}
	}
}