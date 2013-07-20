/**
 *
 *@author <a href="mailto:Pengxu.he@happyelements.com">Peng</a>
 *@version $Id: PCheckBox.as 115190 2012-12-19 03:01:32Z pengxu.he $
 *
 **/
package cactus.ui.control
{
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import cactus.ui.bind.PAutoView;
	import cactus.ui.events.ViewEvent;

	/**
	 * 复选框
	 * @author: Peng
	 */
	public class PCheckBox extends PAutoView implements IPGroupItem
	{
		// 文字描述
		public var txt_label_PB : TextField; 

		// 对勾图标
		public var mmc_tick_PB : MovieClip;


		public function PCheckBox($sourceName : String = null)
		{
			super($sourceName);
		}

		override public function init() : void
		{
			super.init();
			mmc_tick_PB.visible = false;
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}

		/**
		 * 设置label文字
		 * @param value
		 */
		public function setLabel(value:String):void
		{
			txt_label_PB.text = value;
		}
		
		protected function onClick(event : MouseEvent) : void
		{
//			mmc_tick_PB.visible = !(mmc_tick_PB.visible);
			selected = !selected;
			dispatchEvent(new ViewEvent(ViewEvent.GROUP_ITEM_SELECT));
		}

		private var _selected:Boolean;
		
		public function get selected() : Boolean
		{
			_selected = (mmc_tick_PB.visible == true); 
			return _selected;
		}

		public function set selected(value : Boolean) : void
		{
			if (_selected == value)
				return;
			
			_selected = value;
			if (value == true)
			{
				mmc_tick_PB.visible = true;
			}
			else
			{
				mmc_tick_PB.visible = false;
			}
		}

	}
}