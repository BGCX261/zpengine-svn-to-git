package com.zpstudios.engine.factory {
	import com.zpstudios.engine.ZConstants;
	import com.zpstudios.engine.managers.ZManager;
	import com.zpstudios.engine.sprites.ZAnimatedSprite;
	import com.zpstudios.engine.sprites.ZSprite;
	import com.zpstudios.engine.vo.ZAnimation;
	import com.zpstudios.engine.vo.ZFacing;
	
	import de.polygonal.ds.Array2;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class ZFactory {
		
		[Embed (source="../assets/gfx/background/grass01.png")]
		private static var GrassTile1:Class;
		[Embed (source="../assets/gfx/background/grass02.png")]
		private static var GrassTile2:Class;
		[Embed (source="../assets/gfx/background/grass03.png")]
		private static var GrassTile3:Class;
		
		[Embed (source="../assets/gfx/characters/tilesheets/zombies/zombie01.png")]
		private static var ZombieTile:Class;
		[Embed (source="../assets/gfx/characters/tilesheets/humans/human02.png")]
		private static var HumanTile:Class;
		[Embed (source="../assets/gfx/objects/house01.png")]
		private static var HouseTile:Class;
		
		
		public static function buildMap(width:int, height:int):BitmapData {
		
			var _grass:Vector.<BitmapData> = new Vector.<BitmapData>;
			
			_grass.push( (new GrassTile1() as Bitmap).bitmapData);
			_grass.push( (new GrassTile2() as Bitmap).bitmapData);
			_grass.push( (new GrassTile3() as Bitmap).bitmapData);
			
			var WIDTH:int = width*ZConstants.UNIT_SIZE;
			var HEIGHT:int = height*ZConstants.UNIT_SIZE;
			var bg:BitmapData = new BitmapData(WIDTH, HEIGHT, false, 0xFF0000);
			
			for (var i:int = 0; i < WIDTH; i+=ZConstants.UNIT_SIZE*2) {
				for (var j:int = 0; j < HEIGHT; j+=ZConstants.UNIT_SIZE*2) {
					bg.copyPixels(_grass[int(Math.random()*3)], new Rectangle(0,0, ZConstants.UNIT_SIZE*2, ZConstants.UNIT_SIZE*2), new Point(i,j));
				}
			}
			
			return bg;
		}
		
		public static function buildZombie():ZAnimatedSprite {
			
			
			var sprite:ZAnimatedSprite 			= new ZAnimatedSprite(ZConstants.UNIT_SIZE, ZConstants.UNIT_SIZE*2, ZConstants.UNIT_SIZE*2*2);
			
			var downAnimCoords:Vector.<Point> 	= new Vector.<Point>(); 
			downAnimCoords.push(new Point(0,3));
			downAnimCoords.push(new Point(0,1));
			downAnimCoords.push(new Point(0,3));
			downAnimCoords.push(new Point(0,2));
			
			var upAnimCoords:Vector.<Point> = new Vector.<Point>();
			upAnimCoords.push(new Point(2,3));
			upAnimCoords.push(new Point(2,1));
			upAnimCoords.push(new Point(2,3));
			upAnimCoords.push(new Point(2,2));
			
			var leftAnimCoords:Vector.<Point> = new Vector.<Point>();
			leftAnimCoords.push(new Point(3,3));
			leftAnimCoords.push(new Point(3,1));
			leftAnimCoords.push(new Point(3,3));
			leftAnimCoords.push(new Point(3,2));
			
			var rightAnimCoords:Vector.<Point> = new Vector.<Point>();
			rightAnimCoords.push(new Point(1,3));
			rightAnimCoords.push(new Point(1,1));
			rightAnimCoords.push(new Point(1,3));
			rightAnimCoords.push(new Point(1,2));
			
			var occupiedGrid:Array2 = new Array2(2,4);
			for (var i:int = 0; i < occupiedGrid.width;i++) {
				for (var j:int = 0; j < occupiedGrid.height;j++) {
					occupiedGrid.set(i, j, false);
				}
			}
			occupiedGrid.set(0,3,true);
			occupiedGrid.set(1,3,true);
			sprite.spanGrid = occupiedGrid;
			sprite.occupiedFlag = ZConstants.OCCUPIED_ZOMBIE;
			
			sprite.setTile(ZManager.processTile((new ZombieTile() as Bitmap).bitmapData), 4, 3);
			
			sprite.addFacing(new ZFacing(ZConstants.UP, new Point(2,0)));
			sprite.addFacing(new ZFacing(ZConstants.DOWN, new Point(0,0)));
			sprite.addFacing(new ZFacing(ZConstants.LEFT, new Point(3,0)));
			sprite.addFacing(new ZFacing(ZConstants.RIGHT, new Point(1,0)));
			
			sprite.addAnimation(new ZAnimation(ZConstants.DOWN_ANIMATED,downAnimCoords));
			sprite.addAnimation(new ZAnimation(ZConstants.UP_ANIMATED,upAnimCoords));
			sprite.addAnimation(new ZAnimation(ZConstants.LEFT_ANIMATED,leftAnimCoords));
			sprite.addAnimation(new ZAnimation(ZConstants.RIGHT_ANIMATED,rightAnimCoords));
			
			sprite.changeFacing((ZConstants.DOWN));
			sprite.changeAnimation(ZConstants.DOWN_ANIMATED); 
			sprite.name = "Zombie";
			sprite.speed = 4;
			sprite.frequency = 15;
			
			return sprite;
		}
		
		public static function buildHouse():ZSprite {
			var houseSprite:ZSprite = new ZSprite(ZConstants.UNIT_SIZE,4*ZConstants.UNIT_SIZE*2,4*ZConstants.UNIT_SIZE*2);
			houseSprite.name = "House"
			var houseTile:BitmapData = (new HouseTile() as Bitmap).bitmapData;
			houseSprite.setTile(ZManager.processTile(houseTile),1,1);
			
			houseSprite.addFacing(new ZFacing(ZConstants.DOWN, new Point(0,0)));
			houseSprite.changeFacing(ZConstants.DOWN);
			houseSprite.setPosition(0,0);
			
			var occupiedGrid:Array2 = new Array2(8,8);
			for (var i:int = 0; i < occupiedGrid.width;i++) {
				for (var j:int = 0; j < occupiedGrid.height;j++) {
					occupiedGrid.set(i, j, j > 2);
				}
			}
					
			houseSprite.spanGrid = occupiedGrid;
			houseSprite.occupiedFlag = ZConstants.OCCUPIED_ALL;
			return houseSprite;
		}
		
		public static function buildDude():ZAnimatedSprite {
			var sprite:ZAnimatedSprite 			= new ZAnimatedSprite(ZConstants.UNIT_SIZE, ZConstants.UNIT_SIZE*2, ZConstants.UNIT_SIZE*2*2);
			
			var downAnimCoords:Vector.<Point> 	= new Vector.<Point>(); 
			downAnimCoords.push(new Point(0,1));
			downAnimCoords.push(new Point(0,0));
			downAnimCoords.push(new Point(0,2));
			downAnimCoords.push(new Point(0,0));
			
			var upAnimCoords:Vector.<Point> = new Vector.<Point>();
			upAnimCoords.push(new Point(2,1));
			upAnimCoords.push(new Point(2,0));
			upAnimCoords.push(new Point(2,2));
			upAnimCoords.push(new Point(2,0));
			
			var leftAnimCoords:Vector.<Point> = new Vector.<Point>();
			leftAnimCoords.push(new Point(3,1));
			leftAnimCoords.push(new Point(3,0));
			leftAnimCoords.push(new Point(3,2));
			leftAnimCoords.push(new Point(3,0));
			
			var rightAnimCoords:Vector.<Point> = new Vector.<Point>();
			rightAnimCoords.push(new Point(1,1));
			rightAnimCoords.push(new Point(1,0));
			rightAnimCoords.push(new Point(1,2));
			rightAnimCoords.push(new Point(1,0));
			
			sprite.setTile(ZManager.processTile((new HumanTile() as Bitmap).bitmapData), 4, 3);
			
			sprite.addFacing(new ZFacing(ZConstants.UP, new Point(2,0)));
			sprite.addFacing(new ZFacing(ZConstants.DOWN, new Point(0,0)));
			sprite.addFacing(new ZFacing(ZConstants.LEFT, new Point(3,0)));
			sprite.addFacing(new ZFacing(ZConstants.RIGHT, new Point(1,0)));
			
			sprite.addAnimation(new ZAnimation(ZConstants.DOWN_ANIMATED,downAnimCoords));
			sprite.addAnimation(new ZAnimation(ZConstants.UP_ANIMATED,upAnimCoords));
			sprite.addAnimation(new ZAnimation(ZConstants.LEFT_ANIMATED,leftAnimCoords));
			sprite.addAnimation(new ZAnimation(ZConstants.RIGHT_ANIMATED,rightAnimCoords));
			
			sprite.changeFacing((ZConstants.DOWN));
			//sprite.changeAnimation(ZConstants.DOWN_ANIMATED); 
			sprite.name = "Human";
			sprite.frequency = 8;
			sprite.speed = 2;
			sprite.clipping = true;
			
			var occupiedGrid:Array2 = new Array2(2,4);
			for (var i:int = 0; i < occupiedGrid.width;i++) {
				for (var j:int = 0; j < occupiedGrid.height;j++) {
					occupiedGrid.set(i, j, false);
				}
			}
			occupiedGrid.set(0,3,true);
			occupiedGrid.set(1,3,true);
			sprite.spanGrid = occupiedGrid;
			sprite.occupiedFlag = ZConstants.OCCUPIED_HUMAN;
			
			return sprite;
		}
		
	}
}