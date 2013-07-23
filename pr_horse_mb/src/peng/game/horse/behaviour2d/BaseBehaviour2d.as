package peng.game.horse.behaviour2d
{
	import flash.display.DisplayObject;

	import cactus.common.frame.interfaces.IVehicle;

	/**
	 * 基础行为
	 * @author Peng
	 */
	public class BaseBehaviour2d
	{
		/**
		 * 行为目标，即执行行为的主角
		 */
		private var _target:IVehicle;

		public function BaseBehaviour2d($targetDisplayObject:IVehicle)
		{
			_target=$targetDisplayObject;
		} 

		public function get target():IVehicle
		{
			return _target;
		}

		public function set target(value:IVehicle):void
		{
			_target=value;
		}

		public function update(delay:int):void
		{
		}
	}
}
