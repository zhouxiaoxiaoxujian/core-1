package peng.game.horse.behaviour2d
{
	import cactus.common.frame.interfaces.IVehicle;

	/**
	 * 弹簧行为
	 * @author Peng
	 */
	public class SpringBehaviour2d extends BaseBehaviour2d
	{

		/**
		 * 弹簧系数 y=kx的k
		 */
		private var _spring:Number=0.01;
		/**
		 * 摩擦力
		 */
		private var _friction:Number=1;
		/**
		 * 目标x
		 */
		private var _targetX:Number;
		/**
		 * 目标y
		 */
		private var _targetY:Number;

		public function SpringBehaviour2d($targetDisplayObject:IVehicle)
		{
			super($targetDisplayObject);
		}

		override public function update(delay:int):void
		{
			var dx:Number=targetX - target.x
			var dy:Number=targetY - target.y;

			var ax:Number=dx * spring;
			var ay:Number=dy * spring;

			target.velocity.x+=ax;
			target.velocity.y+=ay;

			target.velocity.x*=friction;
			target.velocity.y*=friction;
			super.update(delay);
		}

		public function get targetY():Number
		{
			return _targetY;
		}

		public function set targetY(value:Number):void
		{
			_targetY=value;
		}

		public function get targetX():Number
		{
			return _targetX;
		}

		public function set targetX(value:Number):void
		{
			_targetX=value;
		}

		public function get friction():Number
		{
			return _friction;
		}

		public function set friction(value:Number):void
		{
			_friction=value;
		}

		public function get spring():Number
		{
			return _spring;
		}

		public function set spring(value:Number):void
		{
			_spring=value;
		}

	}
}
