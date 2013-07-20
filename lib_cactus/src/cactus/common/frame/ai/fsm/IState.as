/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.ai.fsm
{
	import cactus.common.frame.ai.AITelegram;

	/**
	 * AI具体状态
	 * @author Peng
	 */
	public interface IState
	{
		/**
		 * 进入此状态
		 * @param entity
		 */
		function enter(entity : *) : void

		/**
		 * 退出状态
		 * @param entity
		 */
		function exit(entity : *) : void

		/**
		 * update状态
		 * @param entity
		 */
		function execute(entity : *) : void

		/**
		 * 状态处理消息
		 * @param _owner
		 * @param telegram
		 */
		function handleMessage(_owner : *, telegram : AITelegram) : Boolean
	}
}
