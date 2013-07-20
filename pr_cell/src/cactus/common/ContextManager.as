package  cactus.common
{
	
	
	import org.spicefactory.parsley.core.context.Context;
	
	public class ContextManager
	{
		private static var _instance:ContextManager;
		
		public function ContextManager(lock:Lock)
		{
			if(!lock) throw new Error("ContextManager::constructor");
		}
		
		/**
		 * 保证只有一个实例 
		 * @return 
		 * 
		 */		
		public static function get instance():ContextManager
		{
			if(_instance) return _instance;
			
			_instance = new ContextManager(new Lock());
			
			return _instance;
		}
		
		private var _context:Context;
		
		/**
		 * 上下文的根 
		 * @return 
		 * 
		 */		
		public function get context():Context
		{
			return _context;
		}
		
		public function set context(value:Context):void
		{
			if ( !_context )
				_context = value;
		}
	}
}
class Lock{}