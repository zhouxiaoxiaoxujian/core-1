/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.manager
{
	import com.greensock.TweenLite;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.plugins.VolumePlugin;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;


	/**
	 * 音效控制器
	 * @author Pengx
	 */
	public class SoundManager extends EventDispatcher
	{
		/**
		 * 背影音乐播放完成事件
		 */
		public static const BG_SOUND_COMPLETE : String = "bg_sound_complete";

		/**
		 * 加载缓冲 10 秒
		 */
		private var _soundLoaderContext : SoundLoaderContext = new SoundLoaderContext(10 * 1000);

		private var _tweener : TweenLite;

		//调试输出等级  0表示全部输出 等级越大 输出的东西越少越重要
		private var _traceMaskRank : int = 9;

		private static var _instance : SoundManager;

		//-------------一般声音-------------
		/**
		 * 声音字典 ,指向声音记录SoundObj
		 * name 对应 记录
		 */
		private var _soundsDict : Object = new Object();

		/**
		 * 通道字典，指向通道记录ChannelObj
		 * channel对象引用 对应 记录
		 */
		private var _channelDict : Dictionary = new Dictionary();

		/**
		 *  是否可播放声音
		 */
		public static var soundEnable : Boolean = true;

		//-------------背景声音-------------
		/**
		 * 背景声音通道
		 */
		private var _bgChannelObj : ChannelObj = new ChannelObj();

		/**
		 *  是否可播放背景声音
		 */
		public static var bgSoundEnable : Boolean = true;

		public function SoundManager(paramer : SingletonEnforcer)
		{
			TweenPlugin.activate([VolumePlugin]);
		}

		public static function getInstance() : SoundManager
		{
			if (_instance == null)
			{
				_instance = new SoundManager(new SingletonEnforcer());
			}
			//判断是否有声卡
			if (!Capabilities.hasAudio)
			{
				soundEnable = bgSoundEnable = false;
			}
			return _instance;
		}

		/**
		 *
		 * 添加声音
		 * @param s			一切的声音
		 * @param name		标识名字
		 * @return          是否成功添加
		 *
		 */
		public function addSound(s : *, name : String) : Boolean
		{
			if (this._soundsDict[name] != null)
				return false;

			//SoundObj
			var soundObj : SoundObj = new SoundObj();
			soundObj.name = name;
			soundObj.sound = getSound(s);
			soundObj.channels = new Array();

			this._soundsDict[name] = soundObj;

			return true;
		}

		/**
		 * 移除声音
		 * @param name	标识名字
		 *
		 */
		public function removeSound(name : String) : void
		{
			delete this._soundsDict(name);
		}

		/**
		 * 根据传入的任意声音类型获取声音
		 * @param s
		 * @return
		 *
		 */
		private function getSound(s : *) : Sound
		{
			var mySound : Sound;
			if (s is Sound)
			{
				//实例
				mySound = s as Sound;
			}
			else if (s is Class)
			{
				//类
				mySound = new s;
			}
			else if (s is String)
			{
				if (/^https?:/i.test(s))
				{
					//网络
					mySound = new Sound(new URLRequest(s), _soundLoaderContext);
					mySound.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
				}
				else
				{
					//库
					//_sound == Engine.getSound(s);
					var mySoundClass : Class = getDefinitionByName(s) as Class;
					mySound = new mySoundClass();
				}
			}

			return mySound;
		}

		private function ioErrorHandler(event : Event) : void
		{
			doTrace("ioErrorHandler: " + event, 2);
		}


		/**
		 * 播放声音
		 * @param name			声音名字 - addSound添加的名字
		 * @param volume		音量
		 * @param startTime		开始时间
		 * @param loops			循环次数
		 * @return 				声音通道id
		 *
		 */
		public function playSound(name : String, volume : Number = 1, startTime : Number = 0, loops : int = 0) : int
		{
			if (!soundEnable)
				return 0;
			var soundObj : SoundObj = _soundsDict[name];

			//ChannelObj
			var channelObj : ChannelObj = new ChannelObj();
			channelObj.soundObj = soundObj;
			channelObj.volume = volume;
			channelObj.startTime = startTime;
			channelObj.loops = loops;

			try
			{
				channelObj.channel = soundObj.sound.play(channelObj.startTime, channelObj.loops, new SoundTransform(channelObj.
					volume));
				innerPlaySound(channelObj);

				channelObj.id = getTimer();
				while (soundObj.findChannel(channelObj.id) != null)
				{
					channelObj.id = int((Math.random() * 100000));
				}
				soundObj.channels.push(channelObj);
			}
			catch (e : Error)
			{
				this.doTrace("soundError", 10);
			}

			return channelObj.id;
		}

		private function innerPlaySound(channelObj : ChannelObj) : void
		{
			_channelDict[channelObj.channel] = channelObj;
			channelObj.channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete, false, 0, true);
			channelObj.paused = false;
		}

		private function innerStopSound(channelObj : ChannelObj) : void
		{
			channelObj.position = channelObj.channel.position % channelObj.soundObj.sound.length;
			channelObj.channel.stop();
			channelObj.paused = true;
		}

		/**
		 * 停止声音
		 * @param name  声音名字 - addSound添加的名字
		 * @param id    声音通道id 如果为-1 停止当前播放当前声音的所有声道
		 *
		 */
		public function stopSound(name : String, id : int = -1) : void
		{
			var soundObj : SoundObj = _soundsDict[name];
			var channelObj : ChannelObj;
			if (id == -1)
			{
				doTrace("停止播放" + name + "的所有声音 channels 个数:" + soundObj.channels.length);
				for (var i : int = 0; i < soundObj.channels.length; i++)
				{
					channelObj = soundObj.channels[i] as ChannelObj;
					if (channelObj.channel != null)
					{
						innerStopSound(channelObj);
					}
				}
			}
			else
			{
				channelObj = soundObj.findChannel(id);
				if (channelObj != null && channelObj.channel != null)
				{
					innerStopSound(channelObj);
				}
			}
		}

		/**
		 * 继续播放声音
		 * @param name 声音名字 - addSound添加的名字
		 * @param id   声音通道id 如果为-1 继续播放所有停止的声道的声音
		 *
		 */
		public function continueSound(name : String, id : int = -1) : void
		{
			if (!soundEnable)
				return;
			var soundObj : SoundObj = _soundsDict[name];
			var channelObj : ChannelObj;
			try
			{
				if (id == -1)
				{
					doTrace("继续播放" + name + "的所有声音 channels 个数:" + soundObj.channels.length);
					for (var i : int = 0; i < soundObj.channels.length; i++)
					{
						channelObj = soundObj.channels[i] as ChannelObj;
						if (channelObj.channel != null && channelObj.paused == true)
						{
							channelObj.channel = soundObj.sound.play(channelObj.position, channelObj.loops, new SoundTransform(channelObj.
								volume));
							innerPlaySound(channelObj);
						}
					}
				}
				else
				{
					channelObj = soundObj.findChannel(id);
					if (channelObj != null && channelObj.channel != null && channelObj.paused == true)
					{
						channelObj.channel = soundObj.sound.play(channelObj.position, channelObj.loops, new SoundTransform(channelObj.
							volume));
						innerPlaySound(channelObj);
					}
				}
			}
			catch (e : Error)
			{
				this.doTrace("soundError", 10);
			}
		}

		/**
		 * 声音缓动
		 * @param name  	声音名字 - addSound添加的名字
		 * @param id		声音通道id 如果为-1 继续播放所有停止的声道的声音
		 * @param volume	缓动到的音量
		 * @param fadeTime  缓动时间
		 *
		 */
		public function fadeSound(name : String, id : int, volume : Number = 0, fadeTime : Number = 1) : void
		{
			var soundObj : SoundObj = this._soundsDict[name];
			var channelObj : ChannelObj = soundObj.findChannel(id);
			var fadeChannel : SoundChannel = channelObj.channel;
			_tweener = TweenLite.to(fadeChannel, fadeTime, {volume: volume, onComplete: onTweenComplete});
		}

		/**
		 * 返回背景音乐的SoundChannel
		 * @return
		 *
		 */
		public function get bgChannel() : SoundChannel
		{
			if (_bgChannelObj == null)
				return null;
			return _bgChannelObj.channel;
		}

		/**
		 * 播放背景声音
		 * @param name			声音名字 - addSound添加的名字
		 * @param volume		音量
		 * @param startTime		开始时间
		 * @param loops			循环次数
		 * @return 				声音通道id
		 *
		 */
		public function playBgSound(name : String, volume : Number = 1, startTime : Number = 0, loops : int = int.MAX_VALUE) : void
		{
			doTrace("播放背景声音");

			stopBgSound(false);
			var soundObj : SoundObj = _soundsDict[name];

			//ChannelObj
			_bgChannelObj = new ChannelObj();
			_bgChannelObj.soundObj = soundObj;
			_bgChannelObj.volume = volume;
			_bgChannelObj.startTime = startTime;
			_bgChannelObj.loops = loops;
			_bgChannelObj.position = 0;
			_bgChannelObj.id = 0;
			if (!bgSoundEnable)
			{
				_bgChannelObj.paused = true;
				return;
			}
			try
			{
				_bgChannelObj.channel = soundObj.sound.play(_bgChannelObj.startTime, _bgChannelObj.loops, new SoundTransform(0));
				_bgChannelObj.channel.addEventListener(Event.SOUND_COMPLETE, onBgSoundComplete);
				_bgChannelObj.paused = false;
				//渐入		
				_tweener = TweenLite.to(_bgChannelObj.channel, 3, {volume: _bgChannelObj.volume, onComplete: onTweenComplete});
			}
			catch (e : Error)
			{
				this.doTrace("bgSoundError", 10);
			}
		}

		private function onBgSoundComplete(e : Event) : void
		{
			this.dispatchEvent(new Event(BG_SOUND_COMPLETE));
		}

		/**
		 * 停止背景声音
		 * @param ifTween 	是否缓动
		 * @param ifRemove 	是否完全移除（不能继续)
		 */
		public function stopBgSound(ifTween : Boolean = true, ifRemove : Boolean = false) : void
		{
			doTrace("停止播放背景声音");
			if (_bgChannelObj != null && _bgChannelObj.channel != null)
			{
				_bgChannelObj.position = _bgChannelObj.channel.position % _bgChannelObj.soundObj.sound.length;
				_bgChannelObj.channel.removeEventListener(Event.SOUND_COMPLETE, onBgSoundComplete);
				//_bgChannelObj.channel.stop();
				//渐出	
				if (ifTween)
				{
					_tweener = TweenLite.to(_bgChannelObj.channel, 1, {volume: 0, onComplete: onFinishTween, onCompleteParams: [_bgChannelObj.channel]});
				}
				else
				{
					_bgChannelObj.channel.stop();
				}
				_bgChannelObj.paused = true;
				if (ifRemove)
				{
					_bgChannelObj = null;
				}
				doTrace("成功停止");
			}
		}

		private function onFinishTween(channel : SoundChannel) : void
		{
			doTrace("channel.stop()");
			channel.stop();
			onTweenComplete()
		}

		/**
		 * 继续播放背景声音
		 *
		 */
		public function continueBgSound() : void
		{
			doTrace("继续播放背景声音");
			if (!bgSoundEnable)
				return;
			try
			{
				if (_bgChannelObj != null && _bgChannelObj.paused == true)
				{
					_bgChannelObj.channel = _bgChannelObj.soundObj.sound.play(0, _bgChannelObj.loops, new SoundTransform(1));
					_bgChannelObj.channel.addEventListener(Event.SOUND_COMPLETE, onBgSoundComplete);
					//渐入		
					_tweener = TweenLite.to(_bgChannelObj.channel, 1, {volume: _bgChannelObj.volume, onComplete: onTweenComplete});
					_bgChannelObj.paused = false;
					doTrace("成功继续,继续位置为：" + _bgChannelObj.position + " 总长度:" + _bgChannelObj.soundObj.sound.length);
				}
			}
			catch (e : Error)
			{
				this.doTrace("bgSoundError", 10);
			}
		}

		/**
		 * 停止所有声音
		 *
		 */
		public function stopAllSound() : void
		{
			doTrace("停止播放所有声音");
			var soundObj : SoundObj;
			var channelObj : ChannelObj;
			for (var name : String in this._soundsDict)
			{
				soundObj = this._soundsDict[name];
				for (var i : int = 0; i < soundObj.channels.length; i++)
				{
					channelObj = soundObj.channels[i] as ChannelObj;
					if (channelObj.channel != null)
					{
						innerStopSound(channelObj);
					}
				}
			}
		}

		/**
		 * 继续播放所有声音
		 *
		 */
		public function continueAllSound() : void
		{
			if (!soundEnable)
				return;
			doTrace("继续播放所有声音");
			var soundObj : SoundObj;
			var channelObj : ChannelObj;
			for (var name : String in this._soundsDict)
			{
				soundObj = this._soundsDict[name];
				for (var i : int = 0; i < soundObj.channels.length; i++)
				{
					channelObj = soundObj.channels[i] as ChannelObj;
					if (channelObj.channel != null && channelObj.paused == true)
					{
						channelObj.channel = soundObj.sound.play(channelObj.position, channelObj.loops, new SoundTransform(channelObj.
							volume));
						innerPlaySound(channelObj);
					}
				}
			}
		}

		/**
		 * 某个通道播放完成
		 * @param e
		 *
		 */
		private function onSoundComplete(e : Event) : void
		{
			doTrace("播放完成:" + e.target);
			var channel : SoundChannel = e.target as SoundChannel;
			var channelObj : ChannelObj = _channelDict[channel];
			delete _channelDict[channel];
			channelObj.soundObj.channels.splice(channelObj.soundObj.channels.indexOf(channelObj), 1);
		}

		/**
		 * 是否声音暂停中
		 * @param name 声音名字 - addSound添加的名字
		 * @return
		 *
		 */
		public function isSoundPaused(name : String, id : int) : Boolean
		{
			return this._soundsDict[name].findChannel(id).paused;
		}

		//调试输出
		private function doTrace(str : String, rank : int = 0) : void
		{
			if (rank >= _traceMaskRank)
			{
				trace("[EffectSoundManager] " + str);
			}
		}

		//TweenLite结束
		private function onTweenComplete() : void
		{
			if (_tweener)
			{
				// 以前是_tweener.clear()，编程kill未验证
				_tweener.kill();
				_tweener = null;
			}
		}


	}
}



class SingletonEnforcer
{
}
