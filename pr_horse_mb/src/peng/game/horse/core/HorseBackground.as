package peng.game.horse.core
{
	import flash.display.BitmapData;
	
	import peng.common.Config;
	import cactus.common.tools.util.ArrayUtils;
	import cactus.common.tools.util.MathUtil;
	import peng.game.horse.manager.HStatManager;
	import peng.game.horse.prop.GameFactory;
	
	/**
	 * 带有漂浮物的滚动背景 
	 * @author supperhpxd
	 * 
	 */	
	public class HorseBackground extends ScrollBackground implements IHorseBackground
	{
		/**
		 * 漂浮物队列
		 */
		private var _floatList:Vector.<FloatObject> ;
		/**
		 * 漂浮物的素材连接名
		 */
		private var _floatLinkageList:Array ;
		
		/**
		 * 云层的素材链接名 
		 */
		private var _cloudLinkageList:Array;
		
		/**
		 * 云条的素材连接名 
		 */
		private var _cloudNoddleLinkageList:Array;
		
		/**
		 * 是否有漂浮物 
		 */
		private var _hasFloat:Boolean;
		
		/**
		 * 是否有云彩 
		 */
		private var _hasCloud:Boolean;
		
		/**
		 * 是否有云条 
		 */
		private var _hasCloudNoddle:Boolean;
		
		private var _tick:uint = 0;
		
		public function HorseBackground()
		{
			super();
		}
		
		
		override public function destory():void
		{
			super.destory();
			for each (var item:FloatObject in _floatList) 
			{
				item.destory();
			}
		}
		
		override public function init($sourceBmd:BitmapData=null):void
		{
			super.init($sourceBmd);
			
			if (!_floatList)
			{
				_floatList = new Vector.<FloatObject>;
			}
			
			_floatLinkageList = new Array;
		}
		
		public function setFloatList(linkageList:Array):void
		{
			_floatLinkageList = linkageList;
			
			if ( linkageList.length >0)
			{
				_hasFloat = true;
			}
		}
		
		public function setCouldList(linkageList:Array):void
		{
			_cloudLinkageList = linkageList;
			
			if ( linkageList.length >0)
			{
				_hasCloud = true;
			}
		}
		
		public function setCloudNoddleList(linkageList:Array):void
		{
			_cloudNoddleLinkageList = linkageList;
			
			if (linkageList.length>0)
			{
				_hasCloudNoddle = true;
			}
		}
		
		override public function update(delay:int):void
		{
			_tick++;
			
			// 无敌时候的加速度
			//			if (_spx != 0 && HStatManager.getIns().zooling)
			//			{
			//				_currX += Config.ZOOL_ADD_VX;
			//			}
			
			super.update(delay);
			
			addFloatObject();
			addCloudObject();
			addCloudNoddle();
			
			
			for each ( var obj:FloatObject in _floatList)
			{
				obj.update(delay);
				
				// 到场景之外，自动销毁
				if (obj.x + obj.width < 0)
				{
					ArrayUtils.removeFromArray(_floatList,obj);
					removeChild(obj);
				}
			}
		}
		
		/**
		 * 添加云条 
		 */
		private function addCloudNoddle():void
		{
			// 添加云条
			
			// 楼层越高，云条间隔越短
			var d:int = 10/HStatManager.getIns().currLevel; 
			if ( _hasCloudNoddle && _tick % d == 0)
			{
				var obj:FloatObject = GameFactory.createCloudNoddle();
				
				addChild(obj);
				_floatList.push(obj);
			}
		}
		
		/**
		 * 添加云层 
		 * 
		 */
		private function addCloudObject():void
		{
			// 添加漂浮物1
			if ( _hasCloud && _tick % 60 == 0)
			{
				var obj:FloatObject = GameFactory.createCloudObject(randomCloudLinkage());
				
				addChild(obj);
				_floatList.push(obj);
			}
		}
		
		/**
		 * 添加漂浮物 
		 * @return 
		 */		
		private function addFloatObject():void
		{
			// 添加漂浮物1
			if ( _hasFloat && _tick % 90 == 0)
			{
				var obj:FloatObject = GameFactory.createFloatObject(randomFloatLinkage());
				
				addChild(obj);
				_floatList.push(obj);
			}
		}
		
		private function randomFloatLinkage():String
		{
			var random:int = MathUtil.random(0,_floatLinkageList.length);
			return _floatLinkageList[random];
		}
		
		private function randomCloudLinkage():String
		{
			var random:int = MathUtil.random(0,_cloudLinkageList.length);
			return _cloudLinkageList[random];
		}
		
	}
}