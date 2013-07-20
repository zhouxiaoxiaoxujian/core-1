package cactus.ui.control.layout
{
	import flash.display.DisplayObjectContainer;

	/**
	 * 
	 * @author Peng
	 */
	public class BaseLayout
	{
		private var _target:DisplayObjectContainer;

		public function BaseLayout()
		{
		}
		
		/**
		 * 被layout的东东
		 * @return 
		 */
		public function get target():DisplayObjectContainer
		{
			return _target;
		}
		
		public function set target(value:DisplayObjectContainer):void
		{
			_target = value;
		}
		
		public function layout():void
		{
			if (!target)
			{
				throw new Error("must set target before do layout");
			}
			doLayout();
		}
		
		protected function doLayout():void
		{
			
		}
	}
}