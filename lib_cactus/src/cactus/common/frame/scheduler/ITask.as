package cactus.common.frame.scheduler
{

	public interface ITask
	{
		/**
		 * 执行任务
		 * @param id		任务id
		 * @param time		执行任务时，当前的系统时间
		 * @param params	任务参数
		 */
		function execute(id:int, time:uint, ... params):void
	}
}