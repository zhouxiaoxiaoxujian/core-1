package cactus.ui.bind
{

	public class POperator
	{
		public function POperator()
		{
		}

		public static function Op(a:*, op:String, b:*):Boolean
		{
			switch (op)
			{
				case ">":
					return a > b;
				case ">=":
					return a >= b;
				case "=":
					return a == b;
				case "==":
					return a == b;
				case "<=":
					return a <= b;
				case "<":
					return a < b;
				case "!=":
					return a != b;
				case "@":
					return a.indexOf(b) != -1;
				case "@<":
					return a.lastIndexOf(b) == (a.length - b.length) && (a.length - b.length) != -1;
				case "@>":
					return a.indexOf(b) == 0;
			}
			return false;
		}


		public static function OpArr(ops:Array):Boolean
		{
			return Op.apply(null, ops);
		}


		public static function Calc(a:*, op:String, b:*):*
		{
			if (a is String)
			{
				b = String(b)
			}
			else
			{
				b = Number(b);
			}
			switch (op)
			{
				case "+":
					return a + b;
				case "-":
					return a - b;
				case "*":
					return a * b;
				case "/":
					return a / b;
				case "%":
					return a % b;
			}
			return null;
		}


		public static function ParseOp(filter:String):Array
		{
			var f:RegExp = /([^@><=!]*)([@><=!]+)([^@><=!]*)/
			var c:Array = filter.match(f);
			if (c.length != 4)
				return null;
			return [c[1], c[2], c[3]];
		}

	}
}