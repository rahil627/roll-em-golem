package 
{
//	TEH LIST OF THINGS THAT MUST BE DONE
//	TODO: Sound effects / music
//	TODO: Player animation
//	TODO: Try for an easier intro level 
//	TODO: Fix the iteration function
//	TODO: The BASE grass block can no longer die
//	TODO: And we need a means to reset a level completely
//	TODO: And to reset that current iteration
//	TODO: Those are the bigguns to have ourselves "complete"
//	TODO: Also fix the blocks from the top view sliding into the bottom view
	
	
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.*;
	import states.*;
	/**
	 * ...
	 * @author Stefan Woskowiak
	 */
	[SWF(width = "1024", height = "600", backgroundColor = "#000000")] //Set the size and color of the Flash file
	
	public class Game extends FlxGame
	{
		public function Game():void
		{	
			FlxG.debug = true;
			super(Common.WINDOW_WIDTH, Common.WINDOW_HEIGHT, state_game, 1, 60, 60);
		}
	}
}