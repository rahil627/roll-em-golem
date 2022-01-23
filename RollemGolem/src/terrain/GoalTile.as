package terrain
{
	import Audio.AudioManager;
	
	import org.flixel.*;
	
	import states.state_game;
	
	import terrain.BaseTile;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GoalTile extends BaseTile 
	{
		[Embed(source="../../assets/audio/collect.mp3")] private static const CollectMp3:Class;
		[Embed(source = '../../assets/boros1.png')]
		private const emblemPiece1File:Class;
		//private var emblemPiece1:FlxSprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2, emblemPiece1File);

		
		public function GoalTile(x:Number, y:Number) 
		{
			super(x, y);
			
			this.loadGraphic(emblemPiece1File);
			this.width = 32;
			this.height = 32;
			this.scale = new FlxPoint(.2, .2);
			this.offset.x += 72;
			this.offset.y += 72;
			

			//this.load(32, 32, 0xFFFFFF00);
			
			
			this.angularVelocity = 120;
		}
		
		
		override public function HandleCollision(myself:FlxSprite, target:FlxSprite):void 
		{
			super.HandleCollision(myself, target);
			FlxG.play(CollectMp3, AudioManager.CollectVolume);
			var state:state_game = (FlxG.state) as state_game;
			state.manager.RemoveTile(this.nArrayX, this.nArrayY, true);
			state.manager.RemoveTile(this.nArrayX, this.nArrayY, false);
			
			state.remove(this);
			state.manager.activeGroup.remove(this);
			

		}
	}

}