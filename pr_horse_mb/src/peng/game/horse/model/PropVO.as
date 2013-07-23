package peng.game.horse.model
{
	import cactus.common.tools.util.Debugger;

	/**
	 *
	 * @author Peng
	 */
	public class PropVO
	{

		/**
		 *
		 * @default
		 */
		public var id:int;
		/**
		 * 名称
		 * @default
		 */
		public var name:String;
		/**
		 * 描述
		 * @default
		 */
		public var desc:String;
		/**
		 * 技能类型 
		 * @default 
		 */
		public var skillType:SkillType;
		/**
		 * 图标链接
		 * @default
		 */
		public var icon:String;
		/**
		 * 需要玩的游戏场次解锁
		 * @default
		 */
		public var needPlay:int;

		/**
		 * 正常的tip
		 * @default 
		 */
		public var normalTip:String;

		/**
		 * 文件选中的tip
		 * @default 
		 */
		public var selectedTip:String;

		private static var _list:Array = new Array;

		public function PropVO()
		{
		}

		public static function parse(dictProp:XML):void
		{
			for each (var line:XML in dictProp.item)
			{
				var vo:PropVO = new PropVO;
				vo.id = int(line.attribute("id"));
				vo.name = String(line.attribute("name"));
				vo.desc = String(line.attribute("desc"));
				vo.icon = String(line.attribute("icon"));
				vo.skillType = new SkillType(int(line.attribute("type")));
				vo.needPlay = int(line.attribute("needPlay"));
				vo.normalTip = String(line.attribute("normalTip"));
				vo.selectedTip = String(line.attribute("selectedTip"));
				
				_list.push(vo);
			}
		}

		public static function getList():Array
		{
			return _list;
		}

		public static function getVOById(pid:int):PropVO
		{
			for each (var item:PropVO in _list)
				if (item.id == pid)
					return item;

			Debugger.info("没有找到道具", pid);
			return null;
		}

		public function isPassivitySkill():Boolean
		{
			return skillType.type == SkillType.PASSIVITY;
		}

		public function toString():String
		{
			return id.toString();
		}

	}
}

class SkillType
{
	/**
	 * 被动技能
	 * @default 
	 */
	public static const PASSIVITY:int = 1;
	/**
	 * 主动技能
	 * @default 
	 */
	public static const INITIATIVE:int = 2;
	
	public var type:int ;
	
	public function SkillType($type:int)
	{
		type = $type;
	}
}
