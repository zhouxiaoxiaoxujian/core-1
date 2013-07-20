/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.ds
{

	/**
	 *
	 * @author Peng
	 */
	public class GraphNodeData
	{
		public var key : String;
		public var value : *;

		public function GraphNodeData($key : String, $value : String)
		{
			key = $key;
			value = $value;
		}
	}
}
