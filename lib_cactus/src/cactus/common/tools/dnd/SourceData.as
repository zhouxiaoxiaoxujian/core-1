/**
 * Copyright (c) 2010 supperhpxd@yahoo.com.cn
 *
 *
 * @author     Peng
 * @version
 **/
package cactus.common.tools.dnd
{

	/**
	 * 拖拽对象的DragSource
	 * @author Peng
	 */
	public class SourceData
	{

		private var name:String;
		private var data:*;

		public function SourceData(name:String,data:*)
		{
			this.name=name;
			this.data=data;
		}

		public function getName():String
		{
			return name;
		}

		public function getData():*
		{
			return data;
		}
	}
}