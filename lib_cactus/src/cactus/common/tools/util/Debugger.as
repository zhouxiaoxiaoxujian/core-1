package cactus.common.tools.util
{
	import flash.utils.getQualifiedClassName;

	/**
	 * @author Peng
	 * @version 1.0
	 *
	 */
	public class Debugger
	{

		/*log的级别，0，不打印任何日志，1,打印debug级别，2，打印info级别，3，打印warn级别，4，打印Error级别，5，打印所有级别*/
		public static var logLevel:int=5;

		/*关闭所有日志显示*/
		public static const LOG_CLOSE:int=0;
		/*显示Debug级别的日志*/
		public static const LOG_DEBUG:int=1;
		/*显示info级别的日志*/
		public static const LOG_INFO:int=2;
		/*显示warn级别的日志*/
		public static const LOG_WARN:int=3;
		/*显示error级别的日志*/
		public static const LOG_ERROR:int=4;
		/*显示所有级别的日志*/
		public static const LOG_ALL:int=5;

		/**
		 * 输出日志
		 * @param code
		 * @param type 类型
		 * @param msg  消息体
		 */
		static private function log(type:String, msg:String, code:String="000"):void
		{
			if (logLevel > 0)
			{
				var d:Date=new Date();
				var s:String=d.getHours() + ":" + d.getMinutes() + ":" + d.getSeconds();
				trace(type, "[" + s + "]", msg);
			}
		}

		/**
		 * 输出debug级别日志
		 */
		static public function debug(... args):void
		{
			if (logLevel <= LOG_ALL && logLevel >= LOG_DEBUG)
			{
				log("【DEBUG】", args.join(" "));
			}
		}

		/**
		 * 输出info级别日志
		 */
		static public function info(... args):void
		{
			if (logLevel <= LOG_ALL && logLevel >= LOG_INFO)
			{
				log("【INFO】", args.join(" "));
			}
		}

		/**
		 * 输出info级别日志
		 */
		static public function warn(... args):void
		{
			if (logLevel <= LOG_ALL && logLevel >= LOG_WARN)
			{
				log("【WARN】", args.join(" "));
			}
		}

		/**
		 * 输出Error级别日志
		 */
		static public function error(... args):void
		{
			if (logLevel <= LOG_ALL && logLevel >= LOG_ERROR)
			{
				log("【ERROR】", args.join(" "));
			}
		}

		/**
		 * Describe an object.
		 */
		public static function describe(obj:*):String
		{
			if (obj == null)
				return "null";
			if (obj is String)
				return obj.toString();
			if (obj is Number)
				return obj.toString();
			if (obj is Function)
				return "(Function)";
			if (obj is Array)
				return "[ " + (obj as Array).map(function(item:*, index:int, a:Array):String
				{
					return describe(item);
				}).join(", ") + " ]";

			var entries:Array=[];
			for (var key:String in obj)
			{
				// Make sure we don't stack overflow on cyclical reference
				if (obj[key] == obj)
					continue;
				entries.push(key + ": " + obj[key]);
					// describe(obj[key]));
			}
			if (entries.length > 0)
				return "{" + entries.join(", ") + "}";

			var className:String=getQualifiedClassName(obj);
			return "(" + className + ") " + obj.toString();
		}

		public function Debugger()
		{
		}
	}

}

