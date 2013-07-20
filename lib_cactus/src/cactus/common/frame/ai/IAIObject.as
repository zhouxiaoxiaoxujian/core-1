package cactus.common.frame.ai
{

	/**
	 * AI智能体接口
	 * @author Peng
	 */
	public interface IAIObject
	{
		function get id() : int

		function set id(value : int) : void

		function handleMessage(telegram : AITelegram) : Boolean
	}
}
