package cactus.common.tools.util
{
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
		Utilities for constructing and working with Classes.

		@author Aaron Clinger
		@version 02/13/10
	*/
	public class ClassUtil
	{

		/**
			Dynamically constructs a Class.

			@param type: The Class to create.
			@param arguments: Up to ten arguments to the constructor.
			@return Returns the dynamically created instance of the Class specified by <code>type</code> parameter.
			@throws Error if you pass more arguments than this method accepts (accepts ten or less).
			@example
				<code>
					var bData:* = ClassUtil.construct(BitmapData, 200, 200);

					trace(bData is BitmapData, bData.width);
				</code>
		*/
		public static function construct(type:Class, arguments:Array):*
		{
			if (arguments.length > 10)
				throw new Error('You have passed more arguments than the "construct" method accepts (accepts ten or less).');

			switch (arguments.length)
			{
				case 0:
					return new type();
				case 1:
					return new type(arguments[0]);
				case 2:
					return new type(arguments[0], arguments[1]);
				case 3:
					return new type(arguments[0], arguments[1], arguments[2]);
				case 4:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3]);
				case 5:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4]);
				case 6:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5]);
				case 7:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6]);
				case 8:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7]);
				case 9:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8]);
				case 10:
					return new type(arguments[0], arguments[1], arguments[2], arguments[3], arguments[4], arguments[5], arguments[6], arguments[7], arguments[8], arguments[9]);
			}
		}

		/**
		 * Returns a <code>Class</code> object that corresponds with the given
		 * name.
		 *
		 * @param name the name from which to return the class
		 * @param applicationDomain the optional applicationdomain where the instance's class resides
		 *
		 * @return the <code>Class</code> that corresponds with the given name
		 *
		 */
		public static function forName(name:String, applicationDomain:ApplicationDomain=null):Class
		{
			applicationDomain=(applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var result:Class;

			if (!applicationDomain)
			{
				applicationDomain=ApplicationDomain.currentDomain;
			}

			while (!applicationDomain.hasDefinition(name))
			{
				if (applicationDomain.parentDomain)
				{
					applicationDomain=applicationDomain.parentDomain;
				}
				else
				{
					break;
				}
			}

			try
			{
				result=applicationDomain.getDefinition(name) as Class;
			}
			catch (e:ReferenceError)
			{
				throw new Error("A class with the name '" + name + "' could not be found.");
			}

			return result;
		}

		/**
		 * Returns a <code>Class</code> object that corresponds with the given
		 * instance.
		 *
		 * @param instance the instance from which to return the class
		 * @param applicationDomain the optional applicationdomain where the instance's class resides
		 *
		 * @return the <code>Class</code> that corresponds with the given instance
		 *
		 */
		public static function forInstance(instance:*, applicationDomain:ApplicationDomain=null):Class
		{
			applicationDomain=(applicationDomain == null) ? ApplicationDomain.currentDomain : applicationDomain;
			var className:String=getQualifiedClassName(instance);
			return forName(className, applicationDomain);
		}
	}
}
