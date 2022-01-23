package events
{
	import org.flixel.FlxG;
	import org.flixel.FlxObject;
	/**
	 * ...
	 * @author Michael Bartnett
	 */
	public class Callback extends FlxObject
	{
		public var lambda:Function = null;
		public var duration:Number = 0;
		private var timer:Number = 0;
		
		public function Callback(timerLength:Number, lambda:Function)
		{
			//if (foo == null)
				//throw new ArgumentError("Ah ah ah, you didn't say the magic word.");
				
			duration = timerLength;
			this.lambda = lambda;
			timer = 0;
		}
		
		public function start():void
		{
			active = true;
			timer = 0;
		}
		
		
		public function rearm(timerLength:Number, lambda:Function):void
		{
			duration = timerLength;
			this.lambda = lambda;
			timer = 0;
		}
		
		override public function update():void
		{
//			FlxLogger.Log("CALLBACK TIMER RUNNING", FlxLogger.OH_SHIT_SHUT_ER_DOWN);
			timer += FlxG.elapsed;
			
			if (timer >= duration)
			{
				lambda.call();
				this.active = false;
			}
		}
	}

}

internal class SingletonEnforcer {}