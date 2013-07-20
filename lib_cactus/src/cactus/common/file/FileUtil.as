/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.file
{
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	/**
	 * 文件处理工具
	 * @author Peng
	 */
	public class FileUtil
	{
		/**
		 * file目录前缀
		 * @default
		 */
		public static const FILE_PRIFIX:String = "file:///";


		public static const ASCII_TAB:int = 0x0009;
		public static const ASCII_R:int = 0x000A;
		public static const ASCII_ENTER:int = 0x000D;
		public static const ASCII_SP:int = 0x0020;
		public static const ASCII_WELL_NUMBER:int = 35;

		public function FileUtil()
		{
		}

		/**
		 * 将输入字符串转换为合法的路径
		 *
		 * 如 "E:\wsActionGame\peng_ml\src\\" 转换为 "E:/wsActionGame/peng_ml/src/"
		 *    peng.ml.test 						转换为 peng/ml/test
		 * @param input
		 * @return
		 */
		public static function filterToFilePath(input:String):String
		{
			var pattern:RegExp = /\\/g;
			var ret:String = "";
			ret = input.replace(pattern, "/");

			var pattern2:RegExp = /\./g;
			ret = input.replace(pattern2, "/");

			return ret;
		}


		/**
		 * 读取一行
		 * 读完了返回null
		 * @param stream	输入流
		 * @param maxLen	最大长度
		 * @return
		 */
		public static function readLine(stream:FileStream, maxlen:int = 1024):String
		{
			// windows 下的换行符是0x0D 0x0A 即 13 10 是两个Byte
			var buffer:ByteArray = new ByteArray;
			try
			{
				var offset:int = 0;
				var currByte:int = stream.readByte();

				// win换行是0D 0A
				while (currByte != ASCII_ENTER && stream.bytesAvailable > 0)
				{
					buffer.writeByte(currByte);
					offset++;
					currByte = stream.readByte();
				}

				// 写入0D 0A,只适用于win
				buffer.writeByte(currByte);

				currByte = stream.readByte();
				buffer.writeByte(currByte);
			}
			catch (err:Error)
			{
				if ( buffer.length >0)
				{
					return buffer.toString();
				}
				return null;
			}

			return buffer.toString();
		}

	}
}
