package cactus.ui.control
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	/**
	 * 开关按钮
	 * @author Peng
	 */
	public class PToggleButton extends PButton
	{
		private var _open:Boolean = true;

		public function PToggleButton(mc:MovieClip = null)
		{
			super(mc);
		}

		/**
		 * 对应开启和关闭两种状态
		 * @param s
		 *
		 */
		public function set open(s:Boolean):void
		{
			_open = s;
			updateState(currState);
		}

		public function get open():Boolean
		{
			return this._open;
		}

		/**
		 * 更新状态
		 * @param	state
		 */
		override protected function updateState(state:int):void
		{
			configListeners();
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.mouseChildren = true;

			_currState = state;

			switch (state)
			{
				case State_Up:
					moveMC("up" + postLabel());
					break;
				case State_Over:
					moveMC("over" + postLabel());
					break;

				case State_Down:
					moveMC("down" + postLabel());
					break;
				case State_Disable:
					removeListeners();
					moveMC("disabled" + postLabel());
					this.mouseEnabled = false;
					this.mouseChildren = false
					this.buttonMode = false;
					break;

				case State_Selected:
					removeListeners();
					moveMC("selected" + postLabel());
					this.mouseEnabled = false;
					this.mouseChildren = false
					this.buttonMode = true;
					break;
			}

			function postLabel():String
			{
				return (!open ? "2" : "");
			}
		}
		
		
		override protected function onThisFirstClick(event : MouseEvent) : void
		{
			this.open = !this.open;
		}

	}
}
