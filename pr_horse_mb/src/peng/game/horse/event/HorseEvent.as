package peng.game.horse.event
{
	import flash.events.Event;

	public class HorseEvent extends Event
	{

		// ====================================================================
		// ===========================    系统     ============================
		// ====================================================================

		/**
		 * 暂停
		 * @default
		 */
		public static const SYS_PAUSE:String = "SYS_PAUSE";

		/**
		 * 继续
		 * @default
		 */
		public static const SYS_RESUME:String = "SYS_RESUME";


		// ====================================================================
		// ===========================    		     ============================
		// ====================================================================
		/**
		 * 显示苹果核
		 * @default
		 */
		public static const SHOW_APPLE_CORE:String = "SHOW_APPLE_CORE";

		/**
		 * 减掉玩家的苹果数
		 * @default
		 */
		public static const SHOW_SUB_APPLE:String = "SHOW_SUB_APPLE";

		/**
		 * 被玩家击落
		 * @default
		 */
		public static const SHOW_BE_DESTORY:String = "SHOW_BE_DESTORY";

		/**
		 * 添加奖励得分，body指明添加的分数
		 * @default
		 */
		public static const ADD_BOUNS:String = "ADD_BOUNS";

		/**
		 * 点击一个道具
		 * @default
		 */
		public static const CLICK_PROP:String = "CLICK_PROP";

		/**
		 * 点击一个道具里的button，具有状态可点性
		 * @default
		 */
		public static const CLICK_PROP_INNER_BUTTON:String = "CLICK_PROP_INNER_BUTTON";

		/**
		 * 向道具条安装一个道具
		 * @default
		 */
		public static const INSTALL_PROP_TO_SKILL_BAR:String = "INSTALL_PROP_TO_SKILL_BAR";

		/**
		 * 从道具条卸下一个道具
		 * @default
		 */
		public static const UNINSTALL_PROP_FROM_SKILL_BAR:String = "UNINSTALL_PROP_FROM_SKILL_BAR";
		
		/**
		 * 使用道具
		 * @default 
		 */
		public static const USE_ITEM:String = "USE_ITEM";



		// ====================================================================
		// ===========================    UI     ==============================
		// ====================================================================
		/**
		 * 显示技能装备弹窗
		 * @default
		 */
		public static const UI_SHOW_SKILL_POP:String = "UI_SHOW_SKILL_POP";
		/**
		 * 关闭技能面板的弹窗 
		 * @default 
		 */
		public static const UI_CLOSE_SKILL_POP:String = "UI_CLOSE_SKILL_POP";




		public var body:*;

		public function HorseEvent(type:String, $body:*=null, bubbles:Boolean = true)
		{
			body = $body;
			super(type, bubbles);
		}
	}
}
