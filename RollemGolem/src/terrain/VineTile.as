package  terrain
{
	import Audio.AudioManager;
	
	import org.flixel.*;
	
	import states.*;

	/**
	 * ...
	 * @author Muffinsparticus
	 */
	public class VineTile extends BaseTile
	{
		
		[Embed(source="../../assets/vinesmiddle.png")] private static var ImgVineBlock:Class;
		
		/**
		 * 
		 * @param	x	Pixel coordinates of the tile on the x-axis
		 * @param	y	Pixel coordinates of the tile on the y-axis
		 */
		public function VineTile(x:Number, y:Number) 
		{
			super(x, y);
			this.x = x;
			this.y = y;
			this.loadGraphic(ImgVineBlock);
			this.nTileType = 2;
			this.immovable = true;	// Tiles don't move on collision
			this.bIterated = false;
			this.scale.x = 0.5;
			this.scale.y = 0.5;
			this.offset.x = 32;
			this.offset.y = 32;
			this.width = (FlxG.state as state_game).nTileWidth;
			this.height = (FlxG.state as state_game).nTileHeight;
			

		}
		
		public override function iterate():void
		{
			
			super.iterate();
			// don't continue if this has already been iterated on
			if (this.bIterated) { return; }	
				
			var theState:state_game = FlxG.state as state_game;
			
			FlxG.log(this.HasBeenTouched());
			if (!this.HasBeenTouched())
			{
				//var theNeighbor:Object = theState.manager.GetNeighbor(this.nArrayX, this.nArrayY, FlxObject.UP, true);				
				var bHasNeighbor:Boolean = (theState.manager.GetNeighbor(this.nArrayX, this.nArrayY, FlxObject.UP, true) as BaseTile);
				FlxG.log ("Does Vine tile at (" +this.nArrayX + "," + this.nArrayY +") have a neighbor?: " + bHasNeighbor );
				
				if (!bHasNeighbor)
				{
					FlxG.play(GrassTile.PlantGrowMp3, AudioManager.PlantGrowVolume);
					theState.manager.CreateTile(this.nArrayX, this.nArrayY - 1, VineTile, true);
				}
				
				bIterated = true;
				//FlxG.log("Vine tile at (" +this.nArrayX + "," + this.nArrayY +") has been iterated. ");
			}
			else
			{
					theState.manager.RemoveTile(this.nArrayX, this.nArrayY, true);
			}
			
			
			
		}
		
		override public function HandleCollision(myself:FlxSprite, target:FlxSprite):void 
		{
			if (!this.bIterated )
			{
				this.nTouched = myself.touching;
			
				// Only remove this block if it's being touched from the bottom or top
				if (this.nTouched == FlxObject.CEILING || this.nTouched == FlxObject.FLOOR)
				{
					var theState:state_game = FlxG.state as state_game;
						
					theState.remove(theState.manager.MirrorArray.get(this.nArrayX, this.nArrayY) as BaseTile);
						
					theState.manager.RemoveTile(this.nArrayX, this.nArrayY, true);
					this.bIterated = true;
				}
			}						
		}

		
		public override function MyCustomUpdate():void
		{

						// avoid having to re-calculate whether the hero has passed this block
			if (!this.bIterated)
			{
				//FlxG.log("Testing iterating @ (" +this.nArrayX + "," + this.nArrayY +") , is hero active: " + this.GetHero() );
				
				var bIsHeroPastTile:Boolean  = this.IsHeroPastTile();
				if (bIsHeroPastTile)
				{
					//FlxG.log("Hero has passed tile at (" +this.nArrayX + "," + this.nArrayY +") ");
					this.iterate();					
				}
			}
			super.MyCustomUpdate();
			
		
		}
		
		override public function preUpdate():void 
		{

			super.preUpdate();
		}
		
		
		
	}

}