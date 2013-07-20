/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.ai
{
	import cactus.common.tools.util.ArrayHash;

	/**
	 * AI对象管理器
	 * @author Peng
	 */
	public class AIEntityManager
	{
		private static var _instance : AIEntityManager = new AIEntityManager;
		// 记录全部智能体的当前最大id
		private static var _cid : int = 0;

		private static var _objects : ArrayHash = new ArrayHash();

		public function AIEntityManager()
		{
		}

		public static function getIns() : AIEntityManager
		{
			return _instance;
		}

		public function addEntity(object : IAIObject) : void
		{
			_cid++;
			object.id = _cid;

			_objects.push(object, _cid);
		}

		public function getEnntity(id : int) : IAIObject
		{
			return _objects.getItemBy(id) as IAIObject;
		}

		public function removeEntity(object : IAIObject) : void
		{
			_objects.deleteItemBy(object.id);
		}

		public function removeEntityById(id : int) : void
		{
			_objects.deleteItemBy(id);
		}

	}
}
