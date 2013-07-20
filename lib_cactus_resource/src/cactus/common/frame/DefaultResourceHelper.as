package cactus.common.frame
{
	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.frame.resource.helper.ResourceLoadHelper;
	import cactus.common.resource.IResourceHelper;
	
	import flash.display.MovieClip;
	
	public class DefaultResourceHelper implements IResourceHelper
	{
		public function DefaultResourceHelper()
		{
		}
		
		public function getMC(name:String):MovieClip
		{
			return ResourceFacade.getMC(name);
		}
		
		public function loadByRelateObjectArr(arr:Array, completeFun:Function=null, errorFun:Function=null, progressFun:Function=null):void
		{
			return ResourceLoadHelper.loadByRelateObjectArr(arr,completeFun,errorFun,progressFun);
		}
	}
}