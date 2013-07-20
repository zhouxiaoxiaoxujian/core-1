package cactus.common.frame.ai
{

	public class AITelegram
	{
		/**
		 * 发送者id
		 * @default
		 */
		public var sender : int;

		/**
		 * 接收者id
		 * @default
		 */
		public var receiver : int;

		/**
		 * 消息类型
		 * @default
		 */
		public var msg : int;

		/**
		 * 消息被发送的延迟时间
		 * @default
		 */
		public var dispatchTime : Number;

		/**
		 * 消息附加的数据
		 * @default
		 */
		public var msgData : *;


		public function AITelegram(pSender : int, pReceiver : int, pMsg : int, pDispatchTime : Number, pMsgData : * = null)
		{
			sender = pSender;
			receiver = pReceiver;
			msg = pMsg;
			dispatchTime = pDispatchTime;
			msgData = pMsgData;
		}
	}
}
