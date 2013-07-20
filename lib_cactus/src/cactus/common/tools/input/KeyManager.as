/**
 * Cactus Game Lib
 * Copyright (c) 2013 Cactus, http://www.flbuddy.com , see the LICENCE.txt
 *
 */
package cactus.common.tools.input
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.utils.*;

	/**
	   保存 按键的状态
	 */
	public class KeyManager
	{

		// Constants:
		// Public Properties:
		// Private Properties:
		private static var dict : Dictionary = new Dictionary(true);
		private static var stage : DisplayObject;

		//开始处理按键事件
		public static function startKeysListening(stage : DisplayObject) : void
		{
			KeyManager.stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			dict = new Dictionary(true);
		}

		//停止处理
		public static function stopKeysListening() : void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
			dict = null;
		}

		// Public Methods:
		private static function keyDown(e : KeyboardEvent) : void
		{
			dict[e.keyCode] = true;
		}

		private static function keyUp(e : KeyboardEvent) : void
		{
			dict[e.keyCode] = false;
		}

		/**
		 * keys是否都按下:
		 * 1: Keyboard,或Keys,里面的枚举
		 * 2: 键码
		 * */
		public static function isKeyDown(... keys) : Boolean
		{
			for (var i : int = 0; i < keys.length; i++)
			{
				if (!dict[keys[i]])
					return false;
			}
			return true;
		}

		/**
		 * keys是否都弹起,参数内容为:
		 * 1: Keyboard,或Keys,里面的枚举
		 * 2: 键码
		 * */
		public static function isKeyUp(... keys) : Boolean
		{
			for (var i : int = 0; i < keys.length; i++)
			{
				if (dict[keys[i]])
					return false;
			}
			return true;
		}
		// Protected Methods:
	}

}
