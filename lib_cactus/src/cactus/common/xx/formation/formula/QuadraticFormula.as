package cactus.common.xx.formation.formula
{
	public class QuadraticFormula extends BaseFormula
	{
		
		// 二次方普通式
		// y = ax2 + bx + c
		private var _a:Number;
		private var _b:Number;
		private var _c:Number;
		
		public function QuadraticFormula(params:Object=null)
		{
			super(params);
		}

		
		override protected function exec(item:*):void
		{
			item.x = x;
			item.y = a * x * x  + b * x + c;
		}
		
		public function get c():Number
		{
			return _c;
		}

		public function set c(value:Number):void
		{
			_c = value;
		}

		public function get b():Number
		{
			return _b;
		}

		public function set b(value:Number):void
		{
			_b = value;
		}

		public function get a():Number
		{
			return _a;
		}

		public function set a(value:Number):void
		{
			_a = value;
		}

	}
}