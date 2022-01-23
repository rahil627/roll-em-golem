package events
{
	import org.flixel.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * Global EventManager that wraps flash.events.EventDispatcher for convenience.
	 */
	public class EventManager extends FlxG
	{
		private static var eventDispatcher:EventDispatcher = new EventDispatcher();
		
		/**
		 * Add a listener to the global Event Manager.
		 * @param	type Type name of the event
		 * @param	listener Function(evt:Event):void to be called when the specified event type is raised.
		 * @param	priority Determines order in which listen is notified. Higher priority is notified first.
		 * @param	useWeakReference If true, losing reference to the object else results in garbage collection.
		 */
		public static function addEventListener(type:String, listener:Function, priority:int = 0, useWeakReference:Boolean = false):void
		{
			eventDispatcher.addEventListener(type, listener, false, priority, useWeakReference);
		}
		
		/**
		 * Dispatch a global Event by event name.
		 * @param	eventStr
		 * @return True if successful. False is bad. I'm throwing an exception when false.
		 */
		public static function dispatchEventByName(eventStr:String, dieOnFailure:Boolean=true):Boolean
		{
			var result:Boolean = eventDispatcher.dispatchEvent(new Event(eventStr));
			if (dieOnFailure && !result)
				throw new Error("This event failed to dispatch.");
			
			return result;
		}
		
		/**
		 * Dispatch a global Event object
		 * @param	event
		 * @return True if successful. False is bad.
		 */
		public static function dispatchEvent(event:Event):Boolean
		{
			return eventDispatcher.dispatchEvent(event);
		}
		
		// This function is only useful when using full on
		//public static function hasEventListener(type:String):Boolean
		//{
			//return eventDispatcher.hasEventListener(type);
		//}
		
		/**
		 * Remove an event listener from a specific event type.
		 * @param	type The event type as a string.
		 * @param	listener The listener callback to remove.
		 */
		public static function removeEventListener(type:String, listener:Function):void
		{
			eventDispatcher.removeEventListener(type, listener);
		}
		
		/**
		 * Check if an event type has any registered listeners.
		 * @param	type
		 * @return True is there are registered listeners, otherwise false.
		 */
		public static function willTrigger(type:String):Boolean
		{
			return eventDispatcher.willTrigger(type);
		}
	}
}