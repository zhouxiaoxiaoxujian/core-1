package cactus.common.xx.formation.formula
{

	/**
	 * 公式
	 * 
	 * 外部调用 process方法，可以执行一遍公式
	 * 子类需要覆盖exec等方法，以实现不同的逻辑
	 * @author Peng
	 */
	public class BaseFormula
	{
		// 输入的x起始值
		private var _x:Number;
		
		// 输入的x的间隔值
		private var _sx:Number;
		
		public function BaseFormula(params:Object = null)
		{
			if (params)
			{
				for (var key:String in params)
				{
					this[key] = params[key];
				}
			}
		}

		/**
		 * 根据公式，处理一个item的位置
		 * @param item
		 */
		public function process(item:*):void
		{
			preExec(item);
			exec(item);
			postExec(item);
		}
		
		protected function postExec(item:*):void
		{
			x += sx;
		}
		
		protected function exec(item:*):void
		{
			
		}
		
		protected function preExec(item:*):void
		{
			
		}
		
		public function get sx():Number
		{
			return _sx;
		}

		public function set sx(value:Number):void
		{
			_sx = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}


	}
}