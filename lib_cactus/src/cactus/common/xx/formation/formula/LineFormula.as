package cactus.common.xx.formation.formula
{

	/**
	 * 点斜式直线公式
	 * 
	 * @author Peng
	 */
	public class LineFormula extends BaseFormula
	{
		// 点斜式直线公式
		// y = kx + b
		private var _k:Number;
		private var _b:Number;

		public function LineFormula(params:Object = null)
		{
			super(params);
		}


		override protected function exec(item:*):void
		{
			item.x = x;
			item.y = k * x + b;
		}

		public function get b():Number
		{
			return _b;
		}

		public function set b(value:Number):void
		{
			_b = value;
		}

		public function get k():Number
		{
			return _k;
		}

		public function set k(value:Number):void
		{
			_k = value;
		}

	}
}