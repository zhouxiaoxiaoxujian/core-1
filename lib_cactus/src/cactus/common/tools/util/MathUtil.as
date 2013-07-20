/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.util
{

	/**
	 * 扩展的数学函数。
	 *
	 * <p>
	 * 常见的包括整数的 random 等。
	 * </p>
	 */
	public class MathUtil
	{

		/**
		 * 返回指定2个非负整数之间的随机数
		 * 注意：若开始数字比结束数字大，则调换两者的值
		 * @param       start   开始(包含)
		 * @param       end             结束(不包含)
		 * @return                      返回值
		 */
		public static function random(start:uint,end:uint):uint
		{
			var num:uint = 0;
			var temp:uint;
			if (start > end)
			{
				//因为 start 是包含、end 是不包含，所以这里要加 1
				temp = start + 1;
				start = end + 1;
				end = temp;
			}
			num = Math.floor((end - start) * Math.random() + start);
			return num;
		}

		/**
		 * 将输入的数限制在给定的最大值与最小值之间，用来强制检查输入
		 * @param       value   要检查的输入
		 * @param       min             最小值
		 * @param       max             最大值
		 * @return                      返回值
		 */
		public static function constrain(value:Number,min:Number = 0,max:Number = 1):Number
		{
			value = Math.max(value,min);
			value = Math.min(value,max);
			return value;
		}

		/**
		 * 将字符串强制转化为浮动变量
		 * @param       string  待转换字符
		 * @return                      转换后数字
		 */
		public static function forceParseFloat(string:String):Number
		{
			var value:Number = parseFloat(string);
			return isNaN(value) ? 0 : value; // returns 0 instead of not a number
		}

		/**
		 * 将字符串强制转化为整型变量
		 * @param       string  待转换字符
		 * @param       radix   待转换的数字的基数（进制）的整数。 合法值为 2 到 36
		 * @return                      转换后数字
		 */
		public static function forceParseInt(string:String,radix:uint = 0):Number
		{
			var value:Number = parseInt(string,radix);
			return isNaN(value) ? 0 : value; // returns 0 instead of not a number
		}

		/**
		 * 在数字前填充0
		 * @param       number  需要填充的数字
		 * @param       digits  填充的位数
		 * @return                      填充后的数字
		 */
		public static function zeroFill(number:Number,digits:uint):String
		{
			//toFixed返回数字的字符串表示形式，参数表示所需的小数位数
			var length:uint = number.toFixed(0).match(/\d/g).length;
			var prefix:String = "";
			if (length < digits)
			{
				var diff:uint = digits - length;
				for (var i:uint = 0;i < diff;i++)
				{
					prefix += "0";
				}
			}
			return prefix + String(number);
		}
	}
}