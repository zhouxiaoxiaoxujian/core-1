package cactus.common.message
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 所有消息的基类
	 * @author Peng
	 *
	 */
	public class AbstractCactusMessage
	{
		public function AbstractCactusMessage()
		{

		}

		private var _isSilence : Boolean;

		/**
		 *消息引发的错误是否做静默处理
		 * @return
		 *
		 */
		public function get isSilence() : Boolean
		{
			return _isSilence;
		}

		/**
		 * 静默处理这个消息引发的错误
		 * @return
		 *
		 */
		public function silence() : AbstractCactusMessage
		{
			_isSilence = true;
			return this;
		}

		/**
		 *返回这个消息的调试信息，用于调试输出
		 * @return
		 *
		 */
		public function get detail() : String
		{
			return _debugInfo;
		}

		private var _debugInfo : String = "";

		/**
		 * 建议在函数的debug最后执行一次：debug("xxx", 0, false);
		 * @param key
		 * @param value
		 * @param overlap
		 *
		 */
		public function debug(key : String, value : *, overlap : Boolean = true) : void
		{
			if (!overlap)
			{
				var reg : RegExp = new RegExp("\\[" + key + ":.*\\],", "gi");
				_debugInfo = _debugInfo.replace(reg, "");
			}

			_debugInfo += "[" + key + ":" + value + "],";
		}

		public function toString() : String
		{
			return getQualifiedClassName(this) + "\ndetail:" + detail;
		}
	}
}
