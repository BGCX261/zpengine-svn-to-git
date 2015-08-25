package com.zpstudios.engine.vo
{
	import flash.geom.Point;

	public class ZFacing {
		
		public var name:String;
		public var tileCoord:Point;
		
		public function ZFacing(name:String, tileCoord:Point) {
			this.name = name;
			this.tileCoord = tileCoord;
		}
	}
}