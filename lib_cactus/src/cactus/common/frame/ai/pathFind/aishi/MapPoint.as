/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.frame.ai.pathFind.aishi
{

	/**
	 *
	 * @author Peng
	 */
	public class MapPoint
	{
		public var F : Number = 0
		public var G : Number = 0
		public var H : Number = 0

		//1代表不可通行区块,0为可通行区块
		public var k : Number = 0

		//是否已经在关闭列表中
		public var isCloseList : Boolean = false

		public var x : Number = 0
		public var y : Number = 0

		public var root : MapPoint


		public function MapPoint(k : int, x : int, y : int)
		{
			this.k = k
			this.x = x
			this.y = y

		}

		public function toString() : String
		{
			return "\tk:" + k + " x:" + x + " y:" + y;
		}

		public function reset() : void
		{
			F = G = H = 0;
			isCloseList = false;
			root = null;
		}

	}

}
