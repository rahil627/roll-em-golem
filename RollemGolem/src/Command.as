package  
{
	import flash.display.BitmapData ;
	import org.flixel.FlxPoint;
	/**
	 * ...
	 * @author Muffinsparticus
	 */
	public class Command
	{
		/**
		 * The key that was pressed during this frame
		 */
		public var input:Array;
		/**
		 * The target's X velocity during this frame
		 */
		public var vX:Number;
		/**
		 * The target's Y velocity during tihs frame
		 */
		public var vY:Number;
		
		/**
		 * The target's velocity during this frame
		 */
		public var velocity:FlxPoint;
		/**
		 * The number of seconds that must pass before this command can be processed
		 */
		public var delay:Number;				
		/**
		 * The bitmap of the sprite during this frame
		 */
		public var bitmap:BitmapData;
		

		public function Command(x:Number, y:Number,  tDelay:Number, bBitMap:BitmapData = null)
		{
			vX = x;
			vY = y;
			delay = tDelay;
			bitmap = bBitMap;
		}
	
		/**
		 * 
		 * @param	nElapsedTime	The amount of time that has elapsed since the last frame
		 * @return  				if delay <= 0 then return the key pressed by the user, otherwise return NULL
		 */
		public function GetInput(nElapsedTime:Number): Array
		{
			delay -= nElapsedTime;			
			if (delay <= 0) 
			{
				return input;
			}
			else
			{
				return null;
			}			
		}		
	}

}