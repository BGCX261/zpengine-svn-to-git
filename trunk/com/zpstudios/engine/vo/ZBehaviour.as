package com.zpstudios.engine.vo {
	import com.zpstudios.engine.sprites.ZSprite;

	public class ZBehaviour {
		public static const IDLE:String 	= "idle";
		public static const FOLLOW:String 	= "follow";
		public static const FLEE:String 	= "flee";
		
		
		public var type:String;
		public var actorSprite:ZSprite;
		public var checkFreq:int;
		
		public function ZBehaviour(type:String, checkFreq:int = 5) {
			this.type = type;
			this.checkFreq = checkFreq;
		}
	}
}