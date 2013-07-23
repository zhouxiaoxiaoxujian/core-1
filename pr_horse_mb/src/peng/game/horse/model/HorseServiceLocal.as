package peng.game.horse.model
{
	import flash.net.SharedObject;

	import cactus.common.manager.SoundManager;
	import cactus.common.tools.util.ArrayUtils;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.StringUtil;

	/**
	 * 本地服务
	 * @author Peng
	 */
	public class HorseServiceLocal implements IHorseService
	{
		// 定义本地共享

		/**
		 * 记录文件
		 * @default
		 */
		public static const SHARE_OBJ_RECORD:String = "horse_go_record";

		/**
		 * 玩的次数
		 * @default
		 */
		public static const SHARE_OBJ_RECORD_PLAY_COUNT:String = "playCount";

		/**
		 * 飞行距离
		 * @default
		 */
		public static const SHARE_OBJ_RECORD_FLY_DISTANCE:String = "flyDistance";

		/**
		 * 音效是否开启
		 * 1 开启 ， -1 关闭
		 * @default
		 */
		public static const SHARE_OBJ_RECORD_SOUND_ENABLE:String = "soundEnable";


		/**
		 * 玩家安装的装备
		 * @default
		 */
		public static const SHARE_OBJ_RECORD_USER_EQUIPS:String = "userEquips";

		/**
		 * 最高分
		 * @default
		 */
		public static const SHARE_OBJ_RECORD_BEST_SCORE:String = "bestScore";
		/**
		 * 是否为第一次玩游戏
		 * @default
		 */
//		public static const SHARE_OBJ_RECORD_IS_FIRST_PLAY:String = "isFirstPlay";


		/**
		 * 记录文件
		 * @default
		 */
		private var _record:SharedObject;

		public function HorseServiceLocal()
		{
		}

		/**
		 * 加载全部数据
		 */
		public function loadGlobalData(complete:Function):void
		{
			complete();
		}


		public function get record():SharedObject
		{
			if (!_record)
			{
				_record = SharedObject.getLocal(SHARE_OBJ_RECORD);
			}
			return _record;
		}


		// -------------- 肯定用在本地记录的数值 -----------------------
		/**
		 * 声音是否可用
		 * @return
		 */
		public function getSoundEnable():int
		{
			if (record.data[SHARE_OBJ_RECORD_SOUND_ENABLE])
			{
				return int(record.data[SHARE_OBJ_RECORD_SOUND_ENABLE]);
			}
			else
			{
				return 1;
			}
		}

		/**
		 * 设置声音是否可用
		 * @param value
		 */
		public function setSoundEnable(value:int):void
		{
			record.data[SHARE_OBJ_RECORD_SOUND_ENABLE] = value;
			record.flush();

			// call back
			HorseModel.getIns().soundEnable = (value > 0 ? true : false);
		}


		// --------------     数据接口    	 -----------------------

		/**
		 * 获得玩家已经游戏的总场次
		 * @return
		 */
		public function getUserPlayCount(callBack:Function):void
		{
			var ret:int
			if (record.data[SHARE_OBJ_RECORD_PLAY_COUNT])
			{
				ret = int(record.data[SHARE_OBJ_RECORD_PLAY_COUNT]);
			}
			else
			{
				ret = 0;
			}
			callBack(ret);
		}

		/**
		 * 获得玩家已经游戏的总场次
		 * @param value
		 */
		public function setUserPlayCount(value:int, callBack:Function = null):void
		{
			record.data[SHARE_OBJ_RECORD_PLAY_COUNT] = value;
			record.flush();

			if (callBack != null)
			{
				callBack();
			}
		}

		/**
		 * 玩家已经飞行的距离
		 * @return
		 */
		public function getUserFlyDistance(callBack:Function):void
		{
			var ret:int
			if (record.data[SHARE_OBJ_RECORD_FLY_DISTANCE])
			{
				ret = int(record.data[SHARE_OBJ_RECORD_FLY_DISTANCE]);
			}
			else
			{
				ret = 0;
			}

			callBack(ret);
		}

		/**
		 * 设置玩家已经飞行的距离
		 * @param value
		 */
		public function setUserFlyDistance(value:int, callBack:Function = null):void
		{
			record.data[SHARE_OBJ_RECORD_FLY_DISTANCE] = value;
			record.flush();

			if (callBack != null)
			{
				callBack();
			}
		}

		/**
		 * 增加玩家飞行距离
		 * @param value
		 */
		public function addUserFlyDistance(value:int):void
		{
			var distance:int = HorseModel.getIns().userFlyDistance;
			distance += value;
			setUserFlyDistance(distance);

			// call back
			HorseModel.getIns().userFlyDistance = distance;
		}

		/**
		 * 增加玩游戏的次数
		 */
		public function addUserPlayCount():void
		{
			var count:int = HorseModel.getIns().userPlayCount;
			setUserPlayCount(++count);
			// call back
			HorseModel.getIns().userPlayCount = count;
		}

		/**
		 * 获得玩家已经装备的道具
		 * 用字符串分割道具id
		 * @return
		 */
		public function getUserEquipsServerStr(callBack:Function):void
		{
			var ret:String;
			if (record.data[SHARE_OBJ_RECORD_USER_EQUIPS])
			{
				ret = String(record.data[SHARE_OBJ_RECORD_USER_EQUIPS]);
			}
			else
			{
				ret = "";
			}

			callBack(ret);
		}

		/**
		 * 设置玩家已经装备的道具
		 * @param value
		 */
		public function setUserEquipsServerStr(value:String, callBack:Function = null):void
		{
			record.data[SHARE_OBJ_RECORD_USER_EQUIPS] = value;
			record.flush();

			if (callBack != null)
			{
				callBack();
			}
		}

		// =======================================================================
		// ============ 通用方法 =================================================
		// =======================================================================

		/**
		 * 获得数据类型
		 * @param shareObjectKey
		 * @param callBack			这个callback通常不能为空，否则无处获得值哦
		 * @return
		 */
		public function getData(shareObjectKey:String, callBack:Function = null):void
		{
			var ret:String;
			if (record.data[shareObjectKey])
			{
				ret = record.data[shareObjectKey] as String;
			}

			if (callBack != null)
			{
				callBack(ret);
			}
		}

		/**
		 * 保存数据类型
		 * @param value
		 * @param callBack
		 */
		public function setData(shareObjectKey:String, value:String, callBack:Function = null):void
		{
			record.data[shareObjectKey] = value;
			record.flush();

			if (callBack != null)
			{
				callBack(value);
			}
		}

	}
}
