package cactus.common.frame.scheduler
{

	/**
	 * 测试队列用 
	 * @author Peng
	 */
	public class TraceTask implements ITask
	{
		public function TraceTask()
		{
		}

		public function execute(id:int, time:uint, ... params):void
		{
			trace("正在执行任务id", id, "系统时间", time);
		}
	}
}