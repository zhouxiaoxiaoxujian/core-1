package peng.game.horse.prop
{
	import flash.events.Event;

	import peng.common.Config;
	import cactus.common.frame.interfaces.IShowView;
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.xx.goem.Vector2D;
	import cactus.common.xx.sprite.BallVehicle;
	import peng.game.horse.manager.HAIManager;
	import peng.game.horse.manager.HStatManager;
	import cactus.ui.events.ViewEvent;

	/**
	 * horse的基础道具
	 * @author Peng
	 */
	public class BaseProp extends BallVehicle implements IProp
	{
		public static const FLAG_SHOW_OUT:String = "showOut";
		public static const FLAG_SHOW_IN:String = "showIn";

		protected var _initPosition:Vector2D;

		public function BaseProp(pRadius:Number = 10, pColor:uint = 0x000000)
		{
			super(pRadius, pColor);

			addEventListener(ViewEvent.SHOW_INED, onShowIned);
			addEventListener(ViewEvent.SHOW_OUTED, onShowOuted);
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}

		override public function update(delay:int):void
		{
			// 无敌状态，小加速
			if (HStatManager.getIns().zooling)
			{
				velocity.x += Config.ZOOL_ADD_VX;
			}

			super.update(delay);

			// 横向超出左屏幕边界，直接移除道具
			if (this.position.x + this.radius < 0)
			{
				HAIManager.getIns().removeProp(this);
			}

			// 无敌状态，还原速度
			if (HStatManager.getIns().zooling)
			{
				velocity.x -= Config.ZOOL_ADD_VX;
			}
		}

		/**
		 * 道具和玩家的碰撞
		 */
		public function collide(target:IVehicle):void
		{
			throw new Error("no impl");
		}

		/**
		 * 初始化位置
		 * @param $position
		 */
		public function initPosition($position:Vector2D):void
		{
			_initPosition = $position;
			position = $position;
		}

		public function showIn():void
		{
			dispatchEvent(new ViewEvent(ViewEvent.SHOW_INED));
		}

		public function showOut():void
		{
			HAIManager.getIns().removeProp(this);
			dispatchEvent(new ViewEvent(ViewEvent.SHOW_OUTED));
		}

		protected function onShowOuted(event:ViewEvent):void
		{
		}

		protected function onShowIned(event:ViewEvent):void
		{

		}

	}
}
