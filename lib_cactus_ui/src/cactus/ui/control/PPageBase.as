/**
 *
 *@author <a href="mailto:Pengxu.he@happyelements.com">Peng</a>
 *@version $Id: PPageBase.as 115190 2012-12-19 03:01:32Z pengxu.he $
 *
 **/
package cactus.ui.control
{
	import cactus.ui.bind.PAutoView;

	/**
	 * 支持分页的PUI
	 * @author: Peng
	 */
	public class PPageBase extends PAutoView
	{
		/**
		 * 当前页数，起始页数为1
		 * @default
		 */
		private var _currPage:int;

		/**
		 * 当前显示页首个元素下标，和currPage同步更新
		 * @default
		 */
		protected var _currIndex : int = 0;



		public function PPageBase($sourceName : String = null)
		{
			super($sourceName);
		}

		override public function fireDataChange() : void
		{
			super.fireDataChange();
//			currIndex = 0;
		}

		public function get currIndex() : int
		{
			return _currIndex;
		}

		public function set currIndex(value : int) : void
		{
			_currIndex = value;
			
			if ( _currIndex <0)
				_currIndex = 0;
			
			if ( _currIndex + getEveryPageCount() >= getModel().length)
				_currIndex = getModel().length - getEveryPageCount();
		}


		public function get currPage() : int
		{
			return (_currIndex / getEveryPageCount()) + 1;
		}
		
		/**
		 * @private
		 */
		public function set currPage(value : int) : void
		{
			_currPage = value;
			
			// 更新下标
			_currIndex = (_currPage - 1) * getEveryPageCount();
			
		}

		/**
		 * 获得所有数据
		 * @return
		 */
		public function getModel() : Array
		{
			throw new Error("未实现");
		}

		/**
		 * 每页需要的数据项
		 * @return
		 */
		public function getEveryPageCount() : int
		{
			throw new Error("未实现");
		}


		/**
		 * 获得总页数
		 * @return
		 */
		public function getTotalPage() : int
		{
			// 余数
			var remainder : int = getModel().length % getEveryPageCount();
			var pageCount : int = getModel().length / getEveryPageCount();

			if (remainder != 0)
				pageCount++;
			return pageCount;
		}

		/**
		 * 获得当前页的数据
		 * @return
		 */
		public function getCurrPageModel() : Array
		{
			return getPageModel(currIndex);
		}

		/**
		 * 获得下一页的数据
		 * @return
		 */
		public function getNextPageModel() : Array
		{
			return getPageModel( currIndex + getEveryPageCount());
		}

		/**
		 * 获得上一页的数据
		 * @return 
		 */
		public function getPrevPageModel():Array
		{
			return getPageModel( currIndex - getEveryPageCount());
		}

		/**
		 * 从startIndex处获得一页的数据模型,数据不足一页时,实际有多少就返回多少
		 * @param startIndex	数据下标
		 * @return
		 */
		protected function getPageModel(startIndex : int) : Array
		{
			var ret : Array = [];

			for (var i : int = 0; i < getEveryPageCount(); i++)
			{
				if ( startIndex + i < 0)
				{
					continue;
				}
				
				if (startIndex + i < getModel().length)
				{
					ret.push(getModel()[startIndex + i]);
				}
			}
			return ret;
		}

		public function nextPage() : void
		{
			if (hasNextPage())
//				currPage++;
				currIndex+=getEveryPageCount();
		}

		public function prevPage() : void
		{
			if (hasPrevPage())
//				currPage--;
				currIndex-=getEveryPageCount();
		}
		
		public function nextItem():void
		{
			if ( hasNextItem())
				currIndex++;
		}
		
		public function prevItem():void
		{
			if ( hasPrevItem())
				currIndex--;
		}

		public function firstPage() : void
		{
//			currPage = 1;
			currIndex = 0;
		}

		public function lastPage() : void
		{
//			currPage = getTotalPage();
			currIndex = getModel().length - getEveryPageCount();
		}

		public function hasNextPage() : Boolean
		{
//			return (currPage != getTotalPage())
			return currIndex+getEveryPageCount() < getModel().length;
		}

		public function hasPrevPage() : Boolean
		{
//			return (currPage != 1);
			return currIndex > 0 ;
		}
		
		public function hasNextItem():Boolean
		{
			return ( currIndex + getEveryPageCount() < getModel().length)
		}
		
		public function hasPrevItem():Boolean
		{
			return ( currIndex != 0 );
		}
		
		public function isFirstPage():Boolean
		{
			return currIndex <= 0;
		}
		
		public function isLastPage():Boolean
		{
			return (currIndex >= (getModel().length - getEveryPageCount()));
		}
	}
}
