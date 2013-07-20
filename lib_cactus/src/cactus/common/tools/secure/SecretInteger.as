package cactus.common.tools.secure
{
	/**
	 * 防止修改内存改数值的整数类
	 *
	 * usecase：
	 * var si:SecretInteger = new SecretInteger();
	 * si.value = 3;
	 * trace(si.value);
	 * @author Peng
	 */
	public class SecretInteger
	{
		public static const INT_SCALE_NUMBER:int = 5;
		
		private var _a:int;
		
		private var _b:int;
		
		private var _c:C;
		
		public function SecretInteger(value:int = 0)
		{
			this.value = value;
		}
		
		public function get value():int
		{
			return (_a + _c.v) / _b;
		}
		
		public function set value(value:int):void
		{
			_b = Math.floor(Math.random() * INT_SCALE_NUMBER) + 1;
			value *= _b;
			
			_a = Math.floor(Math.random() * value);
			_c = new C(value - _a);
		}
	}
}

class C
{
	public var v:int;
	
	public function C(value:int)
	{
		v = value;
	}
}