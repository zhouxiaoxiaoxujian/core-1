package cactus.common.frame.scheduler
{
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import cactus.common.tools.util.ArrayUtils;

	public class Clock
	{
		/**
		 * Clock是否运行的标志
		 * @default
		 */
		public var m_running:Boolean;

//		/**
//		 * 档次刷新的时间
//		 * @default
//		 */
//		public var m_thisTime:uint;
//		/**
//		 * 上次刷新的时间
//		 * @default
//		 */
//		public var m_lastTime:uint;
		/**
		 * 系统已运行的时间,是一个不会暂停的时间
		 * @default
		 */
		public var m_systemTime:uint;
//		unsigned m_systemOffset;
		/**
		 * Clock停止的时间
		 * @default
		 */
		public var m_pauseTime:uint;

		/**
		 * 系统已经运行的帧
		 * @default
		 */
		public var m_frameCount:uint;

		/**
		 * 系统运行时间，不包括暂停的时间
		 * @default
		 */
		public var m_simTime:uint;
		/**
		 * 当前帧的开始时间，不包括暂停的时间
		 * @default
		 */
		public var m_frameStart:uint;
		/**
		 * 当前帧的结束时间，不包括暂停的时间
		 * @default
		 */
		public var m_frameEnd:uint;



		public function Clock()
		{
		}

		public function update(delay:uint):void
		{
			m_frameCount++;

			// system time is real time and never pauses
			m_systemTime += delay;

			if (m_running)
			{
				m_frameStart = m_simTime;
				m_simTime += delay;
				m_frameEnd = m_simTime;

				// 更新枚举时间
				for each (var enumKey:int in enumClockArray)
				{
					enumClock[enumKey] += delay;
				}
			}
		}


		private var enumClock:Dictionary = new Dictionary;
		// 为了优化而使用
		private var enumClockArray:Array = new Array;


		/**
		 * 开始局部时钟
		 * @param type
		 */
		public function startEnumClock(type:int):void
		{
			enumClock[type] = 0;
			enumClockArray.push(type);
		}

		/**
		 * 停止局部时钟
		 * @param type
		 */
		public function stopEnumClock(type:int):void
		{
			enumClock[type] = 0;
			ArrayUtils.removeFromArray(enumClockArray, type);
		}

		/**
		 * 获得局部时钟
		 * @param type
		 * @return
		 */
		public function getEnumClock(type:int):uint
		{
			return enumClock[type];
		}



		public function reset():void
		{

		}

		public function isRunning():Boolean
		{
			return m_running;
		}

		public function run():void
		{
			if (!m_running)
			{
				trace("Clock: started", m_systemTime - m_pauseTime, " ms elapsed since last stop");
			}
			m_running = true;
		}

		public function stop():void
		{
			if (m_running)
			{
				m_pauseTime = m_systemTime;
				trace("Clock: stopped, paused at %u ms\n", m_pauseTime);
			}
			m_running = false;
		}

		/**
		 * 模拟时钟跳转到某个时间
		 * @param newTime
		 */
		public function advanceToTime(newTime:uint):void
		{
			if (m_running && newTime >= m_simTime)
			{
				m_simTime = newTime;
			}
		}

		/**
		 * 模拟时钟跳转到帧结束
		 */
		public function advanceToFrameEnd():void
		{
			if (m_running)
			{
				m_simTime = m_frameEnd;
			}
		}

		/**
		 * 系统已运行时间
		 * @return
		 */
		public function getSystem():uint
		{
			return m_systemTime;
		}

		/**
		 * 系统已运行时间，排除暂停时间
		 * @return
		 */
		public function getTime():uint
		{
			return m_simTime;
		}

		public function getFrame():uint
		{
			return m_frameCount;
		}

		public function getFrameStart():uint
		{
			return m_frameStart;
		}

		public function getFrameEnd():uint
		{
			return m_frameEnd;
		}



	}
}