package cactus.common.frame.ai
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class AIMessageDispatcher
	{
		private static var _instance : AIMessageDispatcher = new AIMessageDispatcher;

		public function AIMessageDispatcher()
		{
		}

		public static function getIns() : AIMessageDispatcher
		{
			return _instance;
		}


		/**
		 *
		 * @param delay
		 * @param sender
		 * @param receiver
		 * @param msg
		 * @param msgData
		 */
		public function dispatchMessage(delay : Number, sender : int, receiver : int, msg : int, msgData : Object = null) : void
		{
			// 获得接收者的引用
			var pReceiver : IAIObject = AIEntityManager.getIns().getEnntity(receiver);

			if (pReceiver == null)
			{
				trace("没有找到接收者id", receiver);
				return;
			}

			// 创建电报
			var telegram : AITelegram = new AITelegram(0, sender, receiver, msg, msgData);

			// 不用延迟则立即发送
			if (delay <= 0.0)
			{
				discharge(pReceiver, telegram);
			}
			else
			{
				var uid : uint = setTimeout(function() : void
				{
					discharge(pReceiver, telegram);
					clearTimeout(uid);
				}, delay);
			}
		}

		/**
		 *
		 * @param pReceiver
		 * @param telegram
		 */
		private function discharge(pReceiver : IAIObject, telegram : AITelegram) : void
		{
			if (!pReceiver.handleMessage(telegram))
			{
				trace("Message not handled");
			}
		}

	}
}
