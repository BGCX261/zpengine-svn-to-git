package com.zpstudios.engine.vo {
	import com.zpstudios.engine.ZConstants;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;

	public class ZCell {
		public var x:int;
		public var y:int;
		public var passable:Boolean;
		public var known:Boolean;
		public var visible:Boolean;
		public var occupied:uint;
		
		//shortest path variables
		public var cost:int;
		public var g:int;
		public var h:int;
		public var parent:ZCell;
		
		public var sprite:Shape;
		
		public function ZCell(x:int = 0, y:int = 0, passable:Boolean = true, visible:Boolean = true, known:Boolean = true, occupied:uint = 0) {
			
			this.x = x;
			this.y = y;
			this.occupied = occupied;
			this.passable = passable;
			this.visible = visible;
			this.known = known;
			
			g = 0;
			h = 0;
			cost = 1;
			parent = null;
			
			//debug sprite
			sprite = new Shape();
			sprite.graphics.beginFill(0x00FF00, 0.5);
			sprite.graphics.drawRect(0,0,ZConstants.UNIT_SIZE,ZConstants.UNIT_SIZE);
			sprite.graphics.endFill();
			sprite.x = x*ZConstants.UNIT_SIZE;
			sprite.y = y*ZConstants.UNIT_SIZE;
		}
		
		public function get p():Boolean {// p = false means this cell should be ignored for shortest path calculations.
			var p:Boolean = passable && known && !(occupied > 0);
			
			sprite.graphics.clear();
			if (p) {
				sprite.graphics.beginFill(0x00FF00, 0.5);
			}else {
				sprite.graphics.beginFill(0xFF0000, 0.5);
			}
			
			sprite.graphics.drawRect(0,0,ZConstants.UNIT_SIZE,ZConstants.UNIT_SIZE);
			sprite.graphics.endFill();
			
			return p;
		}
		
		public function get f():int {
			return g+h;
		}
		
		public function isOccupiedBy(occupiedFlag:uint):Boolean{
			if (occupied > 0) {
				//trace("shitballs");	
				var poopies:int = 34;
			}
			return (occupied & occupiedFlag) > 0;
		}
		
		public function toPoint():Point {
			return new Point(x,y);
		}
	}
}