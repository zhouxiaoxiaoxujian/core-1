package cactus.ui.base
{
	import com.greensock.TweenLite;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	import cactus.ui.events.EventMap;
	import cactus.ui.events.ViewEvent;

	/**
	 * 基本视图对象
	 * @author Pengx
	 * @version 1.0
	 * @created 03-八月-2010 14:19:08
	 */
	public class BaseView extends MovieClip
	{
		/**
		 * 外部传递进来的数据
		 */
		protected var _params : Array;
		/**
		 * 资源和数据准备器
		 * 在子类的构造函数里面添加需要加载的资源和数据
		 */
		protected var _preparator : ResourceAndDataPreparator;


		protected var _eventMap : EventMap;

		/**
		 *
		 * @param autoDispose	是否自动释放，默认为是
		 */
		public function BaseView(autoDispose : Boolean = true)
		{
			if (autoDispose)
			{
				this.addEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
			}
			_preparator = new ResourceAndDataPreparator();
			_eventMap = new EventMap(this);
		}

		public function addViewListener(type : String, listener : Function, eventClass : Class = null, useCapture : Boolean =
			false, priority : int = 0, useWeakReference : Boolean = true) : void
		{
			_eventMap.mapListener(this, type, listener, eventClass, useCapture, priority, useWeakReference);
		}

		public function getEventMap() : EventMap
		{
			return _eventMap;
		}

		/**
		 * 自动移除
		 * @param evt
		 */
		protected function removeStageEvent(evt : Event) : void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeStageEvent);
			destory();
		}

		/**
		 * 释放资源
		 */
		public function destory() : void
		{
			if (_preparator)
			{
				_preparator.destory();
			}
			_eventMap.unmapListeners();
			_eventMap = null;
			_preparator = null;
			_params = null;

			while (numChildren > 0)
			{
				removeChildAt(0);
			}
		}

		/**
		 * 数据资源都准备好的时候调用
		 * 子类可根据具体情况重写此方法
		 * 一般用于构建和绑定ui
		 */
		protected function onAllReady() : void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.ALL_READY));
		}

		/**
		 * 准备出错了
		 * 子类可重写
		 */
		protected function onReadyError() : void
		{
			trace(getQualifiedClassName(this) + " build or load Error!");
		}

		/**
		 * 完全显示出来时调用
		 * 子类可根据具体情况重写此方法
		 * 一般用于弹出窗口显示提示信息等操作
		 */
		protected function onShowIned() : void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.SHOW_INED));
		}

		/**
		 * 完全消失时调用
		 * 子类可根据具体情况重写此方法
		 */
		protected function onShowOuted() : void
		{
			this.dispatchEvent(new ViewEvent(ViewEvent.SHOW_OUTED));
		}

		/**
		 * 前期准备完毕（在此方法内准备数据和资源）
		 * 提供给管理器调用，一般不用显示调用此方法
		 */
		public function prepareReady() : void
		{
			_preparator.prepareAll(onAllReady, onReadyError);
		}

		/**
		 * 设置准备参数
		 *
		 * @param params
		 */
		public function setPrepareParams(params : Array) : void
		{
			_params = params;
		}

		/**
		 * 显示
		 */
		public function showIn() : void
		{
//			this.visible = true;
//			//自定义进入显示效果
//			this.alpha = 0;
//			TweenLite.to(this, .5, {alpha: 1, onComplete: onShowIned});
			onShowIned();
		}

		/**
		 * 移除
		 */
		public function showOut() : void
		{
			//自定义退出显示效果
//			TweenLite.to(this, .5, {alpha: 0, onComplete: onShowOuted});
			onShowOuted();
		}

	} //end BaseView

}
