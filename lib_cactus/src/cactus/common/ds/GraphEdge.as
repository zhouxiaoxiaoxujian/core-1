/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.ds
{
	import cactus.common.ds.abs.IGraphEdge;

	/**
	 * 图边类
	 * @author Peng
	 */
	public class GraphEdge implements IGraphEdge
	{
		/**
		 *
		 * @default
		 */
		private var _from:uint;
		/**
		 *
		 * @default
		 */
		private var _to:uint;
		/**
		 *
		 * @default
		 */
		private var _cost:Number;

		public function GraphEdge($from:uint, $to:uint, $cost:uint)
		{
			_from = $from;
			_to = $to;
			_cost = $cost;
		}

		public function get cost():Number
		{
			return _cost;
		}

		public function set cost(value:Number):void
		{
			_cost = value;
		}

		public function get to():uint
		{
			return _to;
		}

		public function set to(value:uint):void
		{
			_to = value;
		}

		public function get from():uint
		{
			return _from;
		}

		public function set from(value:uint):void
		{
			_from = value;
		}

	}
}
