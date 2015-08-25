package com.zpstudios.engine
{
	public class ZConstants {
		public static const UNIT_SIZE				:int = 10;
		
		
		public static const UP:String 				= "up";
		public static const DOWN:String 			= "down";
		public static const LEFT:String 			= "left";
		public static const RIGHT:String 			= "right";
		public static const STOP:String				= "stop";
		
		public static const UP_ANIMATED:String 		= "upAnimated";
		public static const DOWN_ANIMATED:String 	= "downAnimated";
		public static const LEFT_ANIMATED:String 	= "leftAnimated";
		public static const RIGHT_ANIMATED:String 	= "rightAnimated";
		
		public static const DEPTH_EVENT:String		= "depthEvent";
		
		//occupying flags
		public static const UNOCCUPIED:uint 		= 0;
		public static const OCCUPIED_ZOMBIE:uint 	= 2;
		public static const OCCUPIED_HUMAN:uint		= 1;
		public static const OCCUPIED_ALL:uint 		= ~0;
	}
}