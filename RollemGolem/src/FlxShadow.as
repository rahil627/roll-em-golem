package  
{
	
	import flash.display.BitmapData;
	import flash.display.BitmapData;
	import flash.display.InteractiveObject;
	import flash.events.TransformGestureEvent;
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import Command;
	/**
	 * Creates a shadow that follows the actions of a FlxSprite
	 * @author Muffinsparticus
	 */
	public class FlxShadow extends FlxSprite
	{
		/**
		 * (Update) Holds the newCommand in the update function.
		 */
		var _newCommand:Command;
		
		//
		var _offset:FlxPoint;
		/**
		 * The amount of time to wait after the until we process the first command.
		 */
		var initialDelay:Number;
		/**
		 * A list of all of the target's previous positions.
		 */
		var inputList:Array = new Array();		
		/**
		 * The FlxSprite this shadow will follow.
		 */
		var target:FlxSprite;
		
					
		/**
		 * FlxShadow constructor. 
		 * 
		 * @param	X			The initial X position of the FlxShadow
		 * @param	Y			The initial Y position of the FlxShadow
		 * @param	a			The alpha of the FlxShadow
		 * @param	newTarget	The FlxSprite object to follow
		 */
		public function FlxShadow(X:int, Y:int, a:Number, newTarget:FlxSprite, newDelay:Number = 0.15) 
		{
			super(X, Y);
			this.alpha = a;
			this.acceleration.y = 0;
			target = newTarget;
			this.initialDelay = newDelay;
			//this.color = 0x1111BB;
			//MyCreate(X, Y, update);	
		}
				
		public function MyCreate(X:int, Y:int, a:Number, newTarget:FlxSprite):void
		{
			this.x = X;
			this.y = y;
			this.alpha = a;
			this.acceleration.y = 0;
			target = newTarget;
			//this.color = 0x1111BB;
			//this.solid = true;
			//maxVelocity.x = 60;
			//maxVelocity.y = 300;
			//acceleration.y = 1200;		 
		}
		
		public function SetOffset(newOffset:FlxPoint):void
		{
			_offset = newOffset;
		}
		/**
		 * Adds a new x,y pair to the command list for this shadow to follow.
		 * 
		 * @param	nX		The x position of the FlxSprite during this frame
		 * @param	nY		The y position of the FlxSprite during this frame
		 */
		public function AddCommand(nX:Number, nY:Number):void
		{
			if (inputList.length == 0)
			{
				inputList.push(new Command(nX, nY, initialDelay));
			}
			else
			{
				inputList.push(new Command(nX, nY, 0));
			}
		}		
		
		public function AddCommandWithSprite(nX:Number, nY:Number, bBitmap:BitmapData):void
		{
			if (inputList.length == 0)
			{
				inputList.push(new Command(nX, nY, initialDelay, bBitmap));
			}
			else
			{
				inputList.push(new Command(nX, nY, 0, bBitmap));
			}
		}
		
		public override function update():void
		{
			//if (target.velocity.x != 0 || target.velocity.y != 0)
			//{
				AddCommandWithSprite(target.x, target.y, target.framePixels);
			//}
			
			if (inputList.length > 0)
			{
				var newcommand:Command = inputList[0];										
				newcommand.delay -= FlxG.elapsed;
											
				if (newcommand.delay <= 0)
				{
					this.x = newcommand.vX + _offset.x;
					this.y = newcommand.vY + _offset.y;				
					//this.pixels = target.framePixels;
					this.pixels = newcommand.bitmap;
					this.angle = target.angle;
					this.color = 0x000000;
					inputList.shift();			
				}
			}
			
			super.update();
		}				
	}	
}