package peng.game.horse.view.control
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;

	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.tools.Hook;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.EventBus;
	import cactus.common.tools.util.Pen;
	import peng.game.horse.event.HorseEvent;
	import peng.game.horse.model.HorseModel;
	import peng.game.horse.model.PropVO;
	import cactus.ui.bind.PAutoView;

	/**
	 * 技能栏
	 * @author Peng
	 */
	public class PropRenderer_UI extends PAutoView
	{

		/**
		 * 主容器
		 * @default
		 */
		public var mmc_holder_PB:MovieClip;

		/**
		 * CD倒计时绘制框
		 * @default
		 */
		public var cd_holder_PB:MovieClip;

		/**
		 * CD倒计时绘制框的遮罩
		 * @default
		 */
//		public var mmc_holder_masker_PB:MovieClip;
		public var cd_holder_masker:MovieClip;

		protected var _pen:Pen;

		/**
		 * icon链接名
		 * @default
		 */
		private var _propIconName:String;

		/**
		 * 是否为可点击的模式
		 * @default
		 */
		private var _clickMode:Boolean;

		/**
		 * 剩余冷冻时间
		 * @default
		 */
		private var _remainTime:Number;

		/**
		 * 总冷冻时间
		 * @default
		 */
		private var _frozenTime:Number;

		public function PropRenderer_UI($sourceName:String = null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			_pen = new Pen;
			if (!cd_holder_masker)
			{
				cd_holder_masker = new MovieClip;
				cd_holder_masker.graphics.beginFill(0xff0000);
				cd_holder_masker.graphics.drawRect(0, 0, this.width / this.scaleX, this.height / this.scaleY);
				cd_holder_masker.graphics.endFill();
				addChild(cd_holder_masker);
			}
			cd_holder_PB.mask = cd_holder_masker;
			
		}

		override public function destory():void
		{
			super.destory();

			this.removeEventListener(MouseEvent.CLICK, onThisClick);
		}

		override public function fireDataChange():void
		{
			var vo:PropVO = this.data as PropVO;

			var mc:MovieClip = ResourceFacade.getMC(vo.icon);
			mc.gotoAndStop(1);

			propIconName = vo.icon;
			mmc_holder_PB.addChild(mc);
			
		}

		public function get propIconName():String
		{
			return _propIconName;
		}

		public function set propIconName(value:String):void
		{
			_propIconName = value;
		}


		public function isEmpty():Boolean
		{
			return mmc_holder_PB.numChildren <= 0;
		}

		public function clear():void
		{
			while (mmc_holder_PB.numChildren > 0)
			{
				mmc_holder_PB.removeChildAt(0);
			}
			propIconName = "";
		}

		public function get clickMode():Boolean
		{
			return _clickMode;
		}

		public function set clickMode(value:Boolean):void
		{
			_clickMode = value;

			if (_clickMode)
			{
				this.buttonMode = true;
				this.addEventListener(MouseEvent.CLICK, onThisClick);
			}
			else
			{
				this.buttonMode = false;
			}
		}

		protected function onThisClick(event:MouseEvent):void
		{
			var propVO:PropVO = this.data as PropVO;
			if (remainTime > 0)
			{
				Debugger.debug("cd冷却中", propVO.id);
				return;
			}
			EventBus.getIns().dispatchEvent(new HorseEvent(HorseEvent.USE_ITEM, propVO));

			// 使用过程详见GamePlayScene
			// 改变Renderer的状态
			if (propVO.id == HorseModel.PROP_MAGNET_ID)
			{
				remainTime = Hook.getNumber("magnetFrozenTime");
			}
		}

		public function update(delay:int):void
		{
			_remainTime -= delay;
			_remainTime = Math.max(0, _remainTime);
			drawCountDown()
		}

		public function get remainTime():Number
		{
			return _remainTime;
		}

		public function set remainTime(value:Number):void
		{
			_remainTime = value;
		}

		public function get frozenTime():Number
		{
			if ((this.data as PropVO).id == HorseModel.PROP_MAGNET_ID)
			{
				_frozenTime = Hook.getNumber("magnetFrozenTime");
			}
			return _frozenTime;
		}

//		public function set frozenTime(value:Number):void
//		{
//			_frozenTime = value;
//		}

		/**
		 * 绘制倒计时的圈子
		 */
		protected function drawCountDown():void
		{
			var g:Graphics = cd_holder_PB.graphics;

			// 剩余的时长
			var arcRatio:Number = remainTime / frozenTime;
			var arc:int = 360 * arcRatio;
			//			trace("arc "+arc)

			// 绘制倒计时遮罩
			_pen.target = g;
			_pen.clear();
			_pen.beginFill(0x000000, 0.7);
			_pen.drawSector(0, 0, 60, 0 - arc, -90, 0x000000, .7);
			_pen.endFill();
		}

	}
}
