package  terrain
{
	import Audio.AudioManager;
	
	import com.greensock.TweenMax;
	
	import org.flixel.*;
	
	import states.*;

	/**
	 * A tile that moves up when you hit it from the bottom, and moves down when the user jumps on the tie from the top. Nothing happens
	 * when you walk on the tile or do not touch it at all.
	 * @author Muffinsparticus
	 */
	public class MovableTile extends BaseTile
	{
		[Embed(source="../../assets/moveblock.png")] private static var ImgMoveBlock:Class;
		[Embed(source="../../assets/audio/blockmove.mp3")] private static const BlockMoveMp3:Class;
		
		public function MovableTile(x:Number, y:Number) 
		{
			super(x, y);
		//	FlxSprite.
			this.loadGraphic(ImgMoveBlock);
			this.width = (FlxG.state as state_game).nTileWidth;
			this.height = (FlxG.state as state_game).nTileHeight;
			
		}
		
		private var theTarget:Player;
		
		/**
		 * 
		 * @param	myself		the terrain object
		 * @param	target		the player it's colliding with
		 */
		override public function HandleCollision(myself:FlxSprite, target:FlxSprite):void 
		{						
			if (!this.bIterated )
			{
			
				this.nTouched = myself.touching;
				theTarget = (Player(target));
			
				var manager:TileManager = (FlxG.state as state_game).manager;
				
				// Only iterate
				//if (theTarget.velocity.y != 0)
				//{
					// Move Down
					if (this.nTouched == FlxObject.UP)
					{
						if (!theTarget.inAir) return;
						
						var IsTileBelow:Object = manager.MirrorArray.get(this.nArrayX, this.nArrayY + 1);
						if (!(IsTileBelow as BaseTile))
						{
								if (manager.MirrorArray.inRange(nArrayX, nArrayY +1))
								{
							
									manager.MirrorArray.swap(nArrayX, nArrayY, nArrayX, nArrayY +1);
									var mirror:BaseTile = manager.MirrorArray.get(nArrayX, nArrayY +1) as BaseTile;
									
									mirror.nArrayY += 1;
									TweenMax.to(mirror, 0.5, {x:mirror.x, y:mirror.y + 32});
									this.bIterated = true;
								FlxG.play(BlockMoveMp3, AudioManager.BlockMoveVolume);
								}
								else
								{
									// remove the tile if it's about to be placed off screen
									var theState:state_game = FlxG.state as state_game;						
									theState.remove(theState.manager.MirrorArray.get(this.nArrayX, this.nArrayY) as BaseTile);						
									manager.RemoveTile(this.nArrayX, this.nArrayY, true);
									this.bIterated = true;
								}
						}
					}
					// Move UP
					else if (this.nTouched  == FlxObject.DOWN)
					{

						var IsTileAbove:Object = manager.MirrorArray.get(this.nArrayX, this.nArrayY - 1);
						if (!(IsTileAbove as BaseTile))
						{							
					
							//if (nArrayY -1 > 0)
							//{
								if (manager.MirrorArray.inRange(nArrayX, nArrayY -1))
								{					
									manager.MirrorArray.swap(nArrayX, nArrayY, nArrayX, nArrayY -1);
									var mirror:BaseTile = manager.MirrorArray.get(nArrayX, nArrayY -1) as BaseTile;								
									mirror.nArrayY -= 1;
									TweenMax.to(mirror, 0.5, { x:mirror.x, y:mirror.y - 32 } );
									FlxG.play(BlockMoveMp3, AudioManager.BlockMoveVolume);
									this.bIterated = true;
								}
								else
								{
									// remove the tile if it's about to be placed off screen
									var theState:state_game = FlxG.state as state_game;						
									theState.remove(theState.manager.MirrorArray.get(this.nArrayX, this.nArrayY) as BaseTile);						
									manager.RemoveTile(this.nArrayX, this.nArrayY, true);
									this.bIterated = true;
								}
							//}	
							//else
							//{
							//	FlxG.a
							//}
							
						}
					}
					// Move RIGHT
					else if (this.nTouched == FlxObject.LEFT && Player(target).isDashing)
					{
						var IsTileBelowDirt:Object = manager.MirrorArray.get(this.nArrayX, this.nArrayY + 1);
						var IsTileToTheRight:Object = manager.MirrorArray.get(this.nArrayX + 1, this.nArrayY);
						
						// Cannot move if a tree is touched from below
						if (IsTileBelowDirt as GrassTile || IsTileBelowDirt  as VineTile) 
						{
							return ;
						}
						
						if (!(IsTileToTheRight as BaseTile))
						{
							if (manager.MirrorArray.inRange(nArrayX + 1, nArrayY ))
							{
					
								manager.MirrorArray.swap(nArrayX, nArrayY, nArrayX +1, nArrayY);
								var mirror:BaseTile = manager.MirrorArray.get(nArrayX+1, nArrayY) as BaseTile;
								
								mirror.nArrayX += 1;
								TweenMax.to(mirror, 0.5, {x:mirror.x + 32, y:mirror.y });
								FlxG.play(BlockMoveMp3, AudioManager.BlockMoveVolume);
								this.bIterated = true;
								
							}
						}
						
					}
				//}
			
			}
		}
		
		/**
		 * 
		 */
		/*public override function IterateTile()
		{		
			var thestate:state_game = FlxG.state as state_game;
		}*/


	}

}
