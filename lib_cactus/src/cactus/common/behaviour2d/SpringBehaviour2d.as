/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.behaviour2d
{
	import cactus.common.xx.sprite.Vehicle;

	/**
	 * 弹簧行为
	 * @author Peng
	 */
	public class SpringBehaviour2d extends BaseBehaviour2d
	{

		/**
		 * 弹簧系数 y=kx的k
		 */
		private var _spring : Number = 0.01;
		/**
		 * 摩擦力
		 */
		private var _friction : Number = 1;
		/**
		 * 目标x
		 */
		private var _targetX : Number;
		/**
		 * 目标y
		 */
		private var _targetY : Number;

		public function SpringBehaviour2d($owner : Vehicle)
		{
			super($owner);
		}

		/**
		 * 弹簧运动
		 */
		public function springV() : void
		{
			var dx : Number = targetX - owner.x
			var dy : Number = targetY - owner.y;

			var ax : Number = dx * spring;
			var ay : Number = dy * spring;

			owner.velocity.x += ax;
			owner.velocity.y += ay;

			owner.velocity.x *= friction;
			owner.velocity.y *= friction;
		}

		public function get targetY() : Number
		{
			return _targetY;
		}

		public function set targetY(value : Number) : void
		{
			_targetY = value;
		}

		public function get targetX() : Number
		{
			return _targetX;
		}

		public function set targetX(value : Number) : void
		{
			_targetX = value;
		}

		public function get friction() : Number
		{
			return _friction;
		}

		public function set friction(value : Number) : void
		{
			_friction = value;
		}

		public function get spring() : Number
		{
			return _spring;
		}

		public function set spring(value : Number) : void
		{
			_spring = value;
		}

	}
}
