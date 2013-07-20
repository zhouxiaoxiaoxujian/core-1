/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
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
