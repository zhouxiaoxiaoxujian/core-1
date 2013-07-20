package cactus.common.vo
{
	import flash.utils.Dictionary;

	/**
	 * 自动列表
	 * 需要自动列表功能的VO，需要继承此类
	 * 		
	 		使用方法如下：
			var vo1:AutoList ; 
			for (var i:int = 0; i < 10; i++) 
			{
				vo1 = new AVO;	
			}
			
			for (i = 0; i < 10; i++) 
			{
				vo1 = new BVO;	
			}
			
			AutoList.findList(AVO)[0].destory();
			
			trace("AVO.getAll()",AutoList.findList(AVO)); 
			trace("BVO.getAll()",AutoList.findList(BVO)); 

 	 * @author Peng
	 */
	public class AutoList
	{
		private static var _listDict:Dictionary = new Dictionary;
		
		private var _classType:Class;
		
		public function AutoList($classType:Class=null)
		{
			_classType = $classType;
			
			if (! _listDict[_classType])
			{
				 _listDict[_classType] = new Array;
			}
			
			getTypeList().push(this);
		}
		
		public function destory():void{
			var idx:int = getTypeList().indexOf(this);
			if ( idx !=-1)
			{
				getTypeList().splice(idx,1);
			}
		}
		
		public static function findList(classType:Class):Array
		{
			return _listDict[classType];
		}
		
		private function getTypeList():Array
		{
			return _listDict[_classType]; 
		}
		
	}
}