package cactus.common.frame.scheduler
{
	import cactus.common.manager.EnterFrameManager;
	import cactus.common.tools.util.Debugger;

	/**
	 * 调度器
	 *
	 * // 定义TraceTask 在系统5秒时触发，每隔1秒钟触发一次，持续3秒钟
	 * Scheduler.getIns().schedule(new TraceTask, 5000, 1000, 3000);
	 * @author Peng
	 */
	public class Scheduler
	{
		private static var _instance:Scheduler

		private var m_clock:Clock = new Clock;

		private var m_pTaskList:Vector.<TaskInfo> = new Vector.<TaskInfo>;

		// 下一个任务的id
		private var m_nextId:int = 0;

		public function Scheduler(locker:Locker)
		{
		}

		public static function getIns():Scheduler
		{
			if (!_instance)
			{
				_instance = new Scheduler(new Locker);
			}
			return _instance;
		}

		public function getClock():Clock
		{
			return m_clock;
		}

		/**
		 * 游戏进行毫秒
		 * @return
		 */
		public function getTime():uint
		{
			return m_clock.getTime();
		}

		public function isRunning():Boolean
		{
			return m_clock.isRunning();
		}

		public function run():void
		{
			m_clock.run();
			EnterFrameManager.getInstance().registerEnterFrameFunction(update);
		}

		public function stop():void
		{
			m_clock.stop();
			EnterFrameManager.getInstance().removeEnterFrameFunction(update);
		}

		public function update(delay:int):void
		{
			m_clock.update(delay);
			//
			// 执行基于时间的任务
			// 1 弹出队列中的第一个任务。因为任务队列经常会排序，第一个一般就是下一个任务
			// 2 执行update
			// 3 如果任务过期，删除。其他情况，重新将任务插入队列
			//
			var pTaskInfo:TaskInfo = getNextTimeTask();
			while (pTaskInfo)
			{
				m_clock.advanceToTime(pTaskInfo.time.next);

				// 执行任务
				pTaskInfo.pTask.execute(pTaskInfo.id, m_clock.getTime(), pTaskInfo.params);


				pTaskInfo.time.last = pTaskInfo.time.next;
				pTaskInfo.time.next += pTaskInfo.time.period;

				if (pTaskInfo.time.duration == 0 || pTaskInfo.time.duration >= pTaskInfo.time.next)
				{
					// 将任务重新插入队列
					Debugger.info("任务重新插入到队列", pTaskInfo.time.duration, pTaskInfo.time.next);
					insertTimeTask(pTaskInfo);
				}
				else
				{
					// 任务过期，将其从队列中删除
					// 注意，此时该taskInfo已经不再队列中，只要不将其添加回去就行了
					Debugger.info("过期的任务,立刻被删除", pTaskInfo.id);
					pTaskInfo = null;
				}
				pTaskInfo = getNextTimeTask();
			}

			// Advance simulation clock to end of frame
			m_clock.advanceToFrameEnd();
		}

		/**
		 *
		 * @param start			开始时间
		 * @param period		时间间隔。即一个任务可以执行多次，每两次之间的时间间隔
		 * @param duration		持续时间。如果过期，即从任务队列中删除。 如果为0，代表为无限时间的任务
		 * @param pTask
		 * @return
		 */
		public function schedule(pTask:ITask, start:uint, period:int, duration:uint = 0):TaskInfo
		{
			// Schedule可以安排三种类型的调度，RENDER，FRAME和TIME事件（目前只实现了Time事件）

			// time 和 frame的任务拥有start time, a duration, and a period.
			// the duration is relative to the start time, except for duration 0 which is a special case.
			// since the scheduler doesn't care about the duration itself, it converts it into an end time
			// and stores that instead. the render task does ignores start/duration/end.
			//
			var pTaskInfo:TaskInfo = new TaskInfo();
			pTaskInfo.pTask = pTask;
			pTaskInfo.status = 0;
			pTaskInfo.id = m_nextId++;

			pTaskInfo.time.start = start;
			pTaskInfo.time.duration = duration;
			pTaskInfo.time.period = period;

			if (duration == 0)
				pTaskInfo.time.duration = 0; // infinite
			else
				pTaskInfo.time.duration = start + duration - 1; // compute end time

			pTaskInfo.time.next = start;
			Debugger.info("添加一个任务", start, duration, pTask);

//			if (type == TASK_TIME)
//				InsertTimeTask(pTaskInfo);
//			else if (type == TASK_FRAME)
//				InsertFrameTask(pTaskInfo);
			insertTimeTask(pTaskInfo);
			return pTaskInfo;
		}

		private function insertTimeTask(pTaskInfo:TaskInfo):void
		{
			var len:int = m_pTaskList.length;
			if (len == 0)
			{
				m_pTaskList.push(pTaskInfo);
			}
			else
			{
				var currTaskInfo:TaskInfo;
				for (var i:int = 0; i < len; i++)
				{
					currTaskInfo = m_pTaskList[i];

					if (currTaskInfo.time.next > pTaskInfo.time.next)
					{
						// 插入
						m_pTaskList.splice(i, 0, pTaskInfo);
						break;
					}
				}
			}
		}

		private function getNextTimeTask():TaskInfo
		{
			// 返回下一个任务
			// 如果没有适时的任务，返回null
			// 注意，此方法的shift将任务从队列中移除。故调用者应根据情况将shift的任务删除或重新排列入队

			// 另 空Array的shift为undefined

			if (m_pTaskList.length > 0 && m_pTaskList[0].time.next <= m_clock.getFrameEnd())
			{
				return m_pTaskList.shift();
			}
			return null;
		}

	}



}

class Locker
{
}