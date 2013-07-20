/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.manager
{
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.events.EventDispatcher;
	import flash.net.SharedObject;
	
	/**
	 * 系统管理 声音 画质 
	 * @author Pengx
	 * 
	 */
	public class SystemManager extends EventDispatcher
	{
		
		private var _stage:Stage;
		
		private static var _instance:SystemManager;
		
		//本地保存
		private static var _gameSysSo:SharedObject;
		private static var _gameSysSoName:String = "renren_nightclub";
		
		
		public function SystemManager(paramer:SingletonEnforcer)
		{
			
		}
		
		public static function getInstance():SystemManager
		{
			if(_instance==null)
			{
				_instance = new SystemManager(new SingletonEnforcer());				
			}
			return _instance;
		}
		
		/**
		 * 初始要设定舞台引用 和 保存对象
		 * @param stage
		 * 
		 */
		public function setStage(stage:Stage):void
		{
			_stage = stage;
			
			_gameSysSo = SharedObject.getLocal(_gameSysSoName);
			if(_gameSysSo.data.soundEnabled != null && _gameSysSo.data.soundEnabled == false)
			{
				closeEffectSound();
			}
			if(_gameSysSo.data.bgSoundEnabled != null && _gameSysSo.data.bgSoundEnabled == false)
			{
				closeBgSound();
			}
			if(_gameSysSo.data.hightQuality != null && _gameSysSo.data.hightQuality == false)
			{
				closeHightQuality();
			}
		}
		
		/**
		 * 保存变量到本地
		 * @param varName
		 * @param varValue
		 * 
		 */
		public function saveVarToLocal(varName:String,varValue:*):void
		{
			_gameSysSo.data[varName] = varValue;
			_gameSysSo.flush();
		}
		
		/**
		 * 获取保存在本地的变量 
		 * @param varName
		 * @return 
		 * 
		 */
		public function getVarFromLocal(varName:String):*
		{
			return _gameSysSo.data[varName];
		}
		
		/**
		 * 开启背景音乐 
		 * 
		 */
		public function openBgSound():void
		{
			_gameSysSo.data.bgSoundEnabled = SoundManager.bgSoundEnable = true;
			_gameSysSo.flush();
			SoundManager.getInstance().continueBgSound();
		}
		
		/**
		 * 关闭背景音乐 
		 * 
		 */
		public function closeBgSound():void
		{
			_gameSysSo.data.bgSoundEnabled = SoundManager.bgSoundEnable = false;
			_gameSysSo.flush();
			SoundManager.getInstance().stopBgSound();
		}
		
		/**
		 * 是否开启了背景音乐 
		 * @return 
		 * 
		 */
		public function get isBgSoundOpen():Boolean
		{
			return SoundManager.bgSoundEnable;
		}
		
		/**
		 * 开启音效 
		 * 
		 */
		public function openEffectSound():void
		{
			_gameSysSo.data.soundEnabled = SoundManager.soundEnable = true;
			_gameSysSo.flush();
			SoundManager.getInstance().continueAllSound();
		}
		
		/**
		 * 关闭音效 
		 * 
		 */
		public function closeEffectSound():void
		{
			_gameSysSo.data.soundEnabled = SoundManager.soundEnable = false;	
			_gameSysSo.flush();
			SoundManager.getInstance().stopAllSound();
		}
		
		/**
		 * 是否开启了音效 
		 * @return 
		 * 
		 */
		public function get isEffectSoundOpen():Boolean
		{
			return SoundManager.soundEnable;
		}
		
		/**
		 * 开启高画质 
		 * 
		 */
		public function openHightQuality():void
		{
			_gameSysSo.data.hightQuality = true;
			_gameSysSo.flush();
			_stage.quality = StageQuality.HIGH;
		}
		/**
		 * 关闭高画质 
		 * 
		 */
		public function closeHightQuality():void
		{
			_gameSysSo.data.hightQuality = false;
			_gameSysSo.flush();
			_stage.quality = StageQuality.LOW;
		}
		/**
		 * 是否高画质 
		 * @return 
		 * 
		 */
		public function get isHightQuality():Boolean
		{
			return (_stage.quality == StageQuality.HIGH) || (_stage.quality == "HIGH") || (_stage.quality == StageQuality.BEST) || (_stage.quality == "BEST");
		}
	}
}
class SingletonEnforcer{}