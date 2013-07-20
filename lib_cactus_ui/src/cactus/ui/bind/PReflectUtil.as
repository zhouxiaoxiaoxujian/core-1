package cactus.ui.bind
{

	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	/**
	 *
	 * @author Peng
	 */
	public class PReflectUtil
	{
		public static var ALL:int=0;
		public static var VARIABLES:int=1;
		public static var WRITEONLY_ACCESSORS:int=2;
		public static var READONLY_ACCESSORS:int=4;
		public static var METHODS:int=8;
		public static var READ_AND_WIRTE_ACCESSORS:int=16;
		public static var ALL_READABLE_VARIABLES:int=VARIABLES | READONLY_ACCESSORS;


		/**
		 * 遍历一个BindAbleObject
		 *
		 * @param target	被遍历的绑定类，非素材
		 * @param filiter	过滤器
		 * @param condition	需要匹配的正则
		 * @return			被绑定实例的名字
		 */
		public static function getPropertyNames(target:Object, filter:int, condition:RegExp=null):Array
		{
			var ret:Array=[];
			var sturcure:XML=getDescribeType(target);

			if ((filter | PReflectUtil.VARIABLES) == filter || filter == 0)
				ret=ret.concat(calculateNode(sturcure.variable, condition));

			if ((filter | PReflectUtil.WRITEONLY_ACCESSORS) == filter || filter == 0)
				ret=ret.concat(calculateNode(sturcure.accessor, condition, "access==readwrite"));

			if ((filter | PReflectUtil.READONLY_ACCESSORS) == filter || filter == 0)
				ret=ret.concat(calculateNode(sturcure.accessor, condition));

			if ((filter | PReflectUtil.METHODS) == filter || filter == 0)
				ret=ret.concat(calculateNode(sturcure.method, condition));

			if ((filter | PReflectUtil.READ_AND_WIRTE_ACCESSORS) == filter || filter == 0)
				ret=ret.concat(calculateNode(sturcure.accessor, condition, "access==readwrite"));

			// 使用元数据[Bind]的模式
			var node:XML;
			for each (node in sturcure.*.(name() == 'variable').metadata.(@name == 'Bind'))
			{
				ret.push(node.parent().@name);
			}

			return ret;
		}


		// 用于缓存反射的结果
		private static var _describeTable:Dictionary=new Dictionary();

		private static function getDescribeType(target:Object):XML
		{
			var key:String=getQualifiedClassName(target);

			if (!_describeTable[key])
			{
				_describeTable[key]=describeType(target);
			}
			return _describeTable[key];
		}

		public static function clearDescribeType():void
		{
			for each (var key:String in _describeTable)
			{
				delete _describeTable[key];
			}
			_describeTable=null;
			_describeTable=new Dictionary;
		}

		/**
		 * 遍历一个BindAbleObject
		 *
		 * @param target	被遍历的绑定类，非素材
		 * @param filiter	过滤器
		 * @param condition	需要匹配的正则
		 * @return			被绑定实例的全部信息
		 */
		public static function getProperties(target:Object, filter:int, condition:RegExp=null):Array
		{
			var ret:Array=[];
			var tmp:Array=[];
			var mt:MTObj;

			// 如果view覆盖了getBindObj方法
			var objs:Array=target["getBindObj"].apply();
			if (objs)
			{
				for each (var obj:Object in objs)
				{
					mt=new MTObj();
					mt.propertyName=obj["propertyName"];
					mt.align=(obj["align"] ? obj["align"] : "");
					mt.ref=(obj["ref"] ? obj["ref"] : "");
					mt.scale=(obj["scale"] ? obj["scale"] : false);
					ret.push(mt);
				}
				return ret;
			}

			var sturcure:XML=getDescribeType(target);

			// 使用元数据[Bind]的模式
			var node:XML;
			for each (node in sturcure.*.(name() == 'variable').metadata.(@name == 'Bind'))
			{
				mt=new MTObj();
				mt.propertyName=node.parent().@name;
				mt.align=node.arg.(@key == "align").@value;
				mt.ref=node.arg.(@key == "ref").@value;
				mt.scale=(node.arg.(@key == "scale").@value == "true") ? true : false;
				ret.push(mt);
			}


			if ((filter | PReflectUtil.VARIABLES) == filter || filter == 0)
				tmp=tmp.concat(calculateNode(sturcure.variable, condition));

			if ((filter | PReflectUtil.WRITEONLY_ACCESSORS) == filter || filter == 0)
				tmp=tmp.concat(calculateNode(sturcure.accessor, condition, "access==readwrite"));

			if ((filter | PReflectUtil.READONLY_ACCESSORS) == filter || filter == 0)
				tmp=tmp.concat(calculateNode(sturcure.accessor, condition));

			if ((filter | PReflectUtil.METHODS) == filter || filter == 0)
				tmp=tmp.concat(calculateNode(sturcure.method, condition));

			if ((filter | PReflectUtil.READ_AND_WIRTE_ACCESSORS) == filter || filter == 0)
				tmp=tmp.concat(calculateNode(sturcure.accessor, condition, "access==readwrite"));

			// 是否已经被Metadata添加
			var alreadyAdded:Boolean;
			for each (var propertyName:String in tmp)
			{
				mt=new MTObj();
				mt.propertyName=propertyName;

				alreadyAdded=false;
				// 如果即使用Bind，又使用_PB，则应该以Bind为准，删除_PB
				for each (var bMt:MTObj in ret)
				{
					if (propertyName.indexOf(bMt.propertyName) != -1)
					{
						alreadyAdded=true;
					}
				}

				if (!alreadyAdded)
					ret.push(mt);
			}
			return ret;
		}



		/**
		 * 查找对象目标集合中，满足正则的属性
		 * @param filterTarget
		 * @param filter
		 * @return
		 *
		 */
		protected static function calculateNode(xmlTarget:XMLList, condition:RegExp=null, testProperty:String=""):Array
		{
			var ret:Array=[];

			for each (var xmlItem:XML in xmlTarget)
			{
				var propertyName:String=String(xmlItem.@name);
				if (condition)
				{
					// trace("-- propertyName --",propertyName,condition);
					if (condition.test(propertyName))
						ret.push(propertyName);
				}
				else if (testProperty == "")
				{
					ret.push(propertyName);
				}
				else
				{
					var op:Array=POperator.ParseOp(testProperty);
					if (POperator.Op(xmlItem.attribute(op[0]), op[1], op[2]))
					{
						ret.push(propertyName);
					}
				}
			}

			return ret;
		}



//		/**
//		 *
//		 * @param xl		类描述文件(describeType之后), 变量，存取器，方法的描述
//		 * @param obj		输出返回值
//		 * @param sp		目标操作
//		 * @param target	被遍历的绑定类，非素材
//		 */
//		private static  function calcNode(xl:XMLList, obj:*, sp:String = "", target:* = null):void
//		{
//			for each (var node:* in xl)
//			{
//				if (sp != "")
//				{ 
//					// 比较类描述文件和sp要求的值是否相同
//					var op:* = KOperator.ParseOp(sp);
//					if (!KOperator.Op(node.attribute(op[0]), op[1], op[2]))
//					{
//						continue
//					}
//				}
//
//				// @Core 代码类和素材类绑定在一起
//				// 这一步，利用readOnly的accesor绑定了素材中的Content
//				// 因为一般只有get Content是只读的，详见UIObject中的如下代码：
//				/**
//				   public function get Content():MovieClip
//				   {
//				   if (this.Source != null)
//				   {
//				   this.Source.master = this; //cx add for drag manager
//				   return this.Source;
//				   }
//				   return null
//				   }
//				 *
//				 */
//				if (target != null)
//					obj[node.@name] = target[node.@name];
//				else
//					obj[node.@name] = null;
//			}
//		}

	}
}