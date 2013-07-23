package peng.game.horse.model
{
	import flash.net.SharedObject;
	
	import cactus.common.manager.SoundManager;
	import cactus.common.tools.util.ArrayUtils;
	import cactus.common.tools.util.Debugger;
	import cactus.common.tools.util.StringUtil;

	/**
	 * 模型
	 * @author Peng
	 */
	public class HorseModel
	{
		public static const PROP_MAGNET_ID:int = 4;
		
		
		// 道具字典
		public static const dictProp:XML = <props>
				<item id="0" name="apple" desc="apple desc" type="1" icon="Prop1" needPlay="1000" normalTip="shop_item1_normal" selectedTip="shop_item1_selected"/>
				<item id="1" name="better bounce" desc="better bounce desc" type="1" icon="Prop2" needPlay="5000" normalTip="shop_item2_normal" selectedTip="shop_item2_selected"/>
				<item id="2" name="armor" desc="armor desc" type="1" icon="Prop3" needPlay="15000" normalTip="shop_item3_normal" selectedTip="shop_item3_selected"/>
				<item id="4" name="magnet" desc="magnet desc" type="2" icon="Prop5" needPlay="30000" normalTip="shop_item5_normal" selectedTip="shop_item5_selected"/>
				
			</props>;

		private static var _instance:HorseModel = new HorseModel;

		// --------- 玩家身上最多装两个道具 ---------
		// --------- 道具模型 -------------

		/**
		 * 增加默认苹果
		 */
		private var _hasMoreApples:Boolean;

		/**
		 * 增加触底弹力
		 */
		private var _hasBetterBounce:Boolean;

		/**
		 * 增加铠甲
		 */
		private var _hasArmor:Boolean;

		/**
		 * 连续上楼的旋风
		 */
		private var _hasWarpUp:Boolean;

		/**
		 * 磁铁
		 */
		private var _hasMagnet:Boolean;

		/**
		 *火箭
		 */
		private var _hasRocket:Boolean;

		// --------- 道具模型  结束-------------

		/**
		 * 玩家拥有的道具字符串形式
		 * @default
		 */
		private var _userEquipsServerStr:String;

		/**
		 * 玩家拥有的道具
		 * @default
		 */
		private var _userEquips:Array;

		/**
		 * 声音是否可用
		 * @default
		 */
		private var _soundEnable:Boolean;

		/**
		 * 玩家玩游戏的次数
		 * @default
		 */
		private var _userPlayCount:int;

		/**
		 * 玩家飞行累积距离
		 * @default
		 */
		private var _userFlyDistance:int;
		
		/**
		 * 玩家的最高分
		 * @default 
		 */
		private var _bestScore:int;

		public function HorseModel()
		{
			PropVO.parse(dictProp);
		}

		/**
		 * 初始化全局数据
		 */
		public function init():void
		{
			// 是否开启音乐
			SoundManager.soundEnable = SoundManager.bgSoundEnable = soundEnable;

			Debugger.info("[启动]声音状态", SoundManager.soundEnable, SoundManager.bgSoundEnable);
		}

		public function get bestScore():int
		{
			return _bestScore;
		}
		
		public function set bestScore(value:int):void
		{
			_bestScore = value;
		}
		
		public function get userFlyDistance():int
		{
			return _userFlyDistance;
		}

		public function set userFlyDistance(value:int):void
		{
			_userFlyDistance = value;
		}

		public function get userPlayCount():int
		{
			return _userPlayCount;
		}

		public function set userPlayCount(value:int):void
		{
			_userPlayCount = value;
		}

		public function get soundEnable():Boolean
		{
			return _soundEnable;
		}

		public function set soundEnable(value:Boolean):void
		{
			_soundEnable = value;
		}

		/**
		 * 获得全部系统道具
		 * @return
		 */
		public function getAllProp():Array
		{
			return PropVO.getList();
		}

		/**
		 * 获得玩家已经装备的道具
		 * T	PropVO
		 * @return
		 */
		public function getUserEquips():Array
		{
			if (!_userEquips)
			{
				_userEquips = new Array;
			}
			return _userEquips;
		}

		/**
		 * 设置玩家已经装备的道具
		 * @param value
		 */
		public function setUserEquips(value:Array):void
		{
			_userEquips = value;
		}

		/**
		 * 是否拥有装备位置
		 * @return
		 */
		public function hasEquipPlace():Boolean
		{
			return getUserEquips().length < 2;
		}

		/**
		 * 判断玩家是否装备了指定道具
		 * @param vo
		 * @return
		 */
		public function hasInstall(vo:PropVO):Boolean
		{
			return ArrayUtils.containToString(getUserEquips(), vo);
		}

		public function hasInstallById(id:int):Boolean
		{
			var vo:PropVO = new PropVO;
			vo.id = id;
			return hasInstall(vo);
		}

		/**
		 * 安装装备
		 * @param vo
		 */
		public function installEquip(vo:PropVO):void
		{
			getUserEquips().push(vo);
		}

		/**
		 * 卸载装备
		 * @param vo
		 */
		public function uninstallEquip(vo:PropVO):void
		{
			ArrayUtils.removeFromArrayToString(getUserEquips(), vo);
		}




		public function get hasRocket():Boolean
		{
			return _hasRocket;
		}

		public function set hasRocket(value:Boolean):void
		{
			_hasRocket = value;
		}

		public function get hasMagnet():Boolean
		{
			return _hasMagnet;
		}

		public function set hasMagnet(value:Boolean):void
		{
			_hasMagnet = value;
		}

		public function get hasWarpUp():Boolean
		{
			return _hasWarpUp;
		}

		public function set hasWarpUp(value:Boolean):void
		{
			_hasWarpUp = value;
		}

		public function get hasArmor():Boolean
		{
			return _hasArmor;
		}

		public function set hasArmor(value:Boolean):void
		{
			_hasArmor = value;
		}

		public function get hasBetterBounce():Boolean
		{
			return _hasBetterBounce;
		}

		public function set hasBetterBounce(value:Boolean):void
		{
			_hasBetterBounce = value;
		}

		public function get hasMoreApples():Boolean
		{
			return _hasMoreApples;
		}

		public function set hasMoreApples(value:Boolean):void
		{
			_hasMoreApples = value;
		}

		public static function getIns():HorseModel
		{
			return _instance;
		}

		/**
		 *
		 *
		 */
		public function destory():void
		{
			_hasMoreApples = false;
			_hasBetterBounce = false;
			_hasArmor = false;
			_hasWarpUp = false;
			_hasMagnet = false;
			_hasRocket = false;
		}

		/**
		 * 在游戏开始之前，根据持有道具，初始化属性
		 */
		public function initEquip():void
		{
			_hasMoreApples = false;
			_hasBetterBounce = false;
			_hasArmor = false;
			_hasWarpUp = false;
			_hasMagnet = false;
			_hasRocket = false;

			var debugRet:String = "";

			if (hasInstallById(0))
			{
				debugRet += "0,"
				_hasMoreApples = true;
			}

			if (hasInstallById(1))
			{
				debugRet += "1,"
				_hasBetterBounce = true;
			}

			if (hasInstallById(2))
			{
				debugRet += "2,"
				_hasArmor = true;
			}

			if (hasInstallById(3))
			{
				debugRet += "3,"
				_hasWarpUp = true;
			}

			if (hasInstallById(4))
			{
				debugRet += "4,"
				_hasMagnet = true;
			}

			if (hasInstallById(5))
			{
				debugRet += "5,"
				_hasRocket = true;
			}

			Debugger.info("游戏使用的道具" + debugRet);

		}

	}
}
