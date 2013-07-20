package cactus.common.tools
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import cactus.common.frame.interfaces.ISelected;


	public class ToolTip
	{
		private static var _instance:ToolTip;

		private var _globalTextTarget:*;
		private var _globalDefaultText:String = "";

		private var _table:Dictionary = new Dictionary(true);

		public function ToolTip(param:Singleton)
		{

		}

		public static function getInstance():ToolTip
		{
			if (ToolTip._instance == null)
			{
				ToolTip._instance = new ToolTip(new Singleton);
			}
			return ToolTip._instance;
		}

		/**
		 * 设置全局文本提示对象
		 * 对全局设置tip之前必须调用
		 * @param target
		 */
		public function setGlobalTextTarget(target:*, $defaultText:String):void
		{
			_globalTextTarget = target;
			_globalDefaultText = $defaultText;
			_globalTextTarget.text = $defaultText;
		}
		
		/**
		 * 
		 * @param target
		 */
		public function removeGlobalTextTarget(target:*):void
		{
			
		}

		/**
		 * 设置全局tip文本
		 * @param normalTip
		 * @param selectedTip
		 */
		public function setGlobalTextTip(target:ISelected, normalTip:String, selectedTip:String = null):void
		{
			if (_table[target])
			{
				delete _table[target];
			}
			_table[target] = [normalTip, selectedTip];
			target.addEventListener(MouseEvent.ROLL_OVER, onGlobalRollOver, false, 0, true);
			target.addEventListener(MouseEvent.ROLL_OUT, onGlobalRollOut, false, 0, true);
			target.addEventListener(Event.REMOVED_FROM_STAGE, onGlobalRollOut, false, 0, true);
		}

		/**
		 * 删除全局tip文本
		 * @param target
		 */
		public function removeGlobalTextTip(target:ISelected):void
		{
			if (_table[target])
			{
				delete _table[target];
				target.removeEventListener(MouseEvent.ROLL_OVER, onGlobalRollOver, false);
				target.removeEventListener(MouseEvent.ROLL_OUT, onGlobalRollOut, false);
				target.removeEventListener(Event.REMOVED_FROM_STAGE, onGlobalRollOut, false);
			}
		}

		private function onGlobalRollOver(e:MouseEvent):void
		{
			var target:ISelected = e.currentTarget as ISelected;
			var params:Array = _table[target] as Array;

			if (target.isSelected() && params[1])
			{
				_globalTextTarget.text = params[1].toString();
			}
			else
			{
				_globalTextTarget.text = params[0].toString();
			}
		}

		private function onGlobalRollOut(e:Event):void
		{
			_globalTextTarget.text = _globalDefaultText.toString();
		}


//		/**
//		 * 设置提示
//		 * @param target 显示对象
//		 * @param text   提示文本 或 复杂UI的数据
//		 * @param complexUI
//		 */
//		public function setTip(target:DisplayObject, textOrData:*, complexUI:* = null):void
//		{
//			_table[target] = text;
//			target.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
//			target.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
//			target.addEventListener(Event.REMOVED_FROM_STAGE, onRollOut, false, 0, true);
//		}
//
//		/**
//		 * 移除tip
//		 * @param target
//		 */
//		public function removeTip(target:DisplayObject):void
//		{
//			_table[target] = null;
//			target.removeEventListener(MouseEvent.ROLL_OVER, onRollOver, false);
//			target.removeEventListener(MouseEvent.ROLL_OUT, onRollOut, false);
//			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRollOut, false);
//		}
//
//		private function onRollOver(e:MouseEvent):void
//		{
//			var target:DisplayObject = e.currentTarget as DisplayObject;
//			var container:DisplayObjectContainer = target.stage as DisplayObjectContainer; //parent -> stage
//			removeOldTip(container);
//			var tip:Tip = new Tip();
//
//			container.addChild(tip); //first	
//			tip.name = "tip";
//			tip.setTargetBounds(target.getBounds(container));
//			tip.setText(_table[target]);
//			tip.updateSize();
//		}
//
//		private function onRollOut(e:Event):void
//		{
//			var target:DisplayObject = e.currentTarget as DisplayObject;
//			var container:DisplayObjectContainer = target.stage as DisplayObjectContainer; //parent -> stage
//			removeOldTip(container);
//		}
//
//		public function removeOldTip(container:DisplayObjectContainer):void
//		{
//			if (container == null)
//				return;
//			var tip:DisplayObject = container.getChildByName("tip"); //parent -> stage
//			if (tip)
//				container.removeChild(tip); //parent -> stage
//		}
	}
}

class Singleton
{
}
