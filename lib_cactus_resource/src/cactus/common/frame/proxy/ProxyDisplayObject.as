package cactus.common.frame.proxy
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	/**
	 * 显示对象动态代理类
	 * 代理模式+组合模式
	 * 获取子显示对象必须用 	getChildByName
	 * 添加到舞台须用			ProxyMovieChilp.body
	 * @author Pengx 
	 * 
	 */
	dynamic public class ProxyDisplayObject extends Proxy
	{
		
		/**
		 * 代理  
		 */
		private var _body:DisplayObject;
		
		/**
		 * 是否是根节点 
		 */
		private var _isRoot:Boolean;
		
		/**
		 * 历史操作记录列表 
		 */
		private var _saveList:Vector.<SaveVO>;
		
		/**
		 * 子节点 
		 */
		private var _childs:Vector.<ProxyDisplayObject>;
		
		/**
		 * 是否记录操作
		 * 用于替换时还原操作
		 * 如果是终极替换，替换后保证不会再替换了，替换后应设置为false，节约内存和cpu 
		 */
		private var _ifRecord:Boolean = true;
		
		
		/**
		 *  
		 * @param body 		作为代理的显示对象,如果为null则自动构建空影片剪辑
		 * @param isRoot 	是否是根节点
		 * 
		 */
		public function ProxyDisplayObject(body:DisplayObject = null,isRoot:Boolean = true)
		{
			_isRoot = isRoot
			_childs = new Vector.<ProxyDisplayObject>();
			_saveList = new Vector.<SaveVO>();
			_body = body;
			if(_body == null)
			{
				_body = new MovieClip();
			}
		}
		
		/**
		 * 添加 
		 * @param pdo
		 * 
		 */
		internal function add(pdo:ProxyDisplayObject):void
		{
			_childs.push(pdo);
		}
		
		/**
		 * 移出 
		 * @param pmc
		 * 
		 */
		internal function remove(pdo:ProxyDisplayObject):void
		{
			var index:int = _childs.indexOf(pdo);
			if(index != -1)
			{
				_childs.splice(index,1);
			}
		}
		
		/**
		 * 获得实体 
		 * @return 
		 * 
		 */
		public function get body():DisplayObject
		{
			return _body;
		}
		
		/**
		 * 设置显示对象
		 * @param body	  被替换的显示对象
		 * @param ifFinal 是否是最终的显示对象，如果是，此代理将不能再被替换。
		 * 
		 */
		public function setDisplay(body:DisplayObject,ifFinal:Boolean = false):void
		{		
			//是否继续记录
			_ifRecord = !ifFinal;
			//子元素们的还原操作
			var len:int = _childs.length;
			for(var i:int = 0 ; i < len ; i++)
			{
				var childName:String = _childs[i].body.name;
				var childBody:DisplayObject = DisplayObjectContainer(body).getChildByName(childName);
				if(childBody != null)
				{
					_childs[i].setDisplay(childBody);
				}	
			}
			//本身还原操作
			len = _saveList.length;
			//还原函数和属性函数
			for(i = 0 ; i < len ; i++)
			{
				if(_saveList[i].type == SaveVO.TYPE_VAR)
				{
					body[_saveList[i].name] = _saveList[i].args[0];
				}
				else
				{
					body[_saveList[i].name].apply(body,_saveList[i].args);
					//如有监听函数原对象要移出监听
					if(_saveList[i].name == "addEventListener")
					{
						_body.removeEventListener.apply(_body,_saveList[i].args.slice(0,3));
					}
				}
			}
			//如果是根节点，替换替换父影片剪辑
			if(_isRoot && _body.parent != null)
			{
				var pa:DisplayObjectContainer = _body.parent;
				pa.removeChild(_body);
				pa.addChild(body);
			}
			//最终修改
			_body = body;
		}
		
		override flash_proxy function callProperty(name:*, ...parameters) : *
		{
			saveFunction(name,parameters);	
			//可能会出错的函数要自定义处理处理
			switch(name.toString())
			{
				//暂不提供的容器方法
				case "addChild":
				case "addChildAt":
				case "getChildAt":
				case "removeChild":
				case "removeChildAt":
				case "setChildIndex":
				case "swapChildren":
				case "swapChildrenAt":
					throw new Error("暂不提供此容器方法调用");break;					
			}
			return _body[name].apply(_body,parameters);
		}
		
		/**
		 * 获取值 
		 * @param name
		 * @return 
		 * 
		 */
		override flash_proxy function getProperty(name:*) : *
		{
			if(_body[name] == undefined)
			{
				throw new Error("代理不能获取到没有设定过的属性，如果确实需要获取，请使用模板。");
			}
			return _body[name];
		}
		
		/**
		 * 设置值 
		 * @param name
		 * @param value
		 * 
		 */
		override flash_proxy function setProperty(name:*, value:*) : void
		{	
			saveVar(name,value);
			_body[name] = value;
		}
		
		/**
		 * 记录函数(调用函数时使用) 
		 * @param name
		 * @param arg
		 * 
		 */
		private function saveFunction(name:String,args:Array):void
		{
			if(!_ifRecord) return;
			//不保存的函数,所有的获取函数
			if(name.indexOf("get") != -1) return;
			//只保存一次的函数,一次成型的函数
			if(name == "startDrag" || name == "stopDrag" || name == "gotoAndPlay" 
				|| name == "gotoAndStop" || name == "play" || name == "stop")
			{
				var saveVO:SaveVO = findFunction(name);
				//如果存在就更新
				if(saveVO != null)
				{
					saveVO.args = args;
					return;
				}
			}
			_saveList.push(new SaveVO(SaveVO.TYPE_FUNCTIOIN,name,args));
		}
		
		/**
		 * 查找函数对应的保存体 
		 * @param name
		 * @return 
		 * 
		 */
		private function findFunction(name:String):SaveVO
		{
			var len:int = _saveList.length;
			while(len--)
			{
				var saveVO:SaveVO = _saveList[len];
				if(saveVO.type == SaveVO.TYPE_FUNCTIOIN && saveVO.name == name)
				{
					return saveVO;
				}
			}
			return null;
		}
		
		/**
		 * 记录属性(赋值和修改属性时使用) 
		 * @param name
		 * @param value
		 * 
		 */
		private function saveVar(name:String,value:*):void
		{
			if(!_ifRecord) return;
			var saveVO:SaveVO = findVar(name);
			if(saveVO != null)
			{
				saveVO.args[0] = value;
			}
			else
			{
				_saveList.push(new SaveVO(SaveVO.TYPE_VAR,name,[value]));
			}
		}
		
		/**
		 * 查找变量对应的保存体 
		 * @param name
		 * @return 
		 * 
		 */
		private function findVar(name:String):SaveVO
		{
			var len:int = _saveList.length;
			while(len--)
			{
				var saveVO:SaveVO = _saveList[len];
				if(saveVO.type == SaveVO.TYPE_VAR && saveVO.name == name)
				{
					return saveVO;
				}
			}
			return null;
		}
		
		//=========操作子元件的方法应单独处理==========
		/**
		 * 用此方法获得子代理元件 
		 * @param name
		 * @return 
		 * 
		 */
		public function getChildByName(name:String) : ProxyDisplayObject
		{
			//查找子代理
			var len:int = _childs.length;			
			for(var i:int = 0 ; i < len ; i++)
			{
				if(_childs[i].body.name == name)
				{
					return _childs[i];
				}
			}
			//没有子代理,构建子代理
			var pdo:ProxyDisplayObject; 
			//如果没有，查找是否是容器，里面是否有name
			if(_body is DisplayObjectContainer)
			{
				var container:DisplayObjectContainer = _body as DisplayObjectContainer;
				for(i = 0 ; i < container.numChildren ; i++)
				{
					var childBody:DisplayObject = container.getChildAt(i);
					if(childBody != null && childBody.name == name)
					{
						pdo = new ProxyDisplayObject(childBody,false);
						this.add(pdo);
						return pdo;			
					}
				}				
			}			
			//如果仍然没有，自己创建(默认构建影片剪辑)
			var newChildBody:DisplayObject = new MovieClip();
			newChildBody.name = name;
			pdo = new ProxyDisplayObject(newChildBody,false);
			this.add(pdo);
			return pdo;
		}
	}
}
/**
 * 存储结构 
 */
class SaveVO
{
	public static const TYPE_VAR:int = 0;
	public static const TYPE_FUNCTIOIN:int = 1;
	public var type:int;
	public var name:String;
	public var args:Array;
	public function SaveVO(type:int,name:String,args:Array):void
	{
		this.type = type;
		this.name = name;
		this.args = args;
	}
}