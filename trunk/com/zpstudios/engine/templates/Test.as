package {
	import com.zpstudios.engine.ZConstants;
	import com.zpstudios.engine.factory.ZFactory;
	import com.zpstudios.engine.managers.ZGridManager;
	import com.zpstudios.engine.managers.ZSpriteManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	
	import net.hires.debug.Stats;
	
	[SWF(frameRate='30',backgroundColor='0xFFFFFF',width='400',height='400')]
	public class Test extends Sprite{
		//Settings
		public const WIDTH:int = 400;
		public const HEIGHT:int = 400;
		
		//Layers
		public var _bgLayer:Sprite;
		public var _gridLayer:Sprite;
		public var _spriteLayer:Sprite;
		
		//ZComponents
		public var _gm:ZGridManager;
		public var _sm:ZSpriteManager;
		
		
		public function Test() {
			stage.scaleMode=StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			
			_bgLayer 		= new Sprite();
			_spriteLayer 	= new Sprite();
			_gridLayer 		= new Sprite();
			
			_gm 			= new ZGridManager(WIDTH/ZConstants.UNIT_SIZE, HEIGHT/ZConstants.UNIT_SIZE,_gridLayer);
			_gm.masked 		= true;
			var bg:Bitmap 	= new Bitmap(ZFactory.buildMap(WIDTH/ZConstants.UNIT_SIZE, HEIGHT/ZConstants.UNIT_SIZE));
			
			stage.addChild(_bgLayer);
			stage.addChild(_gridLayer);
			stage.addChild(_spriteLayer);
			_bgLayer.addChild(bg);
			
			var st:Stats = stage.addChild(new Stats()) as Stats;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.CLICK, mouseClicked);
			
		}
		
		public function mouseMove(event:MouseEvent):void {
			_gm.moveMask(stage.mouseX, stage.mouseY);
		}
		
		public function mouseClicked(event:MouseEvent):void {
			
		}
	}
}