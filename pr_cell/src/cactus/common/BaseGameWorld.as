package cactus.common
{

	import flash.display.Sprite;

	import org.spicefactory.parsley.command.MappedCommandBuilder;
	import org.spicefactory.parsley.command.MappedCommands;
	import org.spicefactory.parsley.context.ContextBuilder;
	import org.spicefactory.parsley.core.context.Context;

	public class BaseGameWorld extends Sprite
	{

		private var _services : Vector.<Class> = null;

		/**
		 * 注册当前模块所提供的服务, 务必在initialize方法中调用
		 * @param serviceInterface 服务的接口类型, 如IGameAssetService
		 * @param serviceImplement 服务的实现者类型
		 *
		 */
		protected final function registerServices(serviceInterface : Class, serviceImplement : Class) : void
		{
			_services = _services || Vector.<Class>([]);
			_services[_services.length] = serviceInterface;
			registerObjectByClass(serviceImplement);
		}

		private var _definitions : Vector.<Class> = null;
		private var _definitionIds : Array = null;

		/**
		 * 将一个对象完全进行托管(支持InjectConstructor)
		 * @param definition 对象的类型
		 * @param id 对象的id
		 *
		 */
		protected final function registerObjectByClass(definition : Class, id : String = null) : void
		{
			_definitions = _definitions || Vector.<Class>([]);
			_definitionIds = _definitionIds || [];
			if (_definitions.indexOf(definition) == -1)
			{
				_definitions[_definitions.length] = definition;
				_definitionIds[_definitionIds.length] = id;
			}
		}

		private var _existInstances : Array = null;
		private var _existInstIds : Array = null;

		/**
		 * 将一个已存在的对象实例进行托管(不支持InjectConstructor)
		 * @param definition 对象实例, 实例id
		 *
		 */
		protected final function registerObjectByInstance(instance : Object, id : String = null) : void
		{
			_existInstances = _existInstances || [];
			_existInstIds = _existInstIds || [];
			if (_existInstances.indexOf(instance) == -1)
			{
				_existInstances[_existInstances.length] = instance;
				_existInstIds[_existInstIds.length] = id;
			}
		}

		private var _delayMappingCommands : Vector.<MappedCommandBuilder> = null;

		/**
		 * 动态地生成一个托管的消息映射Command
		 * @param command Command的类型
		 * @param mappingMessage 映射消息的类型
		 * @param selector 消息选择器
		 * @param scope command映射消息所在的域
		 * @param order 执行顺序
		 *
		 */
		public final function registerCommand(command : Class, mappingMessage : Class = null, selector : String = null, scope : String =
			null, order : int = 0) : void
		{
			if (command && mappingMessage)
			{
				var builder : MappedCommandBuilder = createMappingCommandBuilder(command, mappingMessage, selector, scope, order);
				!moduleContext && (_delayMappingCommands = _delayMappingCommands || Vector.<MappedCommandBuilder>([]));
				moduleContext ? builder.register(moduleContext) : (_delayMappingCommands[_delayMappingCommands.length] = builder);
			}
		}

		private var _delayRegisterHandlers : Array = null;

		/**
		 * 为服务端推送的消息注册单一监听器, 适用于后端频繁推送的请求, 注意可以为同一个消息注册多个监听器，且不会再广播ServerResponseMessage
		 * @param msgHint 对于有消息体的消息，此参数是消息体的class, 否则是消息的编号
		 * @param handlerClass 消息接收器的类
		 *
		 */
		public final function registerRPCHandler(msgHint : Object, handlerClass : Class) : void
		{
			registerObjectByClass(handlerClass);
			_delayRegisterHandlers = _delayRegisterHandlers || [];
			_delayRegisterHandlers[_delayRegisterHandlers.length] = {hint: msgHint, handler: handlerClass};
		}

		/**
		 * 对广播的ServerResponseMessage注册处理器, 注意对于后端频繁推送的请求请使用registerRPCHandler
		 * @param command
		 * @param messageName
		 *
		 */
//		public final function registerBroadcastRPCHandler(command:Class, messageName:String):void
//		{
//			registerCommand(command, ServerResponseMessage, messageName);
//		}

		private function createMappingCommandBuilder(command : Class, mappingMessage : Class, selector : String = null, scope : String =
			null, order : int = 0) : MappedCommandBuilder
		{
			var builder : MappedCommandBuilder = MappedCommands.create(command);
			builder = mappingMessage ? builder.messageType(mappingMessage) : builder;
			builder = selector ? builder.selector(selector) : builder;
			builder = scope ? builder.scope(scope) : builder;
			builder = builder.order(order);
			return builder;
		}

		protected final function registerMappingCommandToContext(context : Context) : void
		{
			var cmdbuilder : MappedCommandBuilder = null;
			while (_delayMappingCommands && _delayMappingCommands.length > 0)
			{
				cmdbuilder = _delayMappingCommands.pop();
				cmdbuilder.register(context);
			}
		}

//		
//		private var _xmlConfigs:Vector.<XML> = null;
//		/**
//		 * 追加parsely配置文件
//		 * @param config
//		 *
//		 */		
//		protected final function appendXMLConfig(config:XML):void
//		{
//			_xmlConfigs = _xmlConfigs || Vector.<XML>([]);
//			_xmlConfigs.push(config);
//		}

		public function get moduleName() : String
		{
			return null;
		}

		private var _moduleContext : Context = null;

		public function get moduleContext() : Context
		{
			return _moduleContext || ContextManager.instance.context;
		}

		public function dispatchMessage(msg : Object, scope : String = null) : void
		{
			if (moduleContext)
			{
				if (scope)
				{
					moduleContext.scopeManager.getScope(scope).dispatchMessage(msg);
				}
				else
				{
					moduleContext.scopeManager.dispatchMessage(msg);
				}
			}
		}

		public function onRegister(contextBuilder : ContextBuilder, build : Boolean = true) : void
		{
			buildPredefineObjects(contextBuilder);
			if (build)
			{
				_moduleContext = contextBuilder.build();
			}
		}

		protected final function buildPredefineObjects(contextBuilder : ContextBuilder) : void
		{
			var existInstance : Object = null;
			var existInstId : String = null;
			while (_existInstances && _existInstances.length > 0)
			{
				existInstance = _existInstances.pop();
				existInstId = _existInstIds.pop();
				contextBuilder.object(existInstance, existInstId);
			}

			var definition : Class = null;
			var definitionId : String = null;
			while (_definitions && _definitions.length > 0)
			{
				definition = _definitions.pop();
				definitionId = _definitionIds.pop();
				if (definitionId)
				{
					contextBuilder.objectDefinition().forClass(definition).asSingleton().id(definitionId).register();
				}
				else
				{
					contextBuilder.objectDefinition().forClass(definition).asSingleton().register();
				}
			}
		}

//		protected final function registerPredefineRPCHandlers(netService:IGameCommunicationService, context:Context):void
//		{
//			if (_delayRegisterHandlers)
//			{
//				for each(var handlerInfo:Object in _delayRegisterHandlers)
//				{
//					netService.registerServerMessageHandler(handlerInfo.hint, context.getObjectByType(handlerInfo.handler) as IServerMessageHandler);
//				}
//				_delayRegisterHandlers.length = 0;
//			}
//		}

//		public function onRegisterComplete(context:IGameModuleContext):void
//		{
//		}
//		
//		public function getService(service:Class):IServiceBase
//		{
//			return _moduleContext ? _moduleContext.getObjectByType(service) as IServiceBase : null;
//		}

		public function get publishedServices() : Vector.<Class>
		{
			return _services.slice();
		}

		public function destroy() : void
		{
		}
	}
}


