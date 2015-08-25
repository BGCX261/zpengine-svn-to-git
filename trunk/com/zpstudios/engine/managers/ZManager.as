package com.zpstudios.engine.managers
{
	import com.carlcalderon.arthropod.Debug;
	import com.zpstudios.engine.sprites.ZSprite;
	
	import flash.display.BitmapData;
	
	public class ZManager {
		
		protected var _sprites:Vector.<ZSprite>;
		protected var _gridManager:ZGridManager;
		
		public function ZManager(gridManager:ZGridManager = null, sprites:Vector.<ZSprite> = null ){
			_gridManager = gridManager;
			if (sprites) {
				_sprites = sprites;
				for (var i:int = 0; i < sprites.length;i++) {
					sprites[i].manager = this;
					if (_gridManager) {
						_gridManager.setSpriteSpan(sprites[i]);
					}
				}	
			}else {
				_sprites = new Vector.<ZSprite>;
			}
		}
		
		public function addSprites(sprites:Vector.<ZSprite>):void {
			for (var i:int = 0; i < sprites.length;i++) {
				addSprite(sprites[i]);
				sprites[i].manager = this;
				_gridManager.setSpriteSpan(sprites[i]);
			}	
		}
		
		public function removeSprites(sprites:Vector.<ZSprite>):void {
			for (var i:int = 0; i < sprites.length;i++) {
				removeSprite(sprites[i]);
				sprites[i].manager = null;
				
			}	
		}
		
		public function addSprite(sprite:ZSprite):void {
			_sprites.push(sprite);
			sprite.manager = this;
			_gridManager.setSpriteSpan(sprite);
		}
		
		public function removeSprite(sprite:ZSprite):void {
			for (var i:int = 0 ; i < _sprites.length; i++) {
				if (_sprites[i] == sprite) {
					_sprites.splice(i,1);
					sprite.manager = null;
					return;
				}
			}
			
			Debug.error("Sprite not found in Manager:"+this);
		}
		
		
		
		public static function processTile(tileData:BitmapData):BitmapData {
			var bg:uint = tileData.getPixel32(0,0);
			for (var i:int = 0; i < tileData.width;i++){
				for (var j:int = 0; j < tileData.height;j++){
					if (tileData.getPixel32(i,j) == bg) {
						tileData.setPixel32(i,j, 0);
					}
				}
			}
			return tileData;
		}
		
		
		public function get gridManager():ZGridManager {
			return _gridManager;
		}
		
		public function set gridManager(gridManager:ZGridManager):void {
			gridManager = _gridManager;
		}
								
	}
}