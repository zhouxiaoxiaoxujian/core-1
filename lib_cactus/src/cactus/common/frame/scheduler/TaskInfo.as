package cactus.common.frame.scheduler
{

	public class TaskInfo
	{
		public var pTask:ITask;
//		public var pNext:TaskInfo;
		public var status:int; // 0 = ok, 1 = pause, 2 = delete
		public var id:int;
		public var params:*;

		private var _time:Time;

		public function TaskInfo()
		{
		}

		public function get time():Time
		{
			if (!_time)
			{
				_time = new Time();
			}
			return _time;
		}

		public function set time(value:Time):void
		{
			_time = value;
		}

	}
}

class Time
{
	/**
	 * 开始时间
	 * @default
	 */
	public var start:uint;
	/**
	 * 持续时间
	 * @default
	 */
	public var duration:uint;
	/**
	 * 间隔时间
	 * @default
	 */
	public var period:uint;
	/**
	 * 上次时间
	 * @default
	 */
	public var last:uint;
	/**
	 * 下次的触发时间
	 * @default
	 */
	public var next:uint;
}