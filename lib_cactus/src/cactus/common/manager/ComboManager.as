/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.manager
{
	import flash.utils.Dictionary;

	/**
	 * 组合技管理器
	 * @author Peng
	 */
	public class ComboManager
	{
		private static var _instance : ComboManager = new ComboManager;

		// 组合项目，数组中的每一项称为一个组合项
		// 每个组合项拥有自己的组合时间间隔，当前组合值等信息
		// 不同的使用地方，请使用不同的枚举
		private var _comboItems : Dictionary = new Dictionary;

		public function ComboManager()
		{
		}

		public static function getIns() : ComboManager
		{
			return _instance;
		}

		/**
		 * 新增一个组合项目
		 * @param key
		 * @param interval
		 */
		public function addComboItem(key : String, interval : int) : void
		{
			_comboItems[key] = (new ComboItem(key, 0, interval));
		}

		/**
		 * 删除一个组合项目
		 * @param key
		 */
		public function removeComboItem(key : String) : void
		{
			delete _comboItems[key];
		}

		/**
		 * 删除所有组合技
		 */
		public function removeAllComboItems() : void
		{
			_comboItems = new Dictionary;
		}

		/**
		 * 重置所有组合项的当前值，其他不变
		 */
		public function resetAllComboItems() : void
		{
			for each (var item : ComboItem in _comboItems)
			{
				item.currentValue = 0;
			}
		}

		/**
		 * 获得combo的当前值
		 * @param key
		 */
		public function getComboValue(key : String) : int
		{
			return ComboItem(_comboItems[key]).currentValue;
		}

		/**
		 * 激活combo，默认
		 * @param key
		 * @param count
		 * @return 获得combo的当前值
		 */
		public function activeCombo(key : String, count : int = 1) : int
		{
			ComboItem(_comboItems[key]).currentValue += count;
			return getComboValue(key);
		}

		/**
		 * 重置某一个combo
		 */
		public function resetCombo(key : String) : void
		{
			ComboItem(_comboItems[key]).currentValue = 0;
		}

		/**
		 * 游戏更新被使用
		 * @param delay
		 */
		public function update(delay : int) : void
		{
			for each (var item : ComboItem in _comboItems)
			{
				item.simValue += delay;
			}
		}
	}
}

class ComboItem
{

	public function ComboItem($key : String, $value : int = 0, $interval : int = int.MAX_VALUE, $maxValue : int = int.MAX_VALUE)
	{
		key = $key;
		currentValue = $value;
		interval = $interval;
		maxValue = $maxValue;
	}

	// 当前组合的名称,起到主键的作用
	public var key : String;

	// 当前组合累积值
	private var _currentValue : int;

	// 当前组合使用的时间间隔，毫秒
	// 如果combo不受时间限制，可将该值设置为int.max_value
	public var interval : int;

	// 累积记录时间,即没有发出组合技的时间
	private var _simValue : int;

	// 最大的连击值
	private var _maxValue : int;

	public function get maxValue() : int
	{
		return _maxValue;
	}

	public function set maxValue(value : int) : void
	{
		_maxValue = value;
	}

	public function get currentValue() : int
	{
		return _currentValue;
	}

	public function set currentValue(value : int) : void
	{
		_currentValue = value;
		if (value > 0)
			_simValue = 0;
	}

	public function get simValue() : int
	{
		return _simValue;
	}

	public function set simValue(value : int) : void
	{
		_simValue = value;

		// 超过了超时时间
		if (_simValue >= interval)
		{
			// 不用清除累积时间
			// _simValue = 0;
			currentValue = 0;
		}
	}
}
