package com.zpstudios.engine.events {
	import flash.events.Event;
	
	public class ZEvent extends Event {
		public static const DESTINATION_REACHED:String 	= "destinationReached";
		public static const WAYPOINT_REACHED:String 	= "waypointReached";
		public static const SPRITE_REACHED:String		= "spriteReached";
		
		
		public function ZEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}