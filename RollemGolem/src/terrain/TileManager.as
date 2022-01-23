package terrain
{
	import de.polygonal.ds.Array2;
	import flash.display.GraphicsSolidFill;
	import org.flixel.*;	
	import states.state_game;
	import terrain.GrassTile;
	/**
	 * ...
	 * @author Muffinsparticus
	 * BURAK FTW
	 */
	public class TileManager 
	{
		/**
		 * The tiles that the player interacts with
		 */
		public var TileArray:Array2 = new Array2(200,9);
		/**
		 * The reflection of the level that will become the TileArray once the player reaches the end of the stage
		 */
		public var MirrorArray:Array2 = new Array2(200,9);
		
		public function get Origin_TileArray():FlxPoint { return _origin_TileArray; }
		public function get Origin_MirrorArray():FlxPoint { return _origin_MirrorArray; }
		
		public function set Origin_TileArray(value:FlxPoint):void { _origin_TileArray = value; _origin_TileChanged = true; }
		public function set Origin_MirrorArray(value:FlxPoint ):void { _origin_MirrorArray = value; _origin_MirrorChanged = true; }
		
		private var _origin_TileArray:FlxPoint;
		private var _origin_MirrorArray:FlxPoint;
		private var _origin_TileChanged:Boolean = false;
		private var _origin_MirrorChanged:Boolean = false;
		
		public const nTileWidth:Number = 32;
		public const nTileHeight:Number = 32;
		
		/**
		 * The difference in the y_origin of the TileArray and the Mirror array. For now the MirrorArray is ALWAYS ABOVE THE TileArray.
		 */
		public const nYDistanceBetweenArrays:Number = -300;
		
		/**
		 * A Flixel group containing the tiles that the player cna interact with. These are the tiles in TileArray.
		 */
		public var activeGroup:FlxGroup = new FlxGroup();		
		/**
		 * The tiles that have been added to the mirror array. Just in case we need to collisions or updates on them.
		 */		
		public var mirrorGroup:FlxGroup = new FlxGroup();
		
		
		private var _blockTypeArray:Array = [null, MovableTile, GrassTile, SolidTile, GoalTile, VineTile];

		
		/**
		 * 
		 * @param	x X_Origin of all tiles
		 * @param	y Y_Origin of the Tile arrays
		 */
		public function TileManager(x:Number, y:Number) 
		{
			// Set up the origins of both arrays
			_origin_TileArray = new FlxPoint(x,y);			
			_origin_MirrorArray = new FlxPoint(x, y + nYDistanceBetweenArrays);
		}
		
		public function Update():void
		{
			var i:int;
			var tile:BaseTile;
			if (_origin_TileChanged) {
				for (i = 0; i < TileArray.size(); i++) {
					tile = BaseTile(TileArray.getAtIndex(i));
					tile.x = _origin_TileArray.x;
					tile.y = _origin_TileArray.y;
				}
			}
			if (_origin_MirrorChanged) {
				for (i = 0; i < MirrorArray.size(); i++) {
					tile = BaseTile(TileArray.getAtIndex(i));
					tile.x = _origin_MirrorArray.x;
					tile.y = _origin_MirrorArray.y;
				}
			}
		}
		
		/**
		 * Reads a CSV string (separate rows by newlines, '\n') and uses it to populate the TileArray
		 * @param	levelCSV CSV as a String
		 */
		public function LoadLevel(levelCSV:String, bUseMirror:Boolean = false):void
		{
			var tileType:Array2 = new Array2();
			var i:int = 0;
			var rows:Array = levelCSV.split("\n");
			tileType.setH(rows.length);
			tileType.setW(rows[0].split(",").length);
			for each (var row:String in rows) {
				for each (var val:String in row.split(",")) {
					tileType.setAtIndex(i, parseInt(val));
					++i;
				}
			}
			
			var block:BaseTile; TileArray.resize(tileType.getW(), tileType.getH());
			var point:FlxPoint;
			var blockClass:Class;
			var j:int = 0;
			var traceout:String;
			for (i = 0; i < tileType.getW(); i++) {
				traceout = "";
				for (j = 0; j < tileType.getH(); j++) {
					blockClass = Class(_blockTypeArray[int(tileType.get(i, j))]);
					traceout = traceout + String.fromCharCode(tileType.get(i, j)) + ",";
					if (blockClass) {
						CreateTile(i, j, blockClass, bUseMirror);
						//point = ConvertArrayPosToPoint(i, j);
						//block = new blockClass(point.x, point.y);
						//TileArray.set(i, j, block);
						//FlxG.state.add(block);
					} else {
						if (bUseMirror)
						{
							MirrorArray.set(i, j, null);
						}
						else
							TileArray.set(i, j, null);
							
					}
				}
				//trace(traceout + "\n");
			}
			//trace("TileArray: " + TileArray.toString());
		}
		
		
		/**
		 * Use this function remove a tile (if it exists) from the array
		 * 
		 * @param	x			Array position in the x axis
		 * @param	y			Array position in the y axis
		 * @param	bUseMirror	(True = add the tile to mirror array, False = add the tile to Tile array)
		 */
		public function RemoveTile(x:Number, y:Number, bUseMirror:Boolean = false):void
		{	
			// Decide which array to use
			var targetArray:Array2;
			var oldTile:Object;
			if (bUseMirror)
			{

				oldTile = MirrorArray.get(x, y);			
				MirrorArray.set(x, y, null);
				
				if (oldTile != null)
				{
					mirrorGroup.remove(oldTile as FlxObject);				
					FlxG.state.remove(oldTile as FlxObject);
					
				}
			}
			else
			{
				oldTile = TileArray.get(x, y);
				TileArray.set(x, y, null);							
				
				if (oldTile != null)
				{
					activeGroup.remove(oldTile as FlxObject);
					FlxG.state.remove(oldTile as FlxObject);
				}
			}					
		}
		
		/**
		 * Use this function to remove all of the tiles in the current stage
		 */
		public function Clear():void
		{
			for (var i:Number = 0; i < TileArray.getW(); ++i)
			{
				for ( var j:Number = 0; j < TileArray.getW(); ++j)
				{
					this.RemoveTile(i, j);
					this.RemoveTile(i, j, true);
				}
			}

		}
		
		/**
		 * 
		 * @param	x			Array position in the x axis
		 * @param	y			Array position in the y axis
		 * @param   nType		The typeID of the terrain to create
		 * @param	bUseMirror	(True = add the tile to mirror array, False = add the tile to Tile array)
		 */
		public function CreateTile(x:Number, y:Number, tileClass:Class, bUseMirror:Boolean = false):void
		{
			// Decide which array to use
			var targetArray:Array2;
			if (bUseMirror)
			{
				targetArray = MirrorArray;
			}
			else
			{
				targetArray = TileArray;
			}
			
			
			//var object:BaseTile = new (_blockTypeArray[nType](realworldPoint.x, realworldPoint.y));// (realworldPoint.x, realworldPoint.y);
			
			
			// TO DO CONVERT THE ARRAY_X AND ARRAY_Y INTO REAL_WORD VALUES
			var realworldPoint:FlxPoint = ConvertArrayPosToPoint(x, y, bUseMirror);

			if (realworldPoint != null)
			{
				//FlxG.log("New tile: (x:" + realworldPoint.x + ", y:" + realworldPoint.y +")");
			}
			else
			{
				FlxG.log("ERROR realworldPoint is null (tileManager.as line 90!!!)");
				return;
			}
			// Create the new Tile
			
			var newTile:BaseTile  = new tileClass(realworldPoint.x, realworldPoint.y);
			
			
			// Store the array position
			newTile.nArrayX = x;
			newTile.nArrayY = y;
			if (bUseMirror)			
			{
				MirrorArray.set(x, y, newTile);
			}
			else
			{
				TileArray.set(x, y, newTile);
			}
			//targetArray.set(x, y, newTile);
			
			(FlxG.state as state_game).add(newTile); 											
		
			// Make sure we add the new tile to a flixel group so that we can call collision methods on it
			if (bUseMirror)			
			{
				mirrorGroup.add(newTile);				
				MirrorArray = targetArray;
			}
			else 
			{
				activeGroup.add(newTile);
				TileArray = targetArray;
			}
			
			
			// Grass tile
			/*if (nType == 1)
			{
				var newTile:GrassTile = new GrassTile(realworldPoint.x, realworldPoint.y);
				targetArray.set(x, y, newTile);			
				FlxG.state.add(newTile); 											
			}
			// Movable Tile
			else if (nType == 2)
			{
				var newMovableTile = new MovableTile(realworldPoint.x, realworldPoint.y);
				targetArray.set(x, y, newMovableTile)
				FlxG.state.add(newMovableTile); 											
				
			}*/
			
		}
		
		//public function
		
		/**
		 *  
		 * @param	x			Realworld 'x-pos' in flixel
		 * @param	y			Realworld 'y-pos' in flixel
		 * @param	bUseMirror	(True = add the tile to mirror array, False = add the tile to Tile array)
		 * @return	The array pos of that corresponds to the realworld position
		 */
		public function ConvertPointToArrayPos(x:Number, y:Number, bUseMirror:Boolean = false): FlxPoint
		{
			var targetArray:Array2;
			// Subtract the origin of the target array to get the x-y position of the tile
			if (bUseMirror)
			{
				x -= _origin_MirrorArray .x;
				y -= _origin_MirrorArray .y;
				targetArray = MirrorArray;
			}
			else
			{
				x -= _origin_TileArray.x;
				y -= _origin_TileArray.y;
				targetArray = TileArray;
			}
			
			
			// divide by tile width to and floor the value to get the x/y position
			 x /= nTileWidth;			 
			 y /= nTileHeight;
			 
			 x = Math.floor(x);
			 y = Math.floor(y);
			 						
			 //if (targetArray.inRange(x, y))
			 //{
				return new FlxPoint(x, y); 
			 //}
			 //else
			 //{
				 return null;
			 //}			 			 
		}
		
		/**
		 * 
		 * @param	x			Array 'x-index' of the tile
		 * @param	y			Array 'y-index' of the tile
		 * @param	bUseMirror	(True = add the tile to mirror array, False = add the tile to Tile array)
		 * @return  The realword positon  that corresponds to the array pos
		 */
		public function ConvertArrayPosToPoint(x:Number, y:Number, bUseMirror:Boolean = false):FlxPoint
		{
			x *= nTileWidth;
			y *= nTileHeight;
			
			if (bUseMirror)
			{
				x += _origin_MirrorArray .x;
				y += _origin_MirrorArray .y
			}
			else
			{
				x += _origin_TileArray.x;
				y += _origin_TileArray.y;				
			}
			
			return new FlxPoint(x, y);
		}
		
		/**
		 * Helper function to find get a tile's neighbors 
		 * 
		 * @param	x			Realworld 'x-pos' in flixel
		 * @param	y			Realworld 'y-pos' in flixel
		 * @param	nDirection 	The direction enum to look in ex: (UP,DOWN,RIGHT,LEFT)
		 * @param	bUseMirror	(True = add the tile to mirror array, False = add the tile to Tile array)
		 * @return				The BaseTile in the arrayCell, or null if out of bounds or nothing is found.
		 */
		public function GetNeighbor(x:Number, y:Number, nDirection:Number, bUseMirror:Boolean = false):Object
		{
			// Get the Array we need to use
			var targetArray:Array2;			
			if (bUseMirror)
			{
				targetArray = MirrorArray;				
			}
			else
			{
				targetArray = TileArray;				
			}
			//FlxG.log("Find @: (x: " + x + ", y:" + y + ") in range: " + targetArray.inRange(x, y));

			
			
			// adjust array position in the direction we're looking for
			if (nDirection == FlxObject.UP)
			{
				--y;
			}
			else if (nDirection == FlxObject.DOWN)
			{
				++y;
			}
			else if (nDirection == FlxObject.LEFT)
			{
				--x;
			}
			else if (nDirection == FlxObject.RIGHT)
			{
				++x;
			}
			
			//FlxG.log("Find @: (x: " + x + ", y:" + y + ") in range: " + targetArray.inRange(x, y));
			
			FlxG.log("Find @: (x: " + x + ", y:" + y + ") in range: " + targetArray.get(x, y));
//			var thing: = targetArray.get(x, y);
			

			if (bUseMirror)
			{
				return  MirrorArray.get(x, y);			
			}
			else
			{
				return TileArray.get(x,y);				
			}

			//if (targetArray.inRange(x, y))
			//{
//					return targetArray.get(x, y);						
			//}
			//else
			//{
			//	return null;
			//}			
		}

		// Moves the tileArray into the Mirror array. Used when the player wants to do a soft reset
		public function SwapMirrorwithTiles():void		
		{
			var state:state_game = (FlxG.state as state_game);

			// Loop through the mirror array and remove all of the old tiles
			var oldTile:BaseTile;
			for (var i:Number = 0; i < MirrorArray.getW(); ++i)
			{
				for ( var j:Number = 0; j < MirrorArray.getW(); ++j)
				{
					oldTile = (MirrorArray.get(i, j) as BaseTile);					
					if (oldTile != null)
					{
						//oldTile.iterate();
						mirrorGroup.remove(oldTile);
						state.remove(oldTile);
					}
				
				}
			}

			mirrorGroup.clear();
			MirrorArray.clear();
								
			// make sure all active tiles can reset
			
			state.bResetActiveGroup = true;
			//activeGroup.callAll("ResetForIteration");
			//mirrorGroup.callAll("ResetForIteration");

			// swap the tiles and add them to the list
			var newTile:BaseTile;
			var mirrorTile:BaseTile;
			var newPoint:FlxPoint;
			for (var i:Number = 0; i < MirrorArray.getW(); ++i)
			{
				for ( var j:Number = 0; j < MirrorArray.getW(); ++j)
				{
					mirrorTile = (TileArray.get(i, j) as BaseTile);					
					if (mirrorTile != null)
					{			
						newPoint = ConvertArrayPosToPoint(i, j, true);
						if (mirrorTile as GrassTile)
						{
							newTile = new GrassTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as MovableTile)
						{
							newTile = new MovableTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as GoalTile)
						{
							newTile = new GoalTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as SolidTile)
						{
							newTile = new SolidTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as VineTile)
						{
							newTile = new VineTile(newPoint.x, newPoint.y);
						}
						newTile.solid = true;
						//newTile.nArrayX = i;
						//newTile.nArrayY = j;
						//newPoint = ConvertArrayPosToPoint(i, j, false);
						//newTile.x = newPoint.x;
						//newTile.y = newPoint.y;
					
						//activeGroup.add(newTile);
						//state.add(newTile);
						MirrorArray.set(i, j, newTile);
						mirrorGroup.add(newTile);
						state.add(newTile);
					}
				}
			}
			
		}
		
		public function SwapTileswithMirror():void
		{
			// remove all active tiles from memory
			var state:state_game = (FlxG.state as state_game);
		/*	for each(var a:BaseTile in activeGroup.members) {
				state.remove(a);
			}
			activeGroup.clear();
*/			
			//TileArray = new Array2(200, 200);

			var oldTile:BaseTile;
			for (var i:Number = 0; i < TileArray.getW(); ++i)
			{
				for ( var j:Number = 0; j < TileArray.getW(); ++j)
				{
					oldTile = (TileArray.get(i, j) as BaseTile);					
					if (oldTile != null)
					{
						oldTile.iterate();
						activeGroup.remove(oldTile);
						state.remove(oldTile);
					}
				
				}
			}
			
			activeGroup.clear();
			TileArray.clear();
			
			// swap the tiles and add them to the list
			var newTile:BaseTile;
			var mirrorTile:BaseTile;
			//var oldTile:BaseTile;
			var newPoint:FlxPoint;
			for (var i:Number = 0; i < TileArray.getW(); ++i)
			{
				for ( var j:Number = 0; j < TileArray.getW(); ++j)
				{
					// Remove old tile from memory
					/*oldTile = (TileArray.get(i, j) as BaseTile);					
					if (oldTile != null)
					{
						oldTile.iterate();
						activeGroup.remove(oldTile);
						state.remove(oldTile);
					}*/
					
					mirrorTile = (MirrorArray.get(i, j) as BaseTile);					
					if (mirrorTile != null)
					{
						newPoint = ConvertArrayPosToPoint(i, j, false);
						if (mirrorTile as GrassTile)
						{
							newTile = new GrassTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as MovableTile)
						{
							newTile = new MovableTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as GoalTile)
						{
							newTile = new GoalTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as SolidTile)
						{
							newTile = new SolidTile(newPoint.x, newPoint.y);
						}
						else if (mirrorTile as VineTile)
						{
							newTile = new VineTile(newPoint.x, newPoint.y);
						}
						newTile.solid = true;
						newTile.nArrayX = i;
						newTile.nArrayY = j;
						//newPoint = ConvertArrayPosToPoint(i, j, false);
						//newTile.x = newPoint.x;
						//newTile.y = newPoint.y;
					
						//activeGroup.add(newTile);
						//state.add(newTile);
						TileArray.set(i, j, newTile);
						activeGroup.add(newTile);
						state.add(newTile);
					}
				}
			}
		}
	}

}