/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 * @create		2010-11-18 下午04:25:13
 * @update
 **/
package cactus.common.tools.util
{
	import mx.core.ByteArrayAsset;

	/**
	 * 二进制绑定资源工厂
	 * @author Peng
	 */
	public class ByteArrayAssetFactory
	{
		public function ByteArrayAssetFactory()
		{
		}

		/**
		 * 创建xml类型资源
		 * @param clazz
		 * @return 
		 */
		public static function createXMLAsset(clazz:Class):XML
		{
			var temp:ByteArrayAsset = ByteArrayAsset(new clazz());
			return new XML(temp.readUTFBytes(temp.length));
		}
	}
}