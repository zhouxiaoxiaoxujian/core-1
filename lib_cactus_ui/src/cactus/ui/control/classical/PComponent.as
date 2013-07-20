package cactus.ui.control.classical
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;

	[Event(name="resize", type="flash.events.Event")]
	[Event(name="draw", type="flash.events.Event")]
	public class PComponent extends Sprite
	{

		protected var _width:Number=0;
		protected var _height:Number=0;
		protected var _enabled:Boolean=true;

		public static const DRAW:String="draw";

		/**
		 * 
		 * @param parent	父组件
		 * @param xpos		偏移
		 * @param ypos
		 */
		public function PComponent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			move(xpos, ypos);
			init();
			if (parent != null)
			{
				parent.addChild(this);
			}
		}

		/**
		 * 
		 */
		protected function init():void
		{
			addChildren();
			invalidate();
		}

		/**
		 *
		 */
		protected function addChildren():void
		{

		}

		/**
		 * 
		 */
		protected function invalidate():void
		{
			addEventListener(Event.ENTER_FRAME, onInvalidate);
		}




		///////////////////////////////////
		// public methods
		///////////////////////////////////

		/**
		 * 
		 * @param xpos
		 * @param ypos
		 */
		public function move(xpos:Number, ypos:Number):void
		{
			x=Math.round(xpos);
			y=Math.round(ypos);
		}

		/**
		 * 
		 * @param w
		 * @param h
		 */
		public function setSize(w:Number, h:Number):void
		{
			_width=w;
			_height=h;
			dispatchEvent(new Event(Event.RESIZE));
			invalidate();
		}

		/**
		 * Abstract draw 
		 */
		public function draw():void
		{
			dispatchEvent(new Event(PComponent.DRAW));
		}




		///////////////////////////////////
		// event handlers
		///////////////////////////////////

		protected function onInvalidate(event:Event):void
		{
			removeEventListener(Event.ENTER_FRAME, onInvalidate);
			draw();
		}




		///////////////////////////////////
		// getter/setters
		///////////////////////////////////

		override public function set width(w:Number):void
		{
			_width=w;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get width():Number
		{
			return _width;
		}

		override public function set height(h:Number):void
		{
			_height=h;
			invalidate();
			dispatchEvent(new Event(Event.RESIZE));
		}

		override public function get height():Number
		{
			return _height;
		}


		override public function set x(value:Number):void
		{
			super.x=Math.round(value);
		}

		override public function set y(value:Number):void
		{
			super.y=Math.round(value);
		}

		public function set enabled(value:Boolean):void
		{
			_enabled=value;
			mouseEnabled=mouseChildren=_enabled;
			tabEnabled=value;
			alpha=_enabled ? 1.0 : 0.5;
		}

		public function get enabled():Boolean
		{
			return _enabled;
		}

	}
}
