/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.scheduler
{

	/**
	 * 可以被调度的任务接口
	 * @author Peng
	 */
	public interface ITask
	{
		/**
		 * 执行任务
		 * @param id		任务id
		 * @param time		执行任务时，当前的系统时间
		 * @param params	任务参数
		 */
		function execute(id : int, time : uint, ... params) : void
	}
}
