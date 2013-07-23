package peng.game.horse.model
{

	public interface IHorseService
	{
		/**
		 * 加载全部数据
		 */
		function loadGlobalData(complete:Function):void

		/**
		 * 声音是否可用
		 * @return
		 */
		function getSoundEnable():int

		/**
		 * 设置声音是否可用
		 * @param value
		 */
		function setSoundEnable(value:int):void

			
			
		/**
		 * 获得玩家已经游戏的总场次
		 * @return
		 */
		function getUserPlayCount(callBack:Function):void

		/**
		 * 获得玩家已经游戏的总场次
		 * @param value
		 */
		function setUserPlayCount(value:int,callBack:Function = null):void

		/**
		 * 玩家已经飞行的距离
		 * @return
		 */
		function getUserFlyDistance(callBack:Function):void

		/**
		 * 设置玩家已经飞行的距离
		 * @param value
		 */
		function setUserFlyDistance(value:int,callBack:Function = null):void

		/**
		 * 增加玩家飞行距离
		 * @param value
		 */
		function addUserFlyDistance(value:int):void

		/**
		 * 增加玩游戏的次数
		 */
		function addUserPlayCount():void

		/**
		 * 获得玩家已经装备的道具
		 * 用字符串分割道具id
		 * @return
		 */
		function getUserEquipsServerStr(callBack:Function):void

		/**
		 * 设置玩家已经装备的道具
		 * @param value
		 */
		function setUserEquipsServerStr(value:String,callBack:Function = null):void
			
		/**
		 * 获得数据类型
		 * @param shareObjectKey
		 * @param callBack
		 */
		function getData(shareObjectKey:String, callBack:Function = null):void
		
		/**
		 * 保存数据类型
		 * @param value
		 * @param callBack
		 */
		function setData(shareObjectKey:String, value:String, callBack:Function = null):void
	}
}
