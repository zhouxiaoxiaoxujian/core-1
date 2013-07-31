/**
   命名规范：
*/

// 枚举
var ui = "_UI";
var pop = "_POP";

// 整个fla文档
var document = fl.getDocumentDOM();

// 正在编辑一个元件时，全选后的item
var selectItemsWhenEditItem=[];
var bindArray=[];

// 最终写入文件的代码
var clazzRoot = "file:///D|/";  // 最终生成类的路径
var code="";
var $class;		// 类名

// 迭代选中的库中元件
for each(var item in document.library.getSelectedItems()){
	// 以下是元件名称，和文件夹的路径是相关联的
	// fl.trace(item.name);
	
	// 以下为该元件的链接名，如果没有则是undefined
	// fl.trace(item.linkageClassName );
	
	// 没有链接名的不进行处理
	if ( item.linkageClassName == undefined)
	{
		continue;
	}

	// 处理_UI或者_POP结尾的类型
	var idx = item.linkageClassName.indexOf("_");
	if ( idx == -1)
	{
		alert("Please use linkage _UI or _POP");
		continue;
	}
	var postFix = item.linkageClassName.substring(idx,item.linkageClassName.length);
	

	if ( postFix == ui || postFix == pop )
	{
			$class = item.linkageClassName;
		    // fl.trace(item.linkageClassName );
			// 进入编辑当前的元件
    		document.library.editItem(item.name);
	
			// 全选当前正在编辑的文件,并返回选择项
			document.selectAll();
    		selectItemsWhenEditItem=document.selection;
			
			createBaseClass(postFix);
			
			writeBaseClass();
			
			createImplClass(postFix);
			
			writeImplClass();
	}	
}


// ---------------------------------------------------------------
// ---------------------------------------------------------------
//						基类代码模板
// ---------------------------------------------------------------
// ---------------------------------------------------------------
/**
* param postFix 链接名的后缀，用于区分是UI还是POP
*/
function createBaseClass(postFix){  
  code="package {\r\n"
  
  code+="import flash.events.Event;\r\n"
  code+="import flash.events.MouseEvent;\r\n"
  code+="import cactus.ui.bind.PAutoView;\r\n"
  code+="import cactus.ui.control.*;\r\n"
  code+="import cactus.ui.base.BasePopupPanel;\r\n"
  code+="import flash.display.MovieClip;\r\n"
  code+="import flash.text.TextField;\r\n\r\n"  
	
  
  // 预留其他的import
  createImports()
  
  var baseClassName = (postFix == ui)? "PAutoView" : "BasePopupPanel";
  code+="internal class "+$class+" extends "+baseClassName+"{\r\n\r\n"

  // 创建Bindable的变量,将所有绑定变量写入一个数组bindArray，以便后面使用
  createVars()
 
  // 构造函数，无论UI和POP 都使用src，而不是写死的固定链接名
  // var superParam = (postFix == ui)? "src" : "\"+$class+\"";
  code+="\r\npublic function "+$class+"(src:*=null){super(src)}\r\n\r\n"
  
  // 需要绑定的变量
  // code+=" override public function getBindObj():Array {return"
  // createBindProperties();
  // code+=";\r\n"
  // code+="}\r\n"
  
  // 必要的函数重写
  code+=" override public function init():void{super.init();\r\n"
  createAddEvent()
  code+="}\r\n"
  
  code+=" override public function destory():void{super.destory();\r\n"
  createRemoveEvent()
  code+="}\r\n"
  
  code+=" override public function fireDataChange():void{super.fireDataChange();}\r\n"

  createEventHandler();

  code+="}}\r\n"

} // createBaseClass

// 其他的import
function createImports()
{
}

function createBindProperties()
{
    code+="["
    for (var i = 0;i< bindArray.length;i++)
    {
        code+="{\"propertyName\":\""+ bindArray[i]+"\"}";
        if (i !=  bindArray.length -1)
        {
          code+=",";
        }
    }
    code+="]"
}

// 添加绑定变量
function createVars()
{
	// 迭代全部选中的item
	for each(var item in selectItemsWhenEditItem)
	{
		fl.trace(item.name + " "+item.itemType + " "+item.elementType);
		
		if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "btn_")
		{
			// 生成PButton绑定
			code+="[Bind]\n";
			code+="public var "+item.name+":PButton;\r\n"
			bindArray.push(item.name);
		}
		else if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "ttn_")
		{
			// 生成PTweenButton绑定
			code+="[Bind]\n";
			code+="public var "+item.name+":PTweenButton;\r\n"
			bindArray.push(item.name);
		}
		else if (item.symbolType == "movie clip" && item.name.substring(0,4) == "mmc_")
		{
			// 生成MovieClip绑定
			code+="[Bind]\n";
			code+="public var "+item.name+":MovieClip;\r\n"
			bindArray.push(item.name);
		}
		else if (item.elementType == "text" && item.name.substring(0,4) == "txt_")
		{
			// 生成TextField绑定
			code+="[Bind]\n";
			code+="public var "+item.name+":TextField;\r\n"
			bindArray.push(item.name);
		}
		else if (item.symbolType == "movie clip" && item.name.substring(0,4) == "slt_")
		{
			// 生成PTileList绑定
			code+="[Bind]\n";
			code+="public var "+item.name+":PTileList = new PTileList;\r\n"
			bindArray.push(item.name);
		}
		else if (item.symbolType == "movie clip" && item.name.substring(0,4) == "tlt_")
		{
			// 生成PTweenTileList绑定
			code+="[Bind]\n";
			code+="public var "+item.name+":PTweenTileList = new PTweenTileList;\r\n"
			bindArray.push(item.name);
		}
		else if (item.symbolType == "movie clip" && item.name.substring(0,4) == "chb_")
		{
		    // 生成复选框绑定
		    code+="[Bind]\n";
			code+="public var "+item.name+":PCheckBox = new PCheckBox;\r\n"
			bindArray.push(item.name);
		}
		else if (item.symbolType == "movie clip" && item.name.substring(0,4) == "nsp_")
		{
		    // 生成步进器
		    code+="[Bind]\n";
			code+="public var "+item.name+":PNumericStepper = new PNumericStepper;\r\n"
			bindArray.push(item.name);
		}
		// 生成嵌套的PView
		else if ( item.name != "" && item.elementType == "instance")
		{
			fl.trace("xxx "+item.name)
			code+="[Bind]\n";
			code+="public var "+item.name+":"+item.libraryItem.linkageClassName +"= new "+item.libraryItem.linkageClassName+";"
			bindArray.push(item.name);
		}
	}
}

// 添加事件
function createAddEvent()
{
	// 迭代全部选中的item
	for each(var item in selectItemsWhenEditItem)
	{
		if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "btn_")
		{
			code+=""+item.name+".addEventListener(MouseEvent.CLICK,"+item.name+"Click);\r\n"
		}
		else if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "ttn_")
		{
			code+=""+item.name+".addEventListener(MouseEvent.CLICK,"+item.name+"Click);\r\n"
		}
	}
}

// 移除事件
function createRemoveEvent()
{
	// 迭代全部选中的item
	for each(var item in selectItemsWhenEditItem)
	{
		if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "btn_")
		{
			code+=""+item.name+".removeEventListener(MouseEvent.CLICK,"+item.name+"Click);\r\n"
		}
		else if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "ttn_")
		{
			code+=""+item.name+".removeEventListener(MouseEvent.CLICK,"+item.name+"Click);\r\n"
		}
	}
}

// 生成事件监听器
function createEventHandler()
{
		// 迭代全部选中的item
	for each(var item in selectItemsWhenEditItem)
	{
		if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "btn_")
		{
			code+="protected function "+item.name+"Click(evt:MouseEvent):void{}\r\n"
		}
		else if ( item.symbolType == "movie clip" && item.name.substring(0,4) == "ttn_")
		{
			code+="protected function "+item.name+"Click(evt:MouseEvent):void{}\r\n"
		}
	}
}

// 写文件
function writeBaseClass()
{
  var fpath = clazzRoot + $class+".as";
  fl.trace(fpath);
  FLfile.write(fpath,code);
}



// ---------------------------------------------------------------
// ---------------------------------------------------------------
//						实现类代码模板
// ---------------------------------------------------------------
// ---------------------------------------------------------------
var childClassName

function createImplClass(postFix){  
  code="";
  code="package {\r\n"
  
  code+="import cactus.ui.control.*;\r\n"
  
  childClassName = processChildClassName($class); 		
  code+="public class "+childClassName+" extends "+$class+"{\r\n\r\n"
 
  // 构造函数，无论UI和POP 都写死的固定链接名
  code+="\r\npublic function "+childClassName+"(src:*=null){super(\""+$class+"\")}\r\n\r\n"
  
  // 必要的函数重写
  code+=" override public function init():void{\r\n"
  code+="// must call super\r\n" 
  code+="super.init();\r\n"
  code+="}\r\n"
  
  code+=" override public function destory():void{\r\n"
  code+="// must call super\r\n" 
  code+="super.destory();\r\n"
  code+="}\r\n"
  
  code+=" override public function fireDataChange():void{}\r\n"

  code+="}}\r\n"

} // createImplClass


// 写文件
function writeImplClass()
{
  var fpath = clazzRoot + childClassName +".as";
  fl.trace(fpath);
  FLfile.write(fpath,code);
}

// 处理父类名字成为子类名字
function processChildClassName(baseClassName)
{
	var spIndex = baseClassName.indexOf("_");
	if ( spIndex != -1)
	{
		return baseClassName.substring(0,spIndex) +"View";
	}
	
	return "errorWithProcessChildClassName"+baseClassName;
}