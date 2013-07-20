package cactus.ui.bind
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.events.Event;

	import cactus.ui.PUIConfig;
	import cactus.ui.base.BaseView;
	import cactus.ui.control.IPTileListRenderer;
	import cactus.ui.control.PTileList;
	import cactus.ui.events.ViewEvent;

	/**
	 * 界面绑定的UI
	 *
	 * Usage: 要求公用素材不能够动态加载，并尽量在同一个fla素材中
	 * @author Peng
	 */
	public class PView extends BaseView implements IPView
	{
		protected var _sourceMcOrClass : *;
		protected var _data : Object;

		public function PView($sourceMcOrClass : * = null)
		{
			super();

			if (!$sourceMcOrClass)
				return;

			if ($sourceMcOrClass is MovieClip)
			{
				_sourceMcOrClass = $sourceMcOrClass;
			}
			else if ($sourceMcOrClass is String)
			{
				try
				{
					_sourceMcOrClass = $sourceMcOrClass;
					var resource : * = PUIConfig.getMC($sourceMcOrClass);
					resource && (_sourceMcOrClass = resource);
				}
				catch (error : Error)
				{
					trace("没有加载的素材", $sourceMcOrClass);
				}
			}
			else
			{
				trace(this + "UI输入source可能有误");
			}

			_preparator.addRelateObject($sourceMcOrClass);
			addDataAndResource();
		}

		/**
		 * 实现需要绑定的变量
		 * @return
		 */
		public function getBindObj() : Array
		{
			return null;
		}


		/**
		 * Step1
		 * 当所有资源，数据准备好时调用
		 */
		override protected function onAllReady() : void
		{
			super.onAllReady();

			// 开始绑定素材
			if (_sourceMcOrClass)
			{
				if (_sourceMcOrClass is String)
				{
					_sourceMcOrClass = PUIConfig.getMC(_sourceMcOrClass);
				}

				this.source = _sourceMcOrClass as MovieClip;
			}
			else
			{
				init();
				draw();
			}

		}

		/**
		 * Step2
		 * 绑定完成后的初始化
		 */
		public function init() : void
		{
		}

		/**
		 * Step3
		 * 绘制必要,改变组件状态
		 */
		public function draw() : void
		{
		}

		/**
		 * 从舞台移除后自动销毁
		 */
		override public function destory() : void
		{
			// trace("销毁", this);
			super.destory();
			dispatchEvent(new ViewEvent(ViewEvent.VIEW_DESTORY));
		}

		/**
		 * 设置数据
		 * @return
		 */
		public function get data() : Object
		{
			return _data;
		}

		public function set data(value : Object) : void
		{
			_data = value;
			fireDataChange();
		}

		public function get source() : *
		{
			return _sourceMcOrClass;
		}

		/**
		 * 设置素材源，进行绑定
		 * @param value
		 */
		public function set source(value : *) : void
		{
			_sourceMcOrClass = value;
			bind();
			init();
			draw();
		}

		/**
		 * 组件模型改变
		 */
		public function fireDataChange() : void
		{

		}


		/**
		 * 绑定素材
		 * @耗时 目前为阻塞形式，有待改进
		 */
		public function bind() : void
		{
			PBinder.bind(this, source);
		}

		/**
		 * 反向绑定素材
		 */
		public function unbind() : void
		{

		}

		/**
		 * 添加必要的资源和数据
		 */
		protected function addDataAndResource() : void
		{

		}

		/**
		 * 重绘
		 */
		protected function invalidate() : void
		{
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}

		protected function onInvalidate(event : Event) : void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}

		// 宽和高有两重含义
		// 如果没有设置，即默认0，会读取素材的宽和高
		// 如果设置了值，则使用设置的值
		protected var _width : Number = 0;
		protected var _height : Number = 0;

		override public function set width(w : Number) : void
		{
			_width = w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get width() : Number
		{
			if (_width == 0)
				return super.width;
			return _width;
		}

		override public function set height(h : Number) : void
		{
			_height = h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get height() : Number
		{
			if (_height == 0)
				return super.height;
			return _height;
		}

		// 视图的原始宽高，只在绑定完成后生效
		// 是只读属性
		public function get originalHeight() : Number
		{
			return source.height;
		}


		public function get originalWidth() : Number
		{
			return source.width;
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
			return _master.children.indexOf(this as IPTileListRenderer);
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
