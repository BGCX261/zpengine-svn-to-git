package com.zpstudios.engine.vo
{
	import flash.geom.Point;

	public class ZAnimation {
		
		public var name:String;
		public var tileCoords:Vector.<Point>;
		
		public function ZAnimation(name:String, tileCoords:Vector.<Point>) {
			
			this.name = name;
			this.tileCoords = tileCoords;
			
		}
	}
}