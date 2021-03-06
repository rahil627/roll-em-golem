package states {
	import Audio.AudioManager;
	
	import com.bartnett.flebang.MusicSegment;
	
	import effects.*;
	
	import flash.display.BitmapData;
	import flash.events.TextEvent;
	import flash.media.Camera;
	
	import mx.core.FlexSprite;
	
	import org.flixel.*;
	
	import terrain.*;

	
	/**
	 * ...
	 * @author Stefan Woskowiak
	 */
	public class state_game extends FlxState {
		
		// The Player
		public var player:Player = new Player(0, 500);
		public var manager:TileManager = new TileManager(0, 295);
		public const nTileWidth:Number = 32;
		public const nTileHeight:Number = 32;

		public var bResetActiveGroup:Boolean = false;

		/**
		 * Use this object to handle collision b/t player and terrain
		 */
		private var terrainCollision:HandleTerrainCollision = new HandleTerrainCollision();
		
		/**
		 * This flxgroup will contain all of the enemies within the stage
		 */
		private var enemy_group:FlxGroup = new FlxGroup();
		
		private var terrain_group:FlxGroup = new FlxGroup();
		
		private var alreadyCreated:Boolean = false;
		

		
		[Embed(source = "../../assets/victory.png")]
		private var VictoryImage:Class;
		
		private var VictoryImageSprite:FlxSprite = new FlxSprite(140, 230, VictoryImage);
		
		/**
		 * Determines whether or not we should load the next stage
		 */
		public var bMoveToNextStage:Boolean = false;
		
		/**
		 * A level counter which determines what stage we should load upon create();
		 */
		private var nLevelNumber:Number = 1;

		[Embed(source="../../assets/level_1.csv",mimeType="application/octet-stream")]
		private var LevelFile:Class;
		
		[Embed(source = "../../assets/level_2.csv", mimeType = "application/octet-stream")] 
		private var LevelFile2:Class;
		
		[Embed(source = "../../assets/level_3.csv", mimeType = "application/octet-stream")] 
		private var LevelFile3:Class;
		
		[Embed(source="../../assets/audio/land.mp3")] private static const LandMp3:Class;
		
		
		public var Shadow1:FlxShadow = new FlxShadow(player.x, player.y, 0.5, player, 0.0);
		
		/*private var Shadow2:FlxShadow = new FlxShadow(player.x, player.y, 0.45, player, 0.15);		
		private var Shadow3:FlxShadow = new FlxShadow(player.x, player.y, 0.40, player, 0.2);		
		private var Shadow4:FlxShadow = new FlxShadow(player.x, player.y, 0.35, player, 0.25);		
		*//**
		 * A pointer to the current level file to load
		 */
		private var CurrentFile:Class = LevelFile;

		private var dustEmitter:DustEmitter;
		
		public var backgroundGroup:BackgroundGroup;
		
		[Embed(source = '../../assets/foregroundbar transparent.png')]
		private const foregroundBarFileTransparent:Class;

		[Embed(source = '../../assets/foregroundbar.png')]
		private const foregroundBarFile:Class;
		
		
		private var foregroundBar:FlxSprite;
		private var foregroundBarTop:FlxSprite = new FlxSprite(0, 0, foregroundBarFile);
		private var foregroundBarBottom:FlxSprite = new FlxSprite(FlxG.width, FlxG.height, foregroundBarFile);
			
		private var audioManager:AudioManager = new AudioManager();
		
		public function state_game() {
		}
		
		override public function create():void {
			this.remove(VictoryImageSprite);
			//FlxG.visualDebug = true;
			foregroundBar = new FlxSprite(FlxG.width / 2, FlxG.height / 2, foregroundBarFileTransparent);
			foregroundBarTop = new FlxSprite(FlxG.width / 2, 0, foregroundBarFile);
			foregroundBarBottom = new FlxSprite(FlxG.width / 2, FlxG.height, foregroundBarFile);
			backgroundGroup = new BackgroundGroup();
			this.add(backgroundGroup);

			Shadow1.SetOffset(new FlxPoint(-7, manager.nYDistanceBetweenArrays-12));
			//this.add(borosPiece);
			
			dustEmitter = new DustEmitter();
			
			this.add(Shadow1);
			/*this.add(Shadow2);
			this.add(Shadow3);
			this.add(Shadow4);*/
			this.add(player);
		
			this.add(terrain_group);
			this.add(dustEmitter);
			FlxG.camera.setBounds( -15, 0, 1200, 600, false);
			
			//test
			//for (var i = 0; i < 15; i += 3)
			//{
			//for (var j = 0; j < 9; j += 3)
			//{
			//manager.CreateTile(i, j, 2);
			//
			//manager.CreateTile(i, j, 2, true);
			//
			//}
			//}
			manager.LoadLevel(new CurrentFile);
			manager.LoadLevel(new CurrentFile, true);
			
			foregroundBar.y -= foregroundBar.height / 2;
			foregroundBar.x -= foregroundBar.width / 2;
			this.add(foregroundBar);
			
			foregroundBarTop.y -= foregroundBarTop.height / 2;
			foregroundBarTop.x -= foregroundBarTop.width / 2;
			this.add(foregroundBarTop);
			
			foregroundBarBottom.y -= foregroundBarBottom.height / 2;
			foregroundBarBottom.x -= foregroundBarBottom.width / 2;
			this.add(foregroundBarBottom);
			
			if (!alreadyCreated) {
				audioManager.resetEverything();
				audioManager.targetMusic("Intro", false, 130, 12*4);
				audioManager.targetMusic("Loop", true, 130, -9999, MusicSegment.TRANS_BEHAVIOR_STOP, 1.0);
				alreadyCreated = true;
			}
		}
		
		override public function update():void {

			FlxG.collide(player, manager.activeGroup, handlePlayerTerrainCollision);	// <-- 
			
			if (FlxG.keys.justPressed("P")) {
				StageCompleteEvent();
			}
			// If game over press enter to restart
			if (nLevelNumber >= 4)
			{
				if (FlxG.keys.pressed("ENTER"))
				{
					nLevelNumber = 0;
					StageCompleteEvent();
				}
			}
			
			
			if (this.bResetActiveGroup)
			{
				//manager.activeGroup.callAll("ResetForIteration", true);
				this.bResetActiveGroup  = false;				

				for each (var target:Object in this.members)
				{
					if (target != null)
					{								
						if (target as BaseTile)
						{
							if (target as GrassTile)
							{
								FlxG.log("collide with grass");//ouched tile at (" +this.nArrayX + "," + this.nArrayY +")  on " + this.nTouched);
								(target as GrassTile).ResetForIteration();
							}
							else if (target as MovableTile)
							{
								FlxG.log("collide with movable");
								(target as MovableTile).ResetForIteration();
							}
							else if (target as VineTile)
							{
								FlxG.log("collide with Vine");
								(target as VineTile).ResetForIteration()
							}
						}

					}
				}
			}
			
			manager.activeGroup.callAll("MyCustomUpdate", true);
			
			
			
			audioManager.update();

			super.update();
			
			//mytext.text = player.x.toString() + " , " + player.y.toString();
			
			
			// Handle the collision between the player and the TileArray/ActiveGroup
			//FlxG.collide(player, manager.activeGroup, terrainCollision.HandleCollision); //, player.HandleCollision or manager.HandleCollision);
			// Player collision to world
		}
		
		//TODO: testing
		public function handlePlayerTerrainCollision(myself:FlxSprite, target:FlxSprite):void {
			
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
			else if (target as GoalTile)
			{
				FlxG.log("collide with Goal");
				(target as GoalTile).HandleCollision(target, myself);	
				backgroundGroup.addEmblemPiece();
			}
			else if (target as VineTile)
			{
				FlxG.log("collide with Vine");
				(target as VineTile).HandleCollision(target, myself);
			}

			
			if(player.inAir && myself.isTouching(FlxObject.FLOOR)) {	
				player.inAir = false;
				
				//Emit dust particles
				for (var i:int = 0; i < dustEmitter.maxSize; i++){
					var dustParticle:FlxParticle = new FlxParticle();
					dustParticle.makeGraphic(3, 3, 0x9F732DFF);
					dustEmitter.add(dustParticle);
				}
				dustEmitter.x = target.x;
				dustEmitter.y = target.y;
				dustEmitter.start(true, 1);
				
				//Shake camera
				FlxG.camera.shake(.005, .1);
				// Play landing sound
				FlxG.play(LandMp3, AudioManager.LandVolume);
			}
		}
		
		/**
		 * Use this function to reload the current level
		 */
		public function ReloadLevel():void
		{
		
			// Clean up memory inthis stage
			manager.Clear();
			this.remove(dustEmitter);
			player.respawn(false);
			this.remove(player);			
			this.remove(backgroundGroup);
			//this.remove(foregroundBar);
			this.remove(foregroundBarTop);
			this.remove(foregroundBarBottom);
			
			// ReCreate this stage
			this.create();
		}

		/**
		 * Use this to perform stage complete FX & increment the level counter
		 */
		public function StageCompleteEvent():void
		{
			// Increase the level counter and update the LevelClass pointer
			++nLevelNumber;

			if (nLevelNumber == 1)
			{
				CurrentFile = LevelFile;
				ReloadLevel();				
				backgroundGroup.resetEmblemPieces();
			}
			else if (nLevelNumber == 2)
			{
				CurrentFile = LevelFile2;
				backgroundGroup.resetEmblemPieces();
				ReloadLevel();				
			}
			else if (nLevelNumber == 3)
			{
				CurrentFile = LevelFile3;
				backgroundGroup.resetEmblemPieces();
				ReloadLevel();
			}
			else if (nLevelNumber >= 4)
			{
				ReloadLevel();
				this.add(VictoryImageSprite);
				audioManager.cueFinishMusic();
				alreadyCreated = false;
			}
						
			
		}
	}
}