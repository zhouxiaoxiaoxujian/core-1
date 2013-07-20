package cactus.common.frame.resource.helper
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.BinaryDataLoader;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;

	import flash.display.Sprite;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;

	import cactus.common.frame.resource.ResourceFacade;
	import cactus.common.frame.resource.ResourceMap;
	import cactus.common.frame.resource.ResourceType;
	import cactus.common.frame.resource.ResourceVO;
	import cactus.common.tools.util.StringUtil;

	/**
	 * 资源加载辅助类
	 * @author Pengx
	 *
	 */
	public class ResourceLoadHelper
	{

		/**
		 * 解析Config，写入ResourceMap中
		 * @param config
		 */
		public static function init(config : XML) : void
		{
			walk(config);

			function walk(xml : XML) : void
			{
				for each (var ele : XML in xml.elements())
				{
					walk(ele);
					if (ele.name() == "item")
					{
						ResourceMap.getInstance().addResourceVO(ele.attribute("name"), ele.attribute("type"), ele.attribute("url"), StringUtil.
							split(String(ele.attribute("relateList")), ","), -1, StringUtil.split(String(ele.attribute("rely")), ","));
					}
				}
			}
		}

		/**
		 * 加载所有资源
		 * @param completeFun
		 *
		 */
		public static function loadAll(completeFun : Function = null, errorFun : Function = null, progressFun : Function =
			null) : void
		{
			var loadList : Vector.<ResourceVO> = ResourceMap.getInstance().getResourceVOList();
			load(loadList, completeFun, errorFun, progressFun);
		}

		/**
		 * 根据关联对象数组加载资源
		 * @param arr					要加载的素材链接名数组
		 * @param completeFun
		 *
		 */
		public static function loadByRelateObjectArr(arr : Array, completeFun : Function = null, errorFun : Function = null, progressFun : Function =
			null) : void
		{
			var loadList : Vector.<ResourceVO> = ResourceMap.getInstance().getResourceVOListByRelateObjectArr(arr);
			load(loadList, completeFun, errorFun, progressFun);
		}

		public static function loadByName(name : String, completeFun : Function = null, errorFun : Function = null, progressFun : Function =
			null) : void
		{
			load(ResourceMap.getInstance().getResourceVO(name).toVector(), completeFun, errorFun, progressFun);
		}

		/**
		 * 根据vo，加载单独的文件
		 * @param vo
		 * @param completeFun
		 * @param errorFun
		 * @param progressFun
		 */
//		public static function loadSingle(vo:ResourceVO, completeFun:Function = null, errorFun:Function = null, progressFun:Function = null):void
//		{
//			var loadList:Vector.<ResourceVO> = new Vector.<ResourceVO>;
//			loadList.push(vo);
//			load(loadList, completeFun, errorFun, progressFun);
//		}

		private static function load(loadList : Vector.<ResourceVO>, completeFun : Function = null, errorFun : Function =
			null, progressFun : Function = null) : void
		{
			var tname : String = getTimer().toString();
			var max : LoaderMax = new LoaderMax({name: tname, maxConnections: 4, auditSize: false, onProgress: progressHandler, onComplete: completeHandler, onError: errorHandler});

			for each (var resVO : ResourceVO in loadList)
			{
				max.append(createLoader(resVO));
			}
			max.load();

			function progressHandler(event : LoaderEvent) : void
			{
				//				trace("progress: " + event.target.progress);
				if (progressFun != null)
				{
					progressFun.apply(event);
				}
			}

			function completeHandler(event : LoaderEvent) : void
			{
				if (completeFun != null)
				{
					completeFun.apply(event);
				}
				removeListener(event);
			}

			function errorHandler(event : LoaderEvent) : void
			{
				if (errorFun != null)
				{
					errorFun.apply(event);
					if (ResourceFacade.ERROR_HANDLE != null)
					{
						ResourceFacade.ERROR_HANDLE.apply();
					}
				}
				removeListener(event);
			}

			function removeListener(event : LoaderEvent) : void
			{
//				event.target.unload();

				if (event.target.hasEventListener(LoaderEvent.COMPLETE))
				{
					event.target.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
				}
				if (event.target.hasEventListener(LoaderEvent.ERROR))
				{
					event.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
				}
				if (event.target.hasEventListener(LoaderEvent.PROGRESS))
				{
					event.target.removeEventListener(LoaderEvent.PROGRESS, progressHandler);
				}

				progressFun = null;
				completeFun = null;
				errorFun = null;
				event.target["vars"] = new Object
			}
		}

		/**
		 * 创建加载体
		 * @param resVO
		 * @return
		 */
		private static function createLoader(resVO : ResourceVO) : com.greensock.loading.core.LoaderCore
		{
			if (resVO.type == ResourceType.SWF)
			{
				return new SWFLoader(resVO.src, {name: resVO.name, context: getLoaderContext()});
			}

			if (resVO.type == ResourceType.TXT)
			{
				return new DataLoader(resVO.src, {name: resVO.name, context: getLoaderContext()});
			}

			if (resVO.type == ResourceType.IMG)
			{
				return new ImageLoader(resVO.src, {name: resVO.name, context: getLoaderContext()});
			}

			if (resVO.type == ResourceType.BIN)
			{
				return new BinaryDataLoader(resVO.src, {name: resVO.name, context: getLoaderContext()});
			}

			if (resVO.type == ResourceType.XML)
			{
				return new com.greensock.loading.XMLLoader(resVO.src, {name: resVO.name, context: getLoaderContext()});
			}
			return null;
		}

		private static var context : LoaderContext;

		private static function getLoaderContext() : LoaderContext
		{
			return context ||= new LoaderContext(false, ApplicationDomain.currentDomain);
		}
	}
}
