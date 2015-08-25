package com.zpstudios.engine.managers {
	import com.carlcalderon.arthropod.Debug;
	import com.zpstudios.engine.ZConstants;
	import com.zpstudios.engine.sprites.ZSprite;
	import com.zpstudios.engine.vo.ZGrid;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class ZSpriteManager extends ZManager {
		
		//Status 
		private var _paused:Boolean;
		public var size:int;
		private var _needsSorting:Boolean = false;
		
		//Stuffs
		private var _timer:Timer;
		private var _fps:int;
		
		public function ZSpriteManager(fps:int = 20, sprites:Vector.<ZSprite>=null, gridManager:ZGridManager = null) {
			super(gridManager, sprites);
			
			_fps = fps;
			_timer = new Timer(_fps);
			_paused = true;
			size = _sprites.length;
		}
		
		public function isPaused():Boolean {
			return _paused;	
		}
		
		public function start():void {
			if (_paused){
				_paused = false;
				_timer.addEventListener(TimerEvent.TIMER, tick);
				_timer.start();
			}
		}
		
		public function pause():void {
			if (!_paused){
				_paused = true;
				_timer.removeEventListener(TimerEvent.TIMER, tick);
				_timer.reset();
			}
		}
		
		public function tick(event:TimerEvent):void {
			for (var i:int = 0; i < _sprites.length;i++){
				_sprites[i].tick(_timer.currentCount);
			}
			if (_needsSorting) {
				_sprites.sort(sortSprites);
				_needsSorting = false;
			}
		}
		
		override public function addSprite(sprite:ZSprite):void {
			
			if (sprite) {
				_sprites.push(sprite);
				_sprites.sort(sortSprites);
				sprite.manager = this;
				size = _sprites.length;
				//updateDepths();
				_gridManager.setSpriteSpan(sprite);
				sprite.addEventListener(ZConstants.DEPTH_EVENT, spriteDepthChange);
			}else {
				Debug.error("Sprite is null");
			}
			
		}
		
		override public function removeSprite(sprite:ZSprite) : void {
			
			for (var i:int = 0 ; i < _sprites.length; i++) {
				if (_sprites[i] == sprite) {
					sprite.removeEventListener(ZConstants.DEPTH_EVENT, spriteDepthChange);
					_sprites.splice(i,1);
					sprite.manager = null;
					return;
				}
			}
			
		}
		
		public function updateDepths():void {
			if (_sprites.length > 0 ) {
				//var spriteParent:DisplayObjectContainer = _sprites[0].parent;
				for (var i:int = 0; i < _sprites.length;i++){
					//spriteParent.setChildIndex(_sprites[i], i);
					_sprites[i].depth = i;
				}
			}
		}
		
		protected function sortSprites(a:ZSprite, b:ZSprite):Number {
			var spriteParent:DisplayObjectContainer = a.parent;
			
			var aIndex:int = spriteParent.getChildIndex(a);
			var bIndex:int = spriteParent.getChildIndex(b);
			
			if (a.y+a.height == b.y+b.height){
				return 0;
			}else if (a.y+a.height > b.y+b.height){
				if (aIndex < bIndex){
					spriteParent.swapChildrenAt(aIndex, bIndex);
				}
				return 1;
			}else {
				if (aIndex > bIndex) {
					spriteParent.swapChildrenAt(bIndex, aIndex);
				}
				return -1;
			}
		}
		
		private function spriteDepthChange(event:Event):void {
			_needsSorting = true;
		}
	}
}