/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.render
{
	import flash.display.Graphics;


	/**
	 * 网格渲染器
	 * @author Peng
	 */
	public class GridRender extends BaseRender
	{
		private var _tileWidth : Number;
		private var _tileHeight : Number;
		private var _cols : int;
		private var _rows : int;


		public function GridRender($tileWidth : Number, $tileHeight : Number, $cols : Number, $rows : Number)
		{
			_tileWidth = $tileWidth;
			_tileHeight = $tileHeight;
			_cols = $cols;
			_rows = $rows;
		}

		/**
		 * 渲染
		 * @param isStatic	true，代表只渲染一次
		 */
		override public function draw() : void
		{
			if (_willRender)
			{
				// 具体的渲染算法
				var g : Graphics = paper.graphics;
				g.lineStyle(1, 0x000000);

				// 画横线
				for (var row : int = 0; row <= rows; row++)
				{
					g.moveTo(0, row * tileHeight);
					g.lineTo(tileWidth * cols, row * tileHeight);
				}

				// 画竖线
				for (var col : int = 0; col <= cols; col++)
				{
					g.moveTo(col * tileWidth, 0);
					g.lineTo(col * tileWidth, tileHeight * rows);
				}

				// 只渲染一次
				if (_isStatic)
				{
					_willRender = false;
				}
			}
		}



		public function get rows() : int
		{
			return _rows;
		}

		public function set rows(value : int) : void
		{
			_rows = value;
		}

		public function get cols() : int
		{
			return _cols;
		}

		public function set cols(value : int) : void
		{
			_cols = value;
		}

		public function get tileHeight() : Number
		{
			return _tileHeight;
		}

		public function set tileHeight(value : Number) : void
		{
			_tileHeight = value;
		}

		public function get tileWidth() : Number
		{
			return _tileWidth;
		}

		public function set tileWidth(value : Number) : void
		{
			_tileWidth = value;
		}

	}
}
