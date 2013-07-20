package cactus.common.tools.util
{
	import flash.utils.Dictionary;

	/**
	 * 索引数组和哈希数组的结合体。可以用索引和键两种方式来访问。
	 * <br/>
	 * 此类并没有实例 Array 类的所有方法，如果想使用 Array 类的方法来操作，请访问 array 属性来获得原始的索引数组（Array实例）。
	 * <br/>
	 * 这个类是为了解决这些问题：
	 * <br/>
	 * <ul>
	 * <li>1.索引数组不能像哈希数组那样用键来快速获取指定的项，而哈希数组不能用索引来访问；</li>
	 * <li>2.通过索引作为下标，可以有序地访问索引数组，而哈希数组不能；</li>
	 * </ul>
	 */
	public class ArrayHash
	{
		protected var m_sum : int; // 历史添加过项的最大数
		protected var m_array : Array;
		protected var m_hash : Dictionary;
		protected var m_index2Key : Array; // 知道索引，定位到key
		protected var m_key2Index : Dictionary; // 知道key，定位到索引

		/**
		 * 构造函数。
		 */
		public function ArrayHash()
		{
			this.m_array = [];
			this.m_hash = new Dictionary();
			this.m_index2Key = [];
			this.m_key2Index = new Dictionary();
		}

		public function destory() : void
		{
			this.m_array = [];
			this.m_hash = new Dictionary();
			this.m_index2Key = [];
			this.m_key2Index = new Dictionary();
		}

		/**
		 * 长度。
		 */
		public function get length() : uint
		{
			return this.m_array.length;
		}

		/**
		 * 原始的哈希数组。<b>不能修改其值。</b>
		 */
		public function get hash() : Dictionary
		{
			return this.m_hash;
		}


		/**
		 * 原始的索引数组（返回的是浅复制的副本）。<b>不能修改其值。</b>
		 */
		public function get array() : Array
		{
			return this.m_array;
		}

		/**
		 * 判断指定参数的项是否存在。
		 * @param key 键。
		 * @return
		 */
		public function exist(key : Object) : Boolean
		{
			return Boolean(this.m_hash[key]);
		}

		/**
		 * 使用 strict equality (===) 运算符搜索数组中的项，并返回项的索引位置。
		 * @param item
		 * @param fromIndex
		 * @return
		 */
		public function indexOf(item : Object, fromIndex : * = 0) : int
		{
			return m_array.indexOf(item, fromIndex);
		}

		/**
		 * 向数组末尾添加一个项。添加项时，可指定它在哈希数组里的键。
		 * @param item 项。
		 * @param key 键。
		 * @return 返回数组新长度。
		 */
		public function push(item : Object, key : Object = null) : uint
		{
			if (key == null)
			{
				key = "#key" + this.m_sum;
			}

			if (this.exist(key))
			{
				throw new Error("key 已存在。");
				return 0;
			}

			this.m_sum++;
			var len : uint = this.m_array.push(item);
			this.m_index2Key.push(key);
			this.m_hash[key] = item;
			return len;
		}

		/**
		 * 删除数组最后一个项，并返回该项。
		 * @return 被删除的项。
		 */
		public function pop() : Object
		{
			var item : Object = this.m_array.pop();
			var key : Object = this.m_index2Key.pop();
			delete this.m_hash[key];
			return item;
		}

		/**
		 * 向数组开头添加一个项。添加项时，可指定它在哈希数组里的键。
		 * @param item 项。
		 * @param key 键。
		 * @return 返回数组新长度。
		 */
		public function unshift(item : Object, key : Object = null) : uint
		{
			if (key == null)
			{
				key = "#key" + this.m_sum;
			}

			if (this.exist(key))
			{
				throw new Error("key 已存在。");
				return 0;
			}

			this.m_sum++;
			this.m_array.unshift(item);
			this.m_index2Key.unshift(key);
			this.m_hash[key] = item;
			return this.m_array.length;
		}

		/**
		 * 删除数组第一个项，并返回该项。
		 * @return 被删除的项。
		 */
		public function shift() : Object
		{
			var item : Object = this.m_array.shift();
			var key : Object = this.m_index2Key.shift();
			delete this.m_hash[key];
			return item;
		}

		// 刷新 key2Index 。
		private function refreshKey2Index() : void
		{
			var len : int = this.m_index2Key.length;
			for (var i : int = 0; i < len; i++)
			{
				var key : Object = this.m_index2Key[i];
				this.m_key2Index[key] = i;
			}
		}

		/**
		 * 删除数组中指定的那些项。删除从 startIndex 开始（包含该项）的 deleteCount 个项。
		 * @param startIndex 开始索引。
		 * @param deleteCount 删除的个数。
		 * @return 被删除的那些项。
		 */
		public function splice(startIndex : int, deleteCount : uint) : Array
		{
			var itemArray : Array = this.m_array.splice(startIndex, deleteCount);
			var keyArray : Array = this.m_index2Key.splice(startIndex, deleteCount);
			var len : int = keyArray.length;
			for (var i : int = 0; i < len; i++)
			{
				var key : Object = keyArray[i];
				delete this.m_hash[key];
			}
			return itemArray;
		}

		/**
		 * 在指定的索引处添加项。添加项时，可指定它在哈希数组里的键。
		 * @param item 添加的项。
		 * @param index 添加到的索引处。
		 * @param key 该项在哈希数组中的键。
		 */
		public function addItemAt(item : Object, index : int, key : Object = null) : void
		{
			if (key == null)
			{
				key = "#key" + this.m_sum;
			}

			if (this.exist(key))
			{
				throw new Error("key 已存在。");
				return;
			}

			this.m_sum++;
			this.m_array.splice(index, 0, item);
			this.m_index2Key.splice(index, 0, key);
			this.m_hash[key] = item;
		}

		/**
		 * 删除指定键的项。
		 * @param key 键。
		 */
		public function deleteItemBy(key : Object) : void
		{
			if (!this.m_hash[key])
			{
				return;
			}

			this.refreshKey2Index();
			var index : int = this.m_key2Index[key];
			delete this.m_hash[key];
			delete this.m_key2Index[key];
			this.m_array.splice(index, 1);
			this.m_index2Key.splice(index, 1);
		}

		public function toString() : String
		{
			return this.m_array.toString();
		}

		/**
		 * 获取指定索引的值。
		 * @param index
		 * @return
		 */
		public function getItemAt(index : int) : Object
		{
			return this.m_array[index];
		}

		/**
		 * 获取指定键的值。
		 * @param key
		 * @return
		 *
		 */
		public function getItemBy(key : Object) : Object
		{
			return this.m_hash[key];
		}

		// TODO:
		//              public function reverse():Array;
		//              public function concat(...args):Array;
	}
}
