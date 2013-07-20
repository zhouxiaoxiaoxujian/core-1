package cactus.ui.control
{
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	import cactus.ui.events.ViewEvent;

	/**
	 *
	 * @author Peng
	 */
	public class PButton extends MovieClip implements IPGroupItem
	{
		public static const LABEL_STATE_UP:String = "up";
		public static const LABEL_STATE_OVER:String = "over";
		public static const LABEL_STATE_DOWN:String = "down";
		public static const LABEL_STATE_DISABLED:String = "disabled";
		public static const LABEL_STATE_SELECTED:String = "selected";

		static protected const State_Up:int = 1;
		static protected const State_Over:int = 2;
		static protected const State_Down:int = 3;
		static protected const State_Disable:int = 4;
		static protected const State_Selected:int = 5;

		protected var _currState:int;
		protected var _data:Object;
		protected var _source:MovieClip;
		protected var _labels:Object = {};


		private var _autoDestory:Boolean;

		public function PButton(mc:MovieClip = null, $autoDestory:Boolean = true, $lazyTime:Number = 500):void
		{
			_autoDestory = $autoDestory;
			if (mc)
			{
				this.source = mc;
			}
			_lazyTime = $lazyTime;
		}

		public function set lazyTime(value:Number):void
		{
			_lazyTime = value;
		}

		public function set autoDestory(value:Boolean):void
		{
			_autoDestory = value;
			
			if (_autoDestory)
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent)
			}
			else
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent)
			}
		}

		/**
		 * 在设置source之后进行init()
		 */
		public function init():void
		{
			this.name = source.name;
			this.addEventListener(Event.ADDED_TO_STAGE, addStageEvent)
			if (_autoDestory)
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent)
			}
			this.addEventListener(MouseEvent.CLICK, onThisFirstClick, false, int.MAX_VALUE);
		}

		public function destory():void
		{
			removeListeners()
			this.removeEventListener(MouseEvent.CLICK, onThisFirstClick);
			if (_autoDestory)
			{
				this.removeEventListener(Event.ADDED_TO_STAGE, addStageEvent)
			}

			enabled = true

			selected = false
			_source.stop();
			_source = null;
		}

		public function set source(mc:MovieClip):void
		{
			_source = mc;
			mc.mouseChildren = false;

			var labels:Array = mc.currentLabels;
			for each (var frameLabel:FrameLabel in labels)
			{
				_labels[frameLabel.name] = frameLabel.frame;
			}
			this.enabled = true;

			init();
		}

		public function get source():MovieClip
		{
			return _source;
		}

		/**
		 * 复制属性
		 * @param child
		 *
		 */
		public function copyProperty(child:PButton):void
		{
			this.enabled = child.enabled
			this.selected = child.selected
		}

		public function get data():Object
		{
			return _data;
		}

		public function set data(value:Object):void
		{
			_data = value;
		}

		/**
		 * 设置文本
		 * @param labelTxt
		 */
		public function setLabel(labelTxt:String):void
		{
			_source["txt_label"].text = labelTxt.toString();
		}

		/**
		 * 获得引用
		 * @return
		 */
		public function getLabelRef():TextField
		{
			return _source["txt_label"];
		}

		/**
		 * 获得当前状态
		 * @return
		 */
		public function get currState():int
		{
			return _currState;
		}

		/**
		 * 当本按钮按下，优先级最高的点击事件
		 * @param event
		 */
		protected function onThisFirstClick(event:MouseEvent):void
		{
			if (!this.enabled || !_internalEnable)
			{
				event.stopImmediatePropagation();
				return;
			}
			dispatchEvent(new ViewEvent(ViewEvent.GROUP_ITEM_SELECT));

			// 一段时间内暂时处理为不可用
			this.enabled = false; // todo

			_internalEnable = false;
			_inTimeOutState = true;
			_timeOutId = setTimeout(__lazyEnableJugger, _lazyTime);
		}

		private var _timeOutId:uint;
		// 是否在timeout阶段
		private var _inTimeOutState:Boolean;
		private var _timeOutStateHasSomeChange:Boolean;
		private var _internalEnable:Boolean = true;

		// 延迟的时间
		private var _lazyTime:Number;
		private var _selectFlag:Boolean;

		private function __lazyEnableJugger():void
		{
			// 若在timeOut阶段改按钮设置为false，则不必还原为true状态
			if (_timeOutStateHasSomeChange)
			{
				//  do nothing
				selected = _selectFlag;
				enabled = _internalEnable;
			}
			else
			{
				enabled = true;
				selected = _selectFlag;
			}
			// to do end
			_timeOutStateHasSomeChange = false;
			_internalEnable = true;
			_inTimeOutState = false;
			clearTimeout(_timeOutId);
		}

		/**
		 * 是否启用
		 */
		public override function set enabled(value:Boolean):void
		{
			if (value)
			{
				updateState(State_Up);
			}
			else
			{
				updateState(State_Disable);
			}
		}

		/**
		 * 是否启用
		 */
		public override function get enabled():Boolean
		{
			return _currState != State_Disable;
		}

		/**
		 * 选中状态
		 */
		public function set selected(value:Boolean):void
		{
			if (value)
			{
				updateState(State_Selected);
			}
			else
			{
				updateState(State_Up);
			}
		}

		/**
		 * 选中状态
		 */
		public function get selected():Boolean
		{
			return _currState == State_Selected;
		}

		/**
		 * 更新状态
		 * @param	state
		 */
		protected function updateState(state:int):void
		{
			configListeners();
			this.mouseEnabled = true;
			this.buttonMode = true;
			this.mouseChildren = true

			_currState = state;

			switch (state)
			{
				case State_Up:
					moveMC("up");
					break;

				case State_Over:
					moveMC("over");
					break;

				case State_Down:
					moveMC("down");
					break;

				case State_Disable:
					// removeListeners();
					moveMC("disabled");
					this.mouseEnabled = true;
					this.mouseChildren = true
					this.buttonMode = false;
					break;

				case State_Selected:
					removeListeners();
					moveMC("selected");
					this.mouseEnabled = true;
					this.mouseChildren = true
					this.buttonMode = true;
					break;
			}
		}

		/**
		 * 在获得source之后，
		 * @param e
		 */
		protected function addStageEvent(e:Event):void
		{
			configListeners()
			source.x = 0
			source.y = 0
			this.addChild(source)
		}

		protected function removeStageEvent(e:Event):void
		{
			destory();
		}

		protected function configListeners():void
		{
			if (_source)
			{
				_source.addEventListener(MouseEvent.ROLL_OVER, mcRollOverHandler);
				_source.addEventListener(MouseEvent.ROLL_OUT, mcRollOutHandler);
				_source.addEventListener(MouseEvent.MOUSE_DOWN, mcMouseDownHandler);
				_source.addEventListener(MouseEvent.MOUSE_UP, mcMouseUpHandler);
			}
		}

		protected function removeListeners():void
		{
			if (_source)
			{
				_source.removeEventListener(MouseEvent.ROLL_OVER, mcRollOverHandler);
				_source.removeEventListener(MouseEvent.ROLL_OUT, mcRollOutHandler);
				_source.removeEventListener(MouseEvent.MOUSE_DOWN, mcMouseDownHandler);
				_source.removeEventListener(MouseEvent.MOUSE_UP, mcMouseUpHandler);
			}
		}

		protected function moveMC(label:String):void
		{
			if (_labels[label] != null && _source)
			{
				_source.gotoAndStop(label);
			}
		}

		private function mcRollOverHandler(evt:MouseEvent):void
		{
			if (_currState != State_Disable)
			{
				updateState(State_Over);
			}

		}

		private function mcRollOutHandler(evt:MouseEvent):void
		{
			if (_currState != State_Disable)
			{
				updateState(State_Up);
			}
		}

		private function mcMouseDownHandler(evt:MouseEvent):void
		{
			if (_currState != State_Disable)
			{
				updateState(State_Down);
			}

		}

		private function mcMouseUpHandler(evt:MouseEvent):void
		{
			if (_currState != State_Disable)
			{
				updateState(State_Over);
			}

		}

	}

}
