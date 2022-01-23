package enemy
{
	import org.flixel.*;
	
	/**
	 * ...
	 * @author Muffinsparticus
	 */
	public class BaseEnemy extends FlxSprite
	{		
		/**
		 * The tile that will be created upon the enemy's death.
		 */
		public var nTileType:Number; 		
		/**
		 * How far away from the enemy the new Tile will be created.
		 */
		public var nOffset:FlxPoint;
		
		
		public function BaseEnemy(x:Number, y:Number) 
		{
			super(x, y);
		}
		
	
		/**
		 * 
		 */
		public function HandleCollision(oObject1:FlxObject, oObject2:FlxObject):void
		{
			
		}
		
		public override function update():void
		{
			super.update();
		}
		
	}

}