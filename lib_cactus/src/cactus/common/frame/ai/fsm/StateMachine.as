/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.ai.fsm
{
	import cactus.common.frame.ai.AITelegram;

	/**
	 * 状态机
	 * 使用方法
	 * 每一个智能体持有一个StateMachine的实例，该实例用于切换状态
	 *
	 * AI管理器持有所有智能体的实例，在游戏循环中，update需要的智能体
	 * @author Peng
	 */
	public class StateMachine
	{
		private var _owner : *;
		private var _currState : IState;
		private var _prevState : IState;
		private var _globalState : IState;

		public function StateMachine(pOwner : *, pCurr : IState = null, pPrev : IState = null, pGlobal : IState = null)
		{
			_owner = pOwner;
			_currState = pCurr;
			_prevState = pPrev;
			_globalState = pGlobal;
		}

		public function handleMessage(telegram : AITelegram) : Boolean
		{
			if (_currState && _currState.handleMessage(_owner, telegram))
			{
				return true;
			}

			if (_globalState && _globalState.handleMessage(_owner, telegram))
			{
				return true;
			}
			return false;
		}


		public function get globalState() : IState
		{
			return _globalState;
		}

		public function set globalState(value : IState) : void
		{
			_globalState = value;
		}

		public function update() : void
		{
			if (_globalState)
			{
				_globalState.execute(_owner);
			}

			if (_currState)
			{
				_currState.execute(_owner);
			}
		}

		public function changeState(newState : IState) : void
		{
			if (_currState)
			{
				_prevState = _currState;

				_currState.exit(_owner);
			}


			_currState = newState;

			_currState.enter(_owner);
		}

		public function revertToPreviousState() : void
		{
			changeState(_prevState);
		}

		public function get prevState() : IState
		{
			return _prevState;
		}

		public function get currState() : IState
		{
			return _currState;
		}

	}
}
