package cactus.common.frame.resource
{

	/**
	 * 资源地图
	 *
	 * @date   2010-03-10
	 * @author Pengx
	 *
	 * @example 范例：
	 * <listing version="3.0">
		  //初始化资源
		var myConfig:XML = <config>
								<resources path="res">
									<resource name="preloader_asset"    src="asset/preloader_asset.swf" type="swf"/>
									<resource name="game_asset" 			src="asset/game_asset.swf"  type="swf" relateList="Gift,Cut,Grass"/>
									<resource name="indoor_asset" 	    src="asset/indoor_asset.swf"  type="swf" relateList="Plant_9,Wall0"/>
									<resource name="outdoor_asset" 	    src="asset/outdoor_asset.swf"  type="swf"/>
									<resource name="sound_asset" 	    src="asset/sound_asset.swf" type="swf" />
								</resources>
							</config>
		var myAssets:XMLList = myConfig.resources.resource;
		//加载列表
		var loadList:Vector.<ResourceVO> = new Vector.<ResourceVO>();
		//构建资源库
		for each(var item:XML in myAssets)
		{
			var vo:ResourceVO = ResourceMap.getInstance().addResourceVO(item.@name,item.@type,item.@src);
			//简单的关联表，也可能是不在这个配置文件里面，那就要多个表匹配
			if(item.@relateList!=null)
			{
				ResourceMap.getInstance().addRelateList(vo,String(item.@relateList).split(","));
			}
			loadList.push(vo);
		}
	 * </listing>
	 *
	 */
	public class ResourceMap
	{
		private static var _instance:ResourceMap;

		private var _resourceList:Vector.<ResourceVO>;

		public function ResourceMap(param:Singleton)
		{
			_resourceList=new Vector.<ResourceVO>();
		}

		/**
		 * 获得单件实例
		 * @return
		 *
		 */
		public static function getInstance():ResourceMap
		{
			if (_instance == null)
			{
				_instance=new ResourceMap(new Singleton());
			}
			return _instance;
		}

		/**
		 * 添加资源结构体
		 * @param name
		 * @param type
		 * @param src
		 * @param relateList
		 * @return 返回null添加失败
		 *
		 */
		public function addResourceVO(name:String, type:String, src:String, relateList:Array=null, weight:int=-1, rely:Array=null):ResourceVO
		{
			if (!ResourceType.canSupportType(type))
			{
				throw new Error("此资源类型不被支持:" + type);
			}
			var vo:ResourceVO;
			//如果没有才能增加
			if (getResourceVO(name, type) == null)
			{
				vo=new ResourceVO(name, type, src, relateList, weight, rely);
				_resourceList.push(vo);
			}
			return vo;
		}

		/**
		 * 获取资源结构体
		 * @param name
		 * @param type
		 * @return
		 *
		 */
		public function getResourceVO(name:String, type:String=null):ResourceVO
		{
			var len:int=_resourceList.length;
			for (var i:int=0; i < len; i++)
			{
				var vo:ResourceVO=_resourceList[i];
				if (vo.name == name)
				{
					if (type == null || vo.type == type)
					{
						return vo;
					}
				}
			}
			return null;
		}

		/**
		 * 添加关联元素
		 * @param vo
		 * @param relateList
		 *
		 */
		public function addRelateList(vo:ResourceVO, relateList:Array):void
		{
			if (vo.relateList != null)
			{
				vo.setRelateList(vo.relateList.concat(relateList));
			}
			else
			{
				vo.setRelateList(relateList);
			}
		}

		/**
		 * 获得资源列表
		 * @return
		 *
		 */
		public function getResourceVOList():Vector.<ResourceVO>
		{
			return _resourceList.concat();
		}

		/**
		 * 根据资源类型获取资源列表
		 * @param type  资源类型
		 * @return
		 *
		 */
		public function getResourceVOListByType(type:String):Vector.<ResourceVO>
		{
			var list:Vector.<ResourceVO>=new Vector.<ResourceVO>();
			var len:int=_resourceList.length;
			for (var i:int=0; i < len; i++)
			{
				if (_resourceList[i].type == type)
				{
					list.push(_resourceList[i]);
				}
			}
			return list;
		}

		/**
		 * 根据关联数据获取资源列表
		 * @param type	资源类型
		 * @return
		 *
		 */
		public function getResourceVOListByRelateObject(data:*, type:String=null):Vector.<ResourceVO>
		{
			var list:Vector.<ResourceVO>=new Vector.<ResourceVO>();
			if (data == null || data == "")
				return list;
			var len:int=_resourceList.length;
			for (var i:int=0; i < len; i++)
			{
				var vo:ResourceVO=_resourceList[i];
				if (type == null || vo.type == type)
				{
					var relateList:Array=vo.relateList;
					if (relateList == null)
						continue;
					var len2:int=relateList.length;
					for (var j:int=0; j < len2; j++)
					{
						if (relateList[j] == data)
						{
							list.push(vo);
						}
					}
				}
			}

			return uniqueResourceVOList(list);
		}

		/**
		 * 根据关联数据数组获取资源列表
		 * @param dataArr	关联数据数组
		 * @param type		资源类型
		 * @return
		 *
		 */
		public function getResourceVOListByRelateObjectArr(dataArr:Array, type:String=null):Vector.<ResourceVO>
		{
			var list:Vector.<ResourceVO>=new Vector.<ResourceVO>();
			var len:int=dataArr.length;
			for (var i:int=0; i < len; i++)
			{
				list=list.concat(getResourceVOListByRelateObject(dataArr[i]));
			}
			return uniqueResourceVOList(list);
		}

		/**
		 * 资源数组元素唯一化
		 * @param ResourceVOList
		 * @return
		 *
		 */
		private function uniqueResourceVOList(ResourceVOList:Vector.<ResourceVO>):Vector.<ResourceVO>
		{
			var list:Vector.<ResourceVO>=new Vector.<ResourceVO>();
			ResourceVOList.sort(ResourceVOCheck);
			var vo:ResourceVO;
			var len:int=ResourceVOList.length;
			for (var i:int=0; i < len; i++)
			{
				if (vo != ResourceVOList[i])
				{
					vo=ResourceVOList[i];
					list.push(vo);
				}
			}
			return list;
		}

		/**
		 * 排序用函数
		 * @param vo1
		 * @param vo2
		 * @return
		 *
		 */
		private function ResourceVOCheck(vo1:ResourceVO, vo2:ResourceVO):int
		{
			if (vo1.name == vo2.name && vo1.type == vo2.type)
			{
				return 0;
			}
			return 1;
		}
	}
}

class Singleton
{
}