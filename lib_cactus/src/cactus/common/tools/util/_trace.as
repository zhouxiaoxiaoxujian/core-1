//---调试---
package cactus.common.tools.util
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 调试输出
	 * @param instance  类实例的指针,应传入this
	 * @param debugRank 调试等级
	 * @param ...args	任意调试输出参数
	 */
	public function _trace(instance:*, debugRank:int, ... args):void
	{
		if (!TraceConfig.debugMode)
			return;
		if (debugRank <= TraceConfig.showDebugRank)
			return;
		if (TraceConfig.filterPackageList.length > 0)
		{
			var classPath:String=getQualifiedClassName(instance);
			var arr:Array=classPath.split(":");
			var packageName:String=arr[0];
			var className:String=arr[1];
			if (TraceConfig.ifInFilterPackageList(packageName))
			{
				return;
			}
		}
		trace(args);
	}
}

//---配置---
class TraceConfig
{
	/**
	 * 是否输出调试信息
	 */
	public static var debugMode:Boolean=true;
	/**
	 * 显示的调试等级
	 * 此等级以下的不显示
	 */
	public static var showDebugRank:int=0;
	/**
	* 筛选输出包
	* 数组里面包含的包为不输出调试信息的包
	* 如果为空，就全部输出
	*/
	public static var filterPackageList:Array=[];

	public static function ifInFilterPackageList(packageName:String):Boolean
	{
		var len:int=filterPackageList.length;
		for (var i:int=0; i < len; i++)
		{
			if (packageName.indexOf(filterPackageList[i]) != -1)
			{
				return true;
			}
		}
		return false;
	}
}
