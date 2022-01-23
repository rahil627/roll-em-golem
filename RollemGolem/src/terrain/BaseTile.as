package  terrain
{
	import states.*;
	import org.flixel.*;
	/**
	 * ...
	 * @author Muffinsparticus
	 */
	public class BaseTile extends FlxSprite 
	{
		/**
		 * Has this tile been jumped on in this iteration
		 */
		public var bHaveIBeenTouched:Boolean = false;		
		
		public var bIterated:Boolean = false;
		
		
		/**
		 * Pointer to player so that we don't have to recast during the update function
		 */
		public var oPlayerRef:Player = null;
		/**
		 * The direction in which i've been touched by the player.
		 */
		public var nTouched:Number = -1;
		
		/**
		 * Type of the tile
		 */
		public var nTileType:Number = -1;		
		/**
		 * What 'phase' is this tile in. This determines what the tile looks like and how it interacts with the player.  
		 */
		public var nEvolutionLevel:Number = 1;		
		/**
		 * Contains a reference to the tile that will evolve when the player passes this block
		 */
		public var oTileToEvolve:BaseTile;
		
		/**
		 * This tile's x position in it's array
		 */
		public var nArrayX:Number; 
		/**
		 * This tile's y position in it's array
		 */
		public var nArrayY:Number; 
		
		/**
		 * 
		 * @param	x
		 * @param	y
		 * @param	nNewType
		 */		
		public function BaseTile(x:Number = 0, y:Number = 0, nNewType:Number = -1 ) :void
		{		
			this.x = x;
			this.y = y;
			this.width = (FlxG.state as state_game).manager.nTileWidth;
			this.height = (FlxG.state as state_game).manager.nTileWidth;
			
			this.immovable = true;
			this.nTileType = nNewType;
			
			this.oPlayerRef = (FlxG.state as state_game).player;
		}
		
		
		public function create(x:Number = 0, y:Number = 0, nNewType:Number = -1 ):void
		{
			this.x = x;
			this.y = y;
			this.nTileType = nNewType;
			bIterated = false;
			bHaveIBeenTouched = false;
			nTouched = null;
		}
		
		/**
		 * Use this to reset the tiles once we reach the end of the stage.
		 */
		public function ResetForIteration():void
		{
			bHaveIBeenTouched = false;
			nTouched = -1;
			bIterated = false;		
		}
		
		/**
		 * Change the evolution level of this block whether or not the bIsJumpedOn is true or not
		 */
		public function ExecuteEvolution():void
		{
			if (bHaveIBeenTouched)
			{
				nEvolutionLevel += 1;
			}
			else
			{
				nEvolutionLevel -= 1;
			}
			
			// Handle the evolution of the t
			
		}
		
		/**
		 * Overrwrite this function to handle evolution 
		 */
		public function HandleEvolution(nAdjustEvolution:Number):void	
		{
			nEvolutionLevel += nAdjustEvolution;	
		}
		
		/**
		 * Use this to determine if player has moved past the tiles
		 * @param	player
		 * @return
		 */
		protected function IsHeroPastTile():Boolean
		{
			
			var IsHeroPastTile:Boolean = (oPlayerRef.x > (this.x + this.width));
			if (IsHeroPastTile)
			{
			//		FlxG.log("Hero has passed tile at (" +this.nArrayX + "," + this.nArrayY +") ");
			}
			return (oPlayerRef.x > (this.x + this.width));
		}
		
		protected function GetHero():Player
		{
			return oPlayerRef;
		}
		
		
		
		
		
		
	
		public function HandleCollision(myself:FlxSprite, target:FlxSprite):void
		{
					FlxG.log("Hero has touched tile at (" +this.nArrayX + "," + this.nArrayY +")  on " + this.nTouched);
				
		}

		/**
		 * Determines whether or not the tile has been touched
		 * @return True if nTouched is not null, false if nTouched is null
		 */
		public function HasBeenTouched():Boolean
		{
			return (nTouched != -1);
		}
		
		public function iterate():void 
		{
		
		}
		public  function MyCustomUpdate():void
		{
			//super.update();
		}

		override public function update():void 
		{
			 super.update();
		}
	}

}