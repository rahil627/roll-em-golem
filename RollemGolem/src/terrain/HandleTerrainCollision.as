package  terrain
{
	import org.flixel.*;
	/**
	 * Use this class to Handle the collision of each terrain obkject in the state_game.as file
	 * @author Muffinsparticus
	 */
	public class HandleTerrainCollision 
	{
		
		public function HandleTerrainCollision() 
		{
			
		}
		
		public function HandleCollision(myself:FlxSprite, target:FlxSprite):void
		{

			//FlxG.log(target as GrassTile);
			if (target as GrassTile)
			{
				FlxG.log("collide with grass");//ouched tile at (" +this.nArrayX + "," + this.nArrayY +")  on " + this.nTouched);
				(target as GrassTile).HandleCollision(target, myself);
			}
			else if (target as MovableTile)
			{
				FlxG.log("collide with movable");
				(target as MovableTile).HandleCollision(target, myself);
			}
			else if (target as VineTile)
			{
				FlxG.log("collide with Vine");
				(target as VineTile).HandleCollision(target, myself);
			}
	
		}
		
	}

}