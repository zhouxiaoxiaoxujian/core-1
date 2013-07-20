/**
 *
 *@author <a href="mailto:Pengxu.he@happyelements.com">Peng</a>
 *@version $Id: PRectangle.as 115190 2012-12-19 03:01:32Z pengxu.he $
 *
 **/
package cactus.ui.control.classical
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;

	import cactus.ui.control.IPListRenderer;
	import cactus.ui.control.PTileList;

	/**
	 *
	 * 绘制一个矩形
	 * 也是DefaultPTileListRenderer
	 * @author: Peng
	 */
	public class PRectangle extends Sprite implements IPListRenderer
	{
		private var _w : Number;
		private var _h : Number;
		private var _defaultColor : uint;
		private var _selectColor : uint;
		private var _textColor : uint;
		private var _hasChildren : Boolean;

		protected var _text : TextField;


		private var _selected : Boolean;

		/**
		 *
		 * @param $w
		 * @param $h
		 * @param $defaultColor
		 * @param $selectColor
		 * @param $textColor
		 * @param hasChildren
		 */
		public function PRectangle($w : Number = 50, $h : Number = 50, $defaultColor : uint = 0x000000, $selectColor : uint =
			0xff0000, $textColor : uint = 0xffffff, $hasChildren : Boolean = true)
		{
			w = $w;
			h = $h;
			_defaultColor = $defaultColor;
			_selectColor = $selectColor;
			_textColor = $textColor;
			_hasChildren = $hasChildren;
			super();


			draw();
			addChildren();
		}

		public function set data(value : Object) : void
		{
			_data = value;

			if (_text)
			{
				if (value == null)
				{
					_text.text = "";
				}
				else if (value is String)
				{
					_text.text = (value as String);
				}
				else if (value.hasOwnProperty("label") && value.label is String)
				{
					_text.text = value.label.toString();
				}
				else
				{
					_text.text = value.toString();
				}

				_text.text += ":" + getRenderIndex() + ":" + getDataIndex();
			}
		}

		protected var _data : Object;

		public function get data() : Object
		{
			return _data;
		}

		private function addChildren() : void
		{
			if (_hasChildren)
			{
				// WARNING：文本框可能遮挡PList
				if (!_text)
				{
					_text = new TextField();
					//				_text.width = 20;
					//				_text.height = 20;
					_text.width = w;
					_text.height = h;
					_text.textColor = _textColor;
					_text.selectable = false;
					addChild(_text);
				}
			}

		}

		private function draw() : void
		{
			var g : Graphics = this.graphics;
			g.beginFill(_defaultColor);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}

		public function get h() : Number
		{
			return _h;
		}

		public function set h(value : Number) : void
		{
			if (_h == value)
				return;
			_h = value;
		}

		public function get w() : Number
		{
			return _w;
		}

		public function set w(value : Number) : void
		{
			if (_w == value)
				return;
			_w = value;
		}

		public function get selected() : Boolean
		{
			return _selected;
		}

		public function set selected(value : Boolean) : void
		{
			_selected = value;
			var g : Graphics = this.graphics;

//			// 选中的颜色
			if (_selected)
			{
				g.beginFill(_selectColor);
				g.drawRect(0, 0, w, h);
				g.endFill();
			}
			// 未被选中的颜色
			else
			{
				g.beginFill(_defaultColor);
				g.drawRect(0, 0, w, h);
				g.endFill();
			}
		}

		private var _master : PTileList;

		public function get master() : PTileList
		{
			return _master;
		}

		public function set master(value : PTileList) : void
		{
			_master = value;
		}

		/**
		 * 获得Renderer在PTileList中的索引号
		 * @return	如果没有该Renderer，返回-1
		 */
		public function getRenderIndex() : int
		{
			if (!_master || !_master.children)
				return -1;
			return _master.children.indexOf(this);
		}

		/**
		 * 获得Renderer的数据在PTileList中的索引号
		 * @return 如果没有该Data，返回-1
		 */
		public function getDataIndex() : int
		{
			if (!_master || !_master.data)
				return -1;
			return _master.data.indexOf(this.data);
		}
	}
}
