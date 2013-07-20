package cactus.common.frame.resource
{

	/**
	 * 资源结构体
	 * 必须通过ResourceMap生成
	 * @author Pengx
	 *
	 */
	public class ResourceVO
	{
		/**
		 * 资源名
		 */
		private var _name:String;
		/**
		 * 资源类型
		 */
		private var _type:String;
		/**
		 * 资源链接
		 */
		private var _src:String;
		/**
		 * 关联列表
		 * 用途
		 * 1.关联资源名列表：资源内部的子资源，如一个swf内部多个mc的链接名["readMessagePanel","writeMessagePanel"]
		 * 2.关联关系名列表：资源与主程序的关系，如资源属于["街道","室内"]
		 */
		private var _relateList:Array;

		/**
		 * 文件大小
		 * 明确指定文件大小，使进度更准确
		 */
		private var _weight:int;

		/**
		 * 依赖的对象，如果A依赖B，则加载A之前必须加载B。存在多层次的依赖
		 * @default
		 */
		private var _rely:Array;

		public function ResourceVO(name:String, type:String, src:String, relateList:Array=null, weight:int=-1, rely:Array = null)
		{
			this._name=name;
			this._type=type;
			this._src=src;
			this._relateList=relateList;
			this._weight=weight;
			this._rely=rely;
		}

		public function get rely():Array
		{
			return _rely; 
		}

		/**
		 * @private
		 */
		public function set rely(value:Array):void
		{
			_rely = value;
		}

		/**
		 * 资源名
		 */
		public function get name():String
		{
			return this._name;
		}

		/**
		 * 资源类型
		 */
		public function get type():String
		{
			return this._type;
		}

		/**
		 * 资源链接
		 */
		public function get src():String
		{
			return this._src;
		}

		/**
		 * 关联资源元素列表
		 */
		public function get relateList():Array
		{
			return this._relateList;
		}

		/**
		 * 预计文件大小
		 * @return
		 *
		 */
		public function get weight():int
		{
			return this._weight;
		}

		//======只允许包内设置======

		internal function setName(v:String):void
		{
			this._name=v;
		}

		internal function setType(v:String):void
		{
			this._type=v;
		}

		internal function setSrc(v:String):void
		{
			this._src=v;
		}

		internal function setRelateList(v:Array):void
		{
			this._relateList=v;
		}

		public function toString():String
		{
			return "([ResourceVO]" + "name:" + this._name + " type:" + this._type + " src:" + this._src + ")";
		}

		public function toVector():Vector.<ResourceVO>
		{
			var vec:Vector.<ResourceVO>=new Vector.<ResourceVO>;
			vec.push(this);
			return vec;
		}
	}
}