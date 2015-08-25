package com.zpstudios.engine.vo {
	import com.carlcalderon.arthropod.Debug;
	import com.zpstudios.engine.ZConstants;
	
	import de.polygonal.ds.Array2;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class ZGrid {
		private var _grid:Array2;
		public var gridSprite:Sprite;
		
		public function ZGrid(width:int, height:int) {
			_grid = new Array2(width, height);
			gridSprite = new Sprite();
			var tempCell:ZCell;
			for (var i:int = 0; i < _grid.width;i++) {
				for (var j:int = 0; j < _grid.height; j++) {
					tempCell = new ZCell(i,j);
					_grid.set(i,j, tempCell);
					gridSprite.addChild(tempCell.sprite);
				}
			}
		}
		
		public function setPassable(x:int, y:int, passable:Boolean = true):void {
			var cell:ZCell = _grid.get(x,y);
			cell.passable = passable;
			cell.p;
		}
		
		public function setKnown(x:int, y:int, known:Boolean = true):void {
			var cell:ZCell = _grid.get(x,y);
			cell.known = known;
			cell.p;
		}
		
		public function setVisible(x:int, y:int, visible:Boolean = true):void {
			var cell:ZCell = _grid.get(x,y);
			cell.visible = visible;
			cell.p;
		}
		
		public function setOccupied(x:int, y:int, occupiedFlag:uint = 0, occupied:Boolean = false):void {
			var cell:ZCell = ZCell(_grid.get(x,y));
			
			if (occupied) {
				cell.occupied |= occupiedFlag; 	
			}else {
				cell.occupied &= ~occupiedFlag;	
			}
			
			cell.occupied = cell.occupied & occupiedFlag;
			cell.p;
			
			Debug.log("Cell ("+cell.x+","+cell.y+") Occupied:"+cell.occupied.toString(2));
			
		}
		
		public function getCell(x:int, y:int):ZCell {
			if (isValidCell(x, y)){
				return _grid.get(x, y) as ZCell;
			}else {
				return null; //cell doesn't exist
			}
		}
		
		public function isValidCell(x:int, y:int):Boolean {
			return _grid.width > x && x >= 0 && _grid.height > y && y >= 0;
		}
		
		
		
		
	}
}