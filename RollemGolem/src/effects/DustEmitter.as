package effects
{
	import org.flixel.FlxEmitter;
	
	/**
	 * ...
	 * @author Rahil Patel
	 */
	public class DustEmitter extends FlxEmitter 
	{
		
		public function DustEmitter() 
		{
			this._maxSize = 20;
			this.gravity = 350;
			this.setRotation(0, 0);
			this.setXSpeed(-50, 50);
			this.setYSpeed(-100, 100);
		}
	}

}