package peng.game.horse.prop
{
	import cactus.common.frame.interfaces.IDisposeAble;
	import cactus.common.frame.interfaces.IShowView;
	import cactus.common.frame.interfaces.IVehicle;
	import cactus.common.xx.goem.Vector2D;

	/**
	 * 道具接口
	 * @author Peng
	 */
	public interface IProp extends IDisposeAble,IVehicle,IShowView
	{
		// 半径
		function get radius():Number;
		function set radius(value:Number):void;

		function update(delay:int):void;

		/**
		 * 道具和玩家的碰撞
		 */
		function collide(target:IVehicle):void
			
		function initPosition($position:Vector2D):void

	}
}
