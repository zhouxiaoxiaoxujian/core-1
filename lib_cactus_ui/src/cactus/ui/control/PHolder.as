package cactus.ui.control
{

	import flash.display.DisplayObject;

	import cactus.ui.bind.PAutoView;

	public class PHolder extends PAutoView
	{
		public function PHolder($sourceName:String = null)
		{
			super($sourceName);
		}

		override public function init():void
		{
			super.init();
			clear();
		}

		/**
		 * 提供不删除原有素材的同时，新增子对象
		 * @param obj
		 * @param needClear
		 */
		public function addPartElement(obj : DisplayObject,needClear:Boolean = false) : void
		{
			if ( needClear)
			{
				clear();	
			}
			addChild(obj);
		}

		public function clear():void
		{
			while (this.numChildren > 0)
			{
				removeChildAt(0);
			}
		}
	}
}