package effects
{
	import org.flixel.FlxParticle;
	
	/**
	 * ...
	 * @author Rahil Patel
	 */
	public class DustParticle extends FlxParticle
	{
		[Embed(source="../images/dust_001.png")]
		private var dustplay:Class;
		protected var createTime:int;
		
		public function Dust()
		{
			super();
			loadGraphic(dustplay, true, false, 20, 20);
			addAnimation("play", [0, 1, 2], 7, true);
			exists = false;
		}
			
		override public function onEmit():void
		{
			super.onEmit();
			play("play");
		}
			
		override public function update():void
		{
			super.update();
			if (createTime < 0.5 && alpha > 0)
			{
				alpha -= 0.1;
				createTime += FlxG.elapsed;
			}
		}
	}

}