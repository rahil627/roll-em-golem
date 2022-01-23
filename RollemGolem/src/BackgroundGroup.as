package  
{
	import org.flixel.FlxG;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import states.state_game;
	
	/**
	 * ...
	 * @author Rahil Patel
	 */
	public class BackgroundGroup extends FlxGroup 
	{
		//private var backgroundColorTop:FlxSprite = new FlxSprite(0, 0);
		//private var backgroundColorBottom:FlxSprite = new FlxSprite(0, FlxG.height / 2);
		
		[Embed(source = '../assets/backgroundcolor.png')]
		private const backgroundColorFile:Class;
		private var backgroundColor:FlxSprite = new FlxSprite(0, 0, backgroundColorFile);
		
		[Embed(source='../assets/bricksandorbs.png')]
		private const bricksAndOrbsFile:Class;
		private var bricksAndOrbs:FlxSprite = new FlxSprite(0, 0, bricksAndOrbsFile);
		
		[Embed(source = '../assets/cloudstopx2.png')]
		private const cloudsTopFile:Class;
		private var cloudsTop:FlxSprite = new FlxSprite(0, 0, cloudsTopFile);
		
		[Embed(source = '../assets/cloudsbottomx2.png')]
		private const cloudsBottomFile:Class;
		private var cloudsBottom:FlxSprite = new FlxSprite(0, FlxG.height / 2, cloudsBottomFile);
		
		[Embed(source = '../assets/boros1.png')]
		private const emblemPiece1File:Class;
		private var emblemPiece1:FlxSprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2, emblemPiece1File);
		
		[Embed(source = '../assets/boros2.png')]
		private const emblemPiece2File:Class;
		private var emblemPiece2:FlxSprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2, emblemPiece2File);
		
		[Embed(source='../assets/boros3.png')]
		private const emblemPiece3File:Class;
		private var emblemPiece3:FlxSprite = new FlxSprite(FlxG.width / 2, FlxG.height / 2, emblemPiece3File);

		private var nNumOfBorosPieces:Number = 0;
		
		[Embed(source = '../assets/foregroundbar.png')]
		private const foregroundBarFile:Class;
		private var foregroundBar:FlxSprite;
		
		public function BackgroundGroup() 
		{
			//TODO: try to dim the background since it is very contrasting, dim the bottom one more? Cloud image doesn't line up!
			
			//FlxG.bgColor = 0x21B1DAFF; //color is different!
			
			/*
			backgroundColorTop.makeGraphic(FlxG.width, FlxG.height / 2, 0x21B1DAFF);
			this.add(backgroundColorTop);
			
			backgroundColorBottom.makeGraphic(FlxG.width, FlxG.height / 2, 0xDE4E25FF);
			this.add(backgroundColorBottom);
			*/
			
			this.add(backgroundColor);
			
			//cloudsTop.x -= cloudsTop.width / 2;
			cloudsTop.velocity.x = -10;
			this.add(cloudsTop);
			
			cloudsBottom.velocity.x = -10;
			//cloudsBottom.velocity.x = -10;
			//cloudsBottom.alpha = .75; //alpha is not the way to go, need to make it darker
			//cloudsBottom.scrollFactor = new FlxPoint(.5, 0);
			this.add(cloudsBottom);
			
			//bricksAndOrbs.alpha = .75;
			this.add(bricksAndOrbs);
			
			foregroundBar = new FlxSprite(FlxG.width / 2, FlxG.height / 2, foregroundBarFile);
			foregroundBar.y -= foregroundBar.height / 2;
			foregroundBar.x -= foregroundBar.width / 2;
			this.add(foregroundBar);
			
			emblemPiece1.x -= emblemPiece1.width / 2;
			emblemPiece1.y -= emblemPiece1.height / 2;
			emblemPiece1.scale = new FlxPoint(.5, .5);
			
			emblemPiece2.x -= emblemPiece2.width / 2;
			emblemPiece2.y -= emblemPiece2.height / 2;
			emblemPiece2.scale = new FlxPoint(.5, .5);
			
			emblemPiece3.x -= emblemPiece3.width / 2;
			emblemPiece3.y -= emblemPiece3.height / 2;
			emblemPiece3.scale = new FlxPoint(.5, .5);
		}
		
		override public function update():void
		{
			super.update();
			/*
			if (cloudsTop.x >= 0)
				cloudsTop.x = -cloudsTop.width / 2;
			*/
			if (cloudsTop.x < -cloudsTop.width / 2)
				cloudsTop.x = 0;
				
			if (cloudsBottom.x < -cloudsBottom.width / 2)
				cloudsBottom.x = 0;
		}
		
		public function addEmblemPiece():void
		{
			//increase through array of emblem pieces, use animation?
		
			++nNumOfBorosPieces;
			
			//TESTING!
			if (nNumOfBorosPieces == 1)
			{
				this.add(emblemPiece1);
			}
			else if (nNumOfBorosPieces == 2)
			{
				this.remove(emblemPiece1);
				this.add(emblemPiece2);
			}
			else if (nNumOfBorosPieces == 3)
			{
				this.remove(emblemPiece2);
				this.add(emblemPiece3);			
				
				var theState:FlxState = FlxG.state;

				if (theState as state_game)
				{
					(theState as state_game).StageCompleteEvent();
				}

			}
		}
		public function resetEmblemPieces():void		
		{
			if (nNumOfBorosPieces >= 3)
			{
				this.remove(emblemPiece3);
			}
			else if (nNumOfBorosPieces >= 2)
			{
				this.remove(emblemPiece2);
			}
			else if (nNumOfBorosPieces >= 1)
			{
				this.remove(emblemPiece1);			
			}
			nNumOfBorosPieces = 0;
		}
		
	}

}