package cactus.common.frame.ai.fsm
{
	import cactus.common.frame.ai.AITelegram;

	/**
	 * 具体状态
	 * 每一个状态应该继承此类
	 * @author Peng
	 */
	public class State implements IState
	{
		public function enter(entity : *) : void
		{

		}

		public function exit(entity : *) : void
		{

		}

		public function execute(entity : *) : void
		{

		}

		public function handleMessage(_owner : *, telegram : AITelegram) : Boolean
		{
			return false;
		}
	}
}
