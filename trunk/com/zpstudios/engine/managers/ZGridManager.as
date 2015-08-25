package com.zpstudios.engine.managers {
	import com.carlcalderon.arthropod.Debug;
	import com.zpstudios.engine.ZConstants;
	import com.zpstudios.engine.sprites.ZSprite;
	import com.zpstudios.engine.vo.ZCell;
	import com.zpstudios.engine.vo.ZGrid;
	
	import de.polygonal.ds.Array2;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class ZGridManager{
		//Constants
		private const MASK_R:int = 250;
		
		//VO
		public var grid			:ZGrid;
		//Variables
		private var _masked		:Boolean;
		private var _fow		:Boolean;
		
		private var _width		:int;
		private var _height		:int;
		private var _maskR		:int;
		//Components
		
		private var _gridContainer	:Sprite;
		private var _fowContainer	:Sprite;
		
		private var _gridGFX		:Shape;
		private var _gridMask		:Shape;
		
		private var _hardFOW		:Shape;
		private var _softFOW		:Shape;
		
		public function ZGridManager(width:int, height:int, gridContainer:Sprite, fowContainer:Sprite = null) {
			_width 		= width;
			_height 	= height;
			
			_gridContainer 	= gridContainer;
			_fowContainer 	= fowContainer;
			_masked 	= false;
			this.masked = false;
			_fow		= false;
			grid 		= new ZGrid(width, height);
			
			_initGrid();
			_initFOW();
		}
		
		private function _initGrid():void {
			//Display Objects stack setup.
			_gridGFX 	= new Shape();
			_gridMask 		= new Shape();
			
			_gridMask.x		= 50;
			_gridMask.y		= 50;
			_maskR	 	= MASK_R;
			
			
			grid.gridSprite.addChild(_gridGFX);
			_gridContainer.addChild(grid.gridSprite);
			_gridContainer.addChild(_gridMask);
			
			
			//Paint Grid
			var gfx:Graphics = _gridGFX.graphics;
			gfx.lineStyle(1,0x000000,.5);
			
				//Vertical Lines
			for (var tempX:int = 0; tempX < _width*ZConstants.UNIT_SIZE; tempX+= ZConstants.UNIT_SIZE) {
					gfx.moveTo(tempX, 0);
					gfx.lineTo(tempX, _width*ZConstants.UNIT_SIZE);
			}
				//Horizontal Lines
			for (var tempY:int = 0; tempY < _height*ZConstants.UNIT_SIZE; tempY+= ZConstants.UNIT_SIZE) {
				gfx.moveTo(0, tempY);
				gfx.lineTo(_height*ZConstants.UNIT_SIZE, tempY);
			}
			
			gfx.endFill();
			
			//Paint Mask
			var matr:Matrix = new Matrix();
			matr.createGradientBox(MASK_R, MASK_R, 0, MASK_R*-.5, MASK_R*-.5);
			
			gfx = _gridMask.graphics;
			gfx.beginGradientFill(GradientType.RADIAL,[0xFF0000, 0x0000FF],[1, 0], [0x00, 0xFF],matr,SpreadMethod.PAD);
			
			gfx.drawCircle(0, 0, MASK_R/2);
			_gridMask.cacheAsBitmap = true;
			grid.gridSprite.cacheAsBitmap = true;
			
			
		}
		
		private function _initFOW():void {
			
		}
		
		public function moveMask(x:int, y:int):void {
			_gridMask.x = x;
			_gridMask.y = y;
		}
		
		public function get masked():Boolean {
			return _masked;
		}
		
		public function set masked(val:Boolean):void {
			if (val != _masked) {
				_masked = val;
				if (_masked) {
					
					grid.gridSprite.mask = _gridMask;
					_gridMask.visible = true;
				}else {
					
					grid.gridSprite.mask = null;
					_gridMask.visible = false;
				}
			}
		}
	
		
		public function setSpriteSpan(sprite:ZSprite):void {
			var tspan:Boolean;
			for (var i:int = 0; i < sprite.spanGrid.width; i++) {
				for (var j:int = 0; j < sprite.spanGrid.height;j++) {
					tspan = sprite.spanGrid.get(i,j)
					if (tspan) {
						grid.setOccupied(i+sprite.originPoint.x,j+sprite.originPoint.y,sprite.occupiedFlag, true);
					}
					
				}
			}
		}
		
		public function moveSpritePosition(sprite:ZSprite):void {
			var i:int;
			var j:int;
			var tspan:Boolean;
			
			for (i = 0; i < sprite.spanGrid.width; i++) {
				for (j = 0; j < sprite.spanGrid.height;j++) {
					tspan = sprite.spanGrid.get(i,j)
					if (tspan) {
						grid.setOccupied(i+sprite.originPoint.x,j+sprite.originPoint.y,sprite.occupiedFlag, false);
					}
				}
			}
			
			for (i = 0; i < sprite.spanGrid.width; i++) {
				for (j = 0; j < sprite.spanGrid.height;j++) {
					tspan = sprite.spanGrid.get(i,j);
					if (tspan) {
						grid.setOccupied(i+sprite.destinationPoint.x,j+sprite.destinationPoint.y,sprite.occupiedFlag, true);
					}
				}
			}
		}
		
		public static function shortestPath(grid:ZGrid, start:Point, end:Point, spriteSpan:Array2 = null, occupiedFlag:int = 0):Vector.<Point> {
			Debug.log("STARTING SHORTEST PATH\n"+start.toString()+" -> "+end.toString());
			
			//-----SETUP PHASE----
			var openList:Vector.<ZCell> = new Vector.<ZCell>();
			var closedList:Vector.<ZCell> = new Vector.<ZCell>();
			
			var endCell:ZCell = grid.getCell(end.x, end.y);
			var startCell:ZCell = grid.getCell(start.x, start.y);
			
			if (!endCell || !startCell) {
				return null;
				//check that cells exist
			}
			
			startCell.parent = null;
			startCell.g = 0;
			startCell.h = 0;
			var currentCell:ZCell = startCell;
			
			openList.push(startCell);//add starting point to open list
			while (openList.length > 0 && currentCell.g < 40) {//while there's still cells to check for shortest path and the dude isnt too far away (40 cells), keep on SEARCHIN'
				//Debug.log("Searching for path...");
				
				currentCell = openList.pop();
				
				//RIGHT
				var cellOffset:Vector.<Point> = new Vector.<Point>(); 
				var pivotCell:ZCell;
				
				
				cellOffset.push(new Point(1, 0));
				cellOffset.push(new Point(-1, 0));
				cellOffset.push(new Point(0, 1));
				cellOffset.push(new Point(0, -1));
				
				
				for (var i:int = 0; i < cellOffset.length;i++){
					pivotCell = grid.getCell(currentCell.x+cellOffset[i].x, currentCell.y+cellOffset[i].y);
					var possible:Boolean = true;
					var tempCell:ZCell;
					var absX:int;
					var absY:int;
					
					var isPassable:Boolean;
					var isNotOccupied:Boolean;
					var isOccupiedBySelf:Boolean;
					
					if (spriteSpan && pivotCell) {
						for (var j:int = 0; j < spriteSpan.width && possible;j++){
							for (var k:int = 0; k < spriteSpan.height && possible;k++){
								if (spriteSpan.get(j, k)){
									tempCell = grid.getCell(pivotCell.x+j, pivotCell.y+k);
									
									if (tempCell) {
										absX = (start.x-tempCell.x ^ (start.x-tempCell.x >> 31)) - (start.x-tempCell.x >> 31);
										absY = (start.y-tempCell.y ^ (start.y-tempCell.y >> 31)) - (start.y-tempCell.y >> 31);
										
										isPassable = tempCell.p ;
										isNotOccupied = !tempCell.isOccupiedBy(occupiedFlag);
										isOccupiedBySelf = (tempCell.isOccupiedBy(occupiedFlag) && absX+j  < spriteSpan.width && absY+k < spriteSpan.height && spriteSpan.get(absX+j, absY+k));
										//possible = (tempCell.p || !tempCell.isOccupiedBy(occupiedFlag) || (tempCell.isOccupiedBy(occupiedFlag) && absX+j  < spriteSpan.width && absY+k < spriteSpan.height && spriteSpan.get(absX+j, absY+k)));
										possible = isPassable || isNotOccupied || isOccupiedBySelf;
									}
								}
							}
						}
					}
					
					if (possible && pivotCell && closedList.indexOf(pivotCell) == -1) { //If the cell is not null, not on closed list, and it's passable.
						
						if (openList.indexOf(pivotCell) == -1) {//not in the open list, add it there, set current as parent and calculate parameters
							openList.push(pivotCell);
							pivotCell.parent = currentCell;
							pivotCell.g = pivotCell.parent.g+pivotCell.cost;
							pivotCell.h = Math.abs(endCell.x- pivotCell.x) + Math.abs(endCell.y - pivotCell.y);
							
						}else if (pivotCell.cost+currentCell.g < pivotCell.g) {
							pivotCell.parent = currentCell;
							pivotCell.g = pivotCell.cost+currentCell.g;
							pivotCell.h = Math.abs(endCell.x- pivotCell.x) + Math.abs(endCell.y - pivotCell.y);
						}
					}
				}
				
				if (currentCell != endCell) {
					closedList.push(currentCell);
					openList.sort(sortCells);
				}else {//FOUND!
					Debug.log("Path Found!");
					var shortestPath:Vector.<Point> = new Vector.<Point>();
					while (currentCell.parent != null) {
						shortestPath.push(currentCell.toPoint());
						Debug.log("-"+currentCell.toPoint(),Debug.GREEN);
						currentCell = currentCell.parent;
					}
					shortestPath.push(currentCell.toPoint());
					return shortestPath.reverse();
				}
			}
			Debug.log("No path to destination or too long");
			return null; //there's no path connecting those points
		}
		
		private static function sortCells(a:ZCell, b:ZCell):Number {
			if (a.f == b.f){
				return 0;
			}else if (a.f < b.f){
				return 1;
			}else {
				return -1;
			}
		}
	}
}