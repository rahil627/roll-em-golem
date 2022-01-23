package  terrain
{
	import terrain.BaseTile;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SolidTile extends BaseTile 
	{
		[Embed(source = '../../assets/neutralblock.png')]
		private static var nuetralBlockFile:Class;
		
		public function SolidTile(x:Number, y:Number) 
		{
			super(x, y);
			this.loadGraphic(nuetralBlockFile);
		}
	}
}