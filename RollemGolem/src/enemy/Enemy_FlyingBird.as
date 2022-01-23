package enemy
{
	import org.flixel.*;
	
	import terrain.GrassTile;
	import enemy.BaseEnemy;
	
	/**
	 * ...
	 * @author Muffinsparticus
	 */
	public class Enemy_FlyingBird extends BaseEnemy
	{
			/**
		 * Is the enemy moving left, or right? (True = left, False = right)
		 */
		private  var bIsMovingLeft:Boolean;		
		/**
		 * Number of seconds to move in one direction;
		 */
		private const nMaxMovingDuration:Number = 2.0; 		
		/**
		 * The amount of time the enemy has moved in one direction.
		 */
		private var nMoving_TimeElapsed:Number;		
		/**
		 * The speed at which this enemy will move.
		 */
		private const  nSpeed:Number = 125;
		/**
		 * The amount of time the enemy will spend in the fade state before being destroyed.
		 */
		private const nFading_MaxDuration:Number = 2.0;
		/**
		 * The amount of time the enemy has been in the fading state
		 */
		private var nFading_TimeElapsed:Number;
		/**
		 * The rate at which the enemy will fade into nothingness.
		 */
		private const nFading_RateOfFade:Number = 0.01;
		/**
		 * A FlxEmitter to display particles when the enemy is defeated.
		 */
		private var oDefeatEmitter:FlxEmitter;
		
		
		private const tileOffset:FlxPoint =  new FlxPoint(300, 0);
		
		
		private var bWalkingState:Boolean 
		private var bFadeState:Boolean;
	
		
		public function Enemy_FlyingBird(x:Number, y:Number) 
		{
			super(x, y);
			this.x = x;
			this.y = y;
			
			this.makeGraphic(30, 30, 0xFFFFFFFF);
			bIsMovingLeft = false;
			this.velocity.x = nSpeed;
			this.acceleration.y = 0;
			this.health = 1;
			this.solid = true;
			//this.solid = false;
			this.bWalkingState = true;
			this.bFadeState = false;
			this.nMoving_TimeElapsed = 0.0;
			this.nFading_TimeElapsed = 0.0;
		}

		/**
		 * Sets the x-velocity based on the bIsMovingLeft boolean.
		 */
		private function SetSpeed():void
		{
			if (bIsMovingLeft) 
			{
				this.velocity.x = -nSpeed;
			}
			else
			{
				this.velocity.x = nSpeed;
			}
		}
				
		/**
		 * 
		 */
		public override function update():void
		{
			// Handle States
			if (this.bWalkingState )
			{
				SetSpeed();
				nMoving_TimeElapsed += FlxG.elapsed;
			
				// If enough time has passed, switch the direction to move in
				if (nMoving_TimeElapsed >= nMaxMovingDuration)
				{
					nMoving_TimeElapsed = 0;
					this.bIsMovingLeft = !this.bIsMovingLeft;
					this.SetSpeed();
				}
			}
			else if (this.bFadeState)
			{
				this.velocity.x = 0;
				this.velocity.y = 0;
				this.acceleration.x = 0;
				this.acceleration.y = 0;
				//nFading_TimeElapsed += FlxG.elapsed;
				this.alpha -= nFading_RateOfFade;
				if (this.alpha <= 0)
				{
					// TO DO : Create a new tile and add it to the FlxMirrorTerrain group. 					
					var newGrassTile:GrassTile = new GrassTile(this.x + tileOffset.x , this.y + tileOffset.y);					
					FlxG.state.add(newGrassTile);
					
					this.kill();
				}
			}
			
			
			
			// Flixel Update
			super.update();
			
			// Handle State Transitions			
			if (this.health <= 0 && this.bWalkingState)
			{
				this.solid = false;
				this.bFadeState = true;// ();// destroy();
				this.bWalkingState  = false;
				return;
			}
			
		}
		
		
	}

}