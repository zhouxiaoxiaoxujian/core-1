
package cactus.common.tools.util
{

	/**
	 * 集合工具类
	 * @author: Peng
	 */
	public class ArrayUtils
	{

		/**
		 * 将集合中某个字段的值导出到一个数组中
		 * @param arrayOrVector
		 * @param fieldName		如果为空字符串，则将整个数组导出
		 * @return
		 */
		public static function exportField(arrayOrVector : *, fieldName : String = "") : Array
		{
			var ret : Array = [];
			for each (var obj : Object in arrayOrVector)
			{
				if (fieldName == "")
				{
					ret.push(obj);
				}
				else
				{
					ret.push(obj[fieldName]);
				}
			}
			return ret;
		}

		/**
		 * 判断两个数组内的内容是否全部未排序相同
		 * @param oldData	Array
		 * @param newData	Array
		 * @return
		 */
		public static function isEqual(oldData : *, newData : *) : Boolean
		{
			if (oldData == null && newData == null)
				return true;

			if (oldData.length != newData.length)
				return false;

			for each (var oldItem : Object in oldData)
			{
				var hasItem : Boolean = false;
				for each (var newItem : Object in newData)
				{
					if (newItem.toString() == oldItem.toString())
					{
						hasItem = true;
						break;
					}

				}

				if (hasItem == false)
					return false;
			}
			return true;
		}

		/**
		 *
		 * @param v
		 * @return
		 */
		public static function vectorToArray(v : Object) : Array
		{
			var len : int = v.length;
			var ret : Array = new Array(len);
			for (var i : int = 0; i < len; ++i)
			{
				ret[i] = v[i];
			}
			return ret;
		}

		public static function feach(arr : Array, operation : Function) : void
		{
			for (var i : int = 0; i < arr.length; i++)
			{
				operation(arr[i]);
			}
		}

		public static function setSize(arr : Array, size : int) : void
		{
			//TODO test this method
			if (size < 0)
				size = 0;
			if (size == arr.length)
			{
				return;
			}
			if (size > arr.length)
			{
				arr[size - 1] = undefined;
			}
			else
			{
				arr.splice(size);
			}
		}

		public static function removeFromArray(arr : *, obj : Object) : int
		{
			var len : int = arr.length
			for (var i : int = 0; i < len; i++)
			{
				if (arr[i] == obj)
				{
					arr.splice(i, 1);
					return i;
				}
			}
			return -1;
		}

		public static function removeFromArrayToString(arr : *, obj : Object) : int
		{
			var len : int = arr.length
			for (var i : int = 0; i < len; i++)
			{
				if (arr[i].toString() == obj.toString())
				{
					arr.splice(i, 1);
					return i;
				}
			}
			return -1;
		}

		public static function removeAllFromArray(arr : Array, obj : Object) : void
		{
			var len : int = arr.length;
			for (var i : int = 0; i < len; i++)
			{
				if (arr[i] == obj)
				{
					arr.splice(i, 1);
					i--;
				}
			}
		}

		public static function removeAllBehindSomeIndex(array : Array, index : int) : void
		{
			if (index <= 0)
			{
				array.splice(0, array.length);
				return;
			}
			var arrLen : int = array.length;
			for (var i : int = index + 1; i < arrLen; i++)
			{
				array.pop();
			}
		}

		public static function indexInArray(arr : Array, obj : Object) : int
		{
			for (var i : int = 0; i < arr.length; i++)
			{
				if (arr[i] == obj)
				{
					return i;
				}
			}
			return -1;
		}

		public static function cloneArray(arr : Array) : Array
		{
			return arr.concat();
		}

		/**
		 * 在 数组 中是否含有 item 的toString值
		 * @param bag
		 */
		public static function containToString(array : Array, targetItem : *) : Boolean
		{
			for each (var arrItem : * in array)
			{
				if (arrItem.toString() == targetItem.toString())
					return true;
			}
			return false;
		}

		/**
		 * 在 数组 中是否含有 item 的field的toString值
		 * @param bag			传入数组
		 * @param field			数组中对象的字段名
		 * @param targetValue	目标查找值
		 * @return
		 */
		public static function containItem(array : Array, field : String, targetValue : *) : Boolean
		{
			for each (var arrItem : * in array)
			{
				if (arrItem[field].toString() == targetValue.toString())
					return true;
			}
			return false;
		}

		/**
		 * 返回targetItem 的下标 没有就来个-1
		 * @param bag
		 */
		public static function getItemIndex(array : Array, targetItem : *) : int
		{
			var len : int = array.length;
			for (var i : int = 0; i < len; i++)
			{
				if (array[i].toString() == targetItem.toString())
					return i;
			}

			return -1;
		}
	}
}
