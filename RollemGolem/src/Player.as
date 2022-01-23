package  
{
	import Audio.AudioManager;
	
	import events.*;
	
	import flash.events.Event;
	import flash.utils.*;
	
	import org.flixel.*;
	
	import states.state_game;
	
	import terrain.*;
	
	public class Player extends FlxSprite
	{
		// Origin position
		private var default_pos:FlxPoint = new FlxPoint();
		private var timer:FlxTimer = new FlxTimer();
		
		// Player variables
		private var player_speed:int = 100;
		private var player_jump:int = 420;
		public var inAir:Boolean = false;
		public var isDashing:Boolean = false;
		public var shouldRespawn:Boolean = false;
		public var shouldSwapTilesWithMirror:Boolean = false;
		public var shouldSwapMirrorWithTiles:Boolean = false;
		private var bCanRespawn:Boolean = true;
		
		[Embed(source = "../assets/tileset.png")] private const NewGraphic:Class;
		
		[Embed(source='../assets/character.png')] private const characterFile:Class
		
		[Embed(source="../assets/audio/jump.mp3")] private static const JumpMp3:Class;
		[Embed(source="../assets/audio/dash.mp3")] private static const DashMp3:Class;
		
		public function Player(x:int, y:int) 
		{	
			// Parent call
			super(x, y);
			this.default_pos.x = x;
			this.default_pos.y = y;
			this.loadGraphic(characterFile, true, false, 32, 32);
			this.width = 20;
			this.height = 20;
			this.offset.x = 6;
			this.offset.y = 12;
			
			//76-53
			var framesArray:Array = new Array();
			var frames:int = 76;
			for(var i:int = 0; i <= 23; i++) {
				framesArray[i] = frames;
				frames--;
			}
			
			this.addAnimation("idle", framesArray, 16, true);
			
			//52-15
			framesArray = new Array();
			frames = 52;
			for(var i:int = 0; i <= 37; i++) {
				framesArray[i] = frames;
				frames--;
			}
			
			this.addAnimation("walk", framesArray, 64, true);
			this.addAnimation("jump", [12, 11, 10, 9, 8, 7, 6, 5, 4], 16);
			this.addAnimation("fall", [3, 2, 1, 0], 8);
			this.addAnimation("dash", [88, 87, 86, 85, 84, 83, 82, 81, 80, 79, 77], 64);
			
			this.play("idle");
			
			//this.drag.x = player_speed * 10;
			
			// Velocity
			this.maxVelocity.x = 100;
			this.maxVelocity.y = 1000;
			
			// Drag
			this.drag.x = this.maxVelocity.x * 4;
			this.drag.y = this.maxVelocity.y * 4;
			this.acceleration.x = 0;
			this.acceleration.y = Common.GRAVITY;
			this.solid = true;
		}

		// Update ourselves
		override public function update():void
		{	
			// Is player moving up or down?
			if (this.velocity.y > 0) {
				this.inAir = true;
			}
			
			if (this.velocity.y < 0)
			{
				this.inAir = true;
			}
			
			// Controls
			if (FlxG.keys.justPressed("W") && this.velocity.y == 0) {
				this.velocity.y = -player_jump;
				FlxG.play(JumpMp3, AudioManager.JumpVolume);
			}
			/*if(FlxG.keys.pressed("A")) {
				this.velocity.x = -this.maxVelocity.x;
				this.facing = LEFT;
			}*/
			if(FlxG.keys.pressed("D")) {
				this.velocity.x = this.maxVelocity.x;
				//this.acceleration.x += 10000 * FlxG.elapsed;
				this.facing = RIGHT;
			}
			
			if (FlxG.keys.justPressed("I")) {
				this.loadGraphic(NewGraphic);
			}
			
			// Dash logic
			if (FlxG.keys.justPressed("SPACE") && !isDashing && this.velocity.y == 0) {
				isDashing = true;
				setTimeout(noDashing, 100);
				this.maxVelocity.x = 250;
				this.velocity.x = 250;
				FlxG.play(DashMp3, AudioManager.DashVolume);
			}
			
			// Jumped offscreen
			if (this.x > Common.WINDOW_WIDTH || this.y > Common.WINDOW_HEIGHT) {
				respawn();
				EventManager.dispatchEventByName("world_iteration");
			}
			
			if (FlxG.keys.pressed("R") && bCanRespawn)
			{
				respawnAndSwapMirrorWithTiles();
				bCanRespawn = false;
				
			}
			
			if (FlxG.keys.justReleased("R"))
			{
				bCanRespawn = true;
			}
			
			if (FlxG.keys.pressed("L"))
			{
				(FlxG.state as state_game).ReloadLevel();// .SwapTileswithMirror();						
			}
			
			//animation crap
			//TODO: if idle for a few seconds
			if (this.velocity.y < 0)
				this.play("jump");
			else if (this.velocity.y > 0)
				this.play("fall");
			else if (isDashing)
				this.play("dash");
			else if (this.velocity.x != 0 && this.velocity.y == 0 && !this.isDashing && !this.inAir)
				this.play("walk");
			else //if (this.velocity.x == 0 && this.velocity.y == 0)
				this.play("idle");
				
			super.update();
		}
		public function noDashing():void {
			this.maxVelocity.x = 100;
			isDashing = false;
		}
		
		/**
		 * respawn and optionally swapn the tiles with the mirror
		 * @param	bSwapTiles
		 */
		public function respawn(bSwapTiles:Boolean = true):void {
			shouldSwapTilesWithMirror = bSwapTiles;
			shouldRespawn = true;
			//this.x = default_pos.x;
			//this.y = default_pos.y;
			
			//(FlxG.state as state_game).manager.SwapTileswithMirror();
		}
		
		/**
		 * respawn and optionally spawn the mirro with the tiles
		 * @param	bSwapTiles
		 */
		public function respawnAndSwapMirrorWithTiles(bSwapTiles:Boolean = true):void {
			shouldSwapMirrorWithTiles = bSwapTiles;
			shouldRespawn = true;
		}
		
		override public function preUpdate():void 
		{
			if(shouldRespawn) {
				this.x = default_pos.x;
				this.y = default_pos.y;
				if (shouldSwapTilesWithMirror)
				{
					(FlxG.state as state_game).manager.SwapTileswithMirror();
					shouldSwapTilesWithMirror = false;
				}
				if (shouldSwapMirrorWithTiles)
				{
					(FlxG.state as state_game).manager.SwapMirrorwithTiles();					
					shouldSwapMirrorWithTiles = false;
				}
				
				shouldRespawn = false;
			}
			super.preUpdate();
		}
		
		/**
		 * Determines whether or not the FrogHero is jumping on the target.
		 * 
		 * @param	target		The enemy object which the hero might be jumping on
		 * @return	A boolean, true if the hero is above the the target
		 */
		public function IsJumpingOn(target:FlxSprite): Boolean
		{
				var this_bottom:Number = this.y - (this.height * 0.5);
				var target_height:Number = target.y + (target.height*0.5);
				if (this_bottom < target_height)
				{
					return true;
				}
			return false;
		}
		
		public function HandleCollision(myself:FlxSprite, target:FlxSprite):void
		{
			if (IsJumpingOn(target)) {
				target.health -= 1;
			}
			else {
				this.health -= 1;
			}
		}



	}

}