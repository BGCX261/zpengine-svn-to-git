package  com.zpstudios.engine.sprites
{
	import com.carlcalderon.arthropod.Debug;
	import com.flashdynamix.motion.Tweensy;
	import com.zpstudios.engine.ZConstants;
	import com.zpstudios.engine.events.ZEvent;
	import com.zpstudios.engine.filters.PixelateFilter;
	import com.zpstudios.engine.managers.ZGridManager;
	import com.zpstudios.engine.managers.ZManager;
	import com.zpstudios.engine.managers.ZSpriteManager;
	import com.zpstudios.engine.vo.ZBehaviour;
	import com.zpstudios.engine.vo.ZCell;
	import com.zpstudios.engine.vo.ZFacing;
	import com.zpstudios.engine.vo.ZGrid;
	
	import de.polygonal.ds.Array2;
	
	import fl.motion.easing.Exponential;
	import fl.motion.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class ZSprite extends Sprite {
		//private const MOVEMENT:int = 5;
		
	//	Debug.password = "poop";
		protected var _speed:int = 1;
		protected var _bitmap:Bitmap;
		protected var _tileData:BitmapData;
		protected var _behaviours:Vector.<ZBehaviour>;
		protected var _manager:ZManager;
		protected var _spanGrid:Array2;
		
		protected var _clipping:Boolean;
		
		
		public var occupiedFlag:uint;
		public var unitSize:int;
		//public var unitWidth:int;
		//public var unitHeight:int;
		public var absWidth:int;
		public var absHeight:int;
		
		//Bitmap Tile Data
		protected var _tileWidth:int;
		protected var _tileHeight:int;
		
		//Facing Variables
		
		protected var _facingPoints:Vector.<ZFacing>;
		
		//Manager Variables
		public var depth:int;
		
		public var xFacing:int;
		public var yFacing:int;
		
		protected var _controlling:Boolean = false;
		protected var _direction:String;
		protected var _moving:Boolean = false;
		protected var _moveLoop:Boolean = false;
		
		protected var _waitingTimer:int = 0;
		
		public var originPoint:Point;
		public var destinationPoint:Point;
		public var pathI:int = 0;
		public var path:Vector.<Point>;
		
		
		public function ZSprite(unitSize:int, unitWidth:int, unitHeight:int, spanGrid:Array2 = null, occupiedFlag:uint = ZConstants.OCCUPIED_HUMAN) {
			super();
			//_bitmap = new Bitmap(new BitmapData(unitWidth*unitSize,unitHeight*unitSize, true, 0xFF0000));
			_bitmap = new Bitmap(new BitmapData(unitWidth,unitHeight, true, 0xFF0000));
			this.addChild(_bitmap);
			this.unitSize = unitSize;
			this.absWidth = unitWidth;
			this.absHeight = unitHeight;
			_facingPoints = new Vector.<ZFacing>;
			this.path = new Vector.<Point>;
			this._spanGrid = spanGrid;
			this._clipping = false;
			this.occupiedFlag = occupiedFlag;
			originPoint = new Point(0,0);
		}
		
		public function changeFacing(facing:String):void {
			var point:Point = _getFacingByName(facing);
			_renderSprite(point);
		}
		
		protected function _renderSprite(point:Point):void {
			_bitmap.bitmapData.copyPixels(_tileData, new Rectangle(point.x*absWidth, point.y*absHeight,absWidth, absHeight), new Point(0,0));
		}
		
		public function renderPoint(point:Point):BitmapData {
			var data:BitmapData = new BitmapData(absWidth, absHeight);
			data.copyPixels(_tileData, new Rectangle(point.x*absWidth, point.y*absHeight,absWidth, absHeight), new Point(0,0));
			return data;
		}
		
		
		public function setTile(tileData:BitmapData, tileWidth:int, tileHeight:int):void {
			_tileData = tileData;
			_tileWidth = tileWidth;
			_tileHeight = tileHeight;
		}
		
		public function setFacingPoints(facingPoints:Vector.<ZFacing>):void {
			_facingPoints = facingPoints;
		}
		public function addFacing(newFacing:ZFacing):void {
			_facingPoints.push(newFacing);
		}
		
		protected function _getFacingByName(name:String):Point {
			for (var i:int = 0;i < _facingPoints.length;i++){
				if (_facingPoints[i].name == name){
					return _facingPoints[i].tileCoord;
				}
			}
			
			Debug.error("Facing point not found in ZSprite:"+this);
			return null;
		}
		
		public function setPosition(xVal:int, yVal:int):void {
			originPoint.x = xVal;
			originPoint.y = yVal;
			this.x = originPoint.x*unitSize;
			this.y = originPoint.y*unitSize;
			this.dispatchEvent(new Event(ZConstants.DEPTH_EVENT));
		}
		
		public function movePath(path:Vector.<Point>, startIndex:int, loop:Boolean):void {
			
			
			if (path && path.length > 1) {
				if (_moving) {
					
					//	destinationPoint = originPoint;
				
				}
				
				this.path = path;
				this.pathI = startIndex;
				originPoint = path[pathI];
				this.x = originPoint.x*unitSize;
				this.y = originPoint.y*unitSize;
				pathI++;
				_moveLoop = loop;
				move(path[pathI].x, path[pathI].y);
			}
		}
		
		public function addWaypoint(x:int, y:int):void {
			if (path) {
				path.push(new Point(x, y));
			}
		}
		
		public function move(x:int, y:int):void {
			
			destinationPoint = new Point(x, y);
			
			this.x = originPoint.x*unitSize;
			this.y = originPoint.y*unitSize;
			Debug.log(this.name+" move to "+destinationPoint);
			
			xFacing = 0;
			yFacing = 0;
			if (originPoint.x > destinationPoint.x) {
				xFacing = -1;
			}else if(originPoint.x  < destinationPoint.x) {
				xFacing = 1;
			}
			
			if (originPoint.y > destinationPoint.y) {
				yFacing = -1;
			}else if(originPoint.y  < destinationPoint.y) {
				yFacing = 1;
			}
			
			_moving = true;
			_checkFacing();
		}
		
		protected function _checkFacing():void {
			//todo
			//trace("balls");
		}
		
		public function tick(value:int):void {
			if (_waitingTimer > 0) {
				_waitingTimer--;
			}
			
			if (_moving && !_waiting) {
				//trace(value%MOVEMENT);
				if (value%_speed == 0) {
				
					if (xFacing != 0) {
						var lowX:Boolean = x >= destinationPoint.x*unitSize-Math.abs(xFacing);
						var hiX:Boolean = x <= destinationPoint.x*unitSize+Math.abs(xFacing);
						
						x+=xFacing;
						if (lowX && hiX) {
							//trace("X reached");
							xFacing = 0;
							x = destinationPoint.x*unitSize;
							_checkFacing();
						}
					}else {
						if (yFacing != 0) {
							y+=yFacing;
							
							var lowY:Boolean = y >= destinationPoint.y*unitSize-Math.abs(yFacing);
							var hiY:Boolean = y <= destinationPoint.y*unitSize+Math.abs(yFacing);
							
							this.dispatchEvent(new Event(ZConstants.DEPTH_EVENT));
							if (lowY && hiY) {
								//trace("Y reached");
								yFacing = 0;
								y = destinationPoint.y*unitSize;
								_checkFacing();
							}
						}
					}
					
					
					if ( xFacing == 0 && yFacing == 0 ){
						
						if (manager && manager.gridManager && destinationPoint && originPoint && destinationPoint != originPoint){
							manager.gridManager.moveSpritePosition(this);
						}
						
						if (path.length != 0) {
							originPoint = path[pathI];
							if (pathI == path.length -1) {
								if (_moveLoop) {
									dispatchEvent(new ZEvent(ZEvent.WAYPOINT_REACHED));
									pathI = 0;
									move(path[pathI].x, path[pathI].y);
								}else {
									if (!_behaviours || _behaviours.length == 0) {
										_moving = false;
									}
									path = new Vector.<Point>();
									dispatchEvent(new ZEvent(ZEvent.DESTINATION_REACHED));
								}
							}else {
								pathI++;
								move(path[pathI].x, path[pathI].y);
							}
						}else {
							
							if (_controlling) {
								
								originPoint = destinationPoint.clone();
								
								if (_direction != ZConstants.STOP) {//The contents of this IF should be the same as in the if (!_moving) statement inside the control() function for this class. Didn't make it a function to avoid the cost of an extra function call
									var potentialDestinationOffset:Point;
									var possible:Boolean = true;
									var tempCell:ZCell;
									var i:int;
									switch(_direction){
										case ZConstants.RIGHT:
											potentialDestinationOffset = new Point(1, 0);
											break;
										case ZConstants.UP:
											potentialDestinationOffset = new Point(0, -1);
											break;
										case ZConstants.DOWN:
											potentialDestinationOffset = new Point(0, +1);
											break;
										case ZConstants.LEFT: 
											potentialDestinationOffset = new Point(-1, 0);
											break;
									}
									
									if (clipping) {
										
										for (i = 0; i < spanGrid.width && possible;i++){
											for (var j:int = 0; j < spanGrid.height && possible;j++){
												if (spanGrid.get(i, j)){
													tempCell = (this.manager as ZSpriteManager).gridManager.grid.getCell(originPoint.x+potentialDestinationOffset.x+i, originPoint.y+potentialDestinationOffset.y+j);
													possible = tempCell && (tempCell.p || (tempCell.occupied && i+potentialDestinationOffset.x < spanGrid.width && j+potentialDestinationOffset.y < spanGrid.height && spanGrid.get(i+potentialDestinationOffset.x, j+potentialDestinationOffset.y)));
												}
											}
										}
										
										
										if (possible) {
											move(originPoint.x+potentialDestinationOffset.x, originPoint.y+potentialDestinationOffset.y);
										}else {
											_moving = false;
											changeFacing(_direction);
										}
									}else {
										move(originPoint.x+potentialDestinationOffset.x, originPoint.y+potentialDestinationOffset.y);
									}
								}else {
									_moving = false;
									changeFacing(ZConstants.DOWN);
								}
								
									
								
							}else {
								
								//MOVEMENT DONE, CHECK FOR NEXT ACTION IN BEHAVIOURS
								if (_behaviours && _behaviours.length > 0) {
									for (var i:int = 0; i < _behaviours.length;i++) {
										
										switch(_behaviours[i].type) {
											case ZBehaviour.FOLLOW:
												if (destinationPoint != _behaviours[i].actorSprite.originPoint) {//not here, follow some more
													if (this.manager && this.manager.gridManager) {
														var newPath:Vector.<Point> = ZGridManager.shortestPath(this.manager.gridManager.grid,originPoint,new Point(_behaviours[i].actorSprite.originPoint.x,_behaviours[i].actorSprite.originPoint.y) ,this.spanGrid,this.occupiedFlag);
														if (newPath) {
															this.movePath(newPath,0,false);
														}else {
															changeFacing(ZConstants.DOWN);
															this.wait(200);
														}
													}
													
												}else {//got the fucker
													_moving = false;
													changeFacing(ZConstants.DOWN);
													dispatchEvent(new ZEvent(ZEvent.DESTINATION_REACHED));
												}
													
												break;
											case ZBehaviour.IDLE:
												//TODO
												break;
											case ZBehaviour.FLEE:
												//TODO
												break;
										}
									}
								}else {
									//DONE MOVING FORREALS
									_moving = false;
									changeFacing(ZConstants.DOWN);
									dispatchEvent(new ZEvent(ZEvent.DESTINATION_REACHED));
								}
								
							}
							
							//originPoint = destinationPoint;
							//this.move(int(Math.random()*20),int(Math.random()*20));
						}
					}
				}
			}
		}
		
		public function get speed():int {
			return _speed;
		}
		
		public function set speed(value:int):void {
			_speed = value;
		}
		
		public function spawn(moving:Boolean = false):void {
			var time:Number = Math.random()*3;
			var type:int = int(Math.random()*2);
			var _filter1:PixelateFilter = new PixelateFilter(20);
			
			
			this.alpha = 0;
			Tweensy.to(this,{alpha:1},time+.2,Linear.easeIn,0,this);
			var easing:Function;
			
			switch(type) {
				case 0:
					easing = fl.motion.easing.Exponential.easeOut;
					break;
				case 1:
					easing = fl.motion.easing.Linear.easeOut;
				break;
			}
		
			Tweensy.to(_filter1,{dimension:1}, time+.2, easing,0,this,_spawned,[moving]);
			this.filters = [_filter1];
	
			
		}
		
		public function controllerMode(on:Boolean):void {
			path = new Vector.<Point>();
			_controlling = on;
		}
		
		public function control(direction:String):void {
			_direction = direction;
			
			if (!_moving && !_waiting) {
				if (_direction != ZConstants.STOP) {
					var potentialDestinationOffset:Point;
					var possible:Boolean = true;
					var tempCell:ZCell;
					var i:int;
					switch(_direction){
						case ZConstants.RIGHT:
							potentialDestinationOffset = new Point(1, 0);
							break;
						case ZConstants.UP:
							potentialDestinationOffset = new Point(0, -1);
							break;
						case ZConstants.DOWN:
							potentialDestinationOffset = new Point(0, +1);
							break;
						case ZConstants.LEFT: 
							potentialDestinationOffset = new Point(-1, 0);
							break;
					}
					
					if (clipping) {
						for (i = 0; i < spanGrid.width && possible;i++){
							for (var j:int = 0; j < spanGrid.height && possible;j++){
								if (spanGrid.get(i, j)){
									tempCell = (this.manager as ZSpriteManager).gridManager.grid.getCell(originPoint.x+potentialDestinationOffset.x+i, originPoint.y+potentialDestinationOffset.y+j);
									possible = tempCell && (tempCell.p || (tempCell.occupied && i+potentialDestinationOffset.x < spanGrid.width && j+potentialDestinationOffset.y < spanGrid.height && spanGrid.get(i+potentialDestinationOffset.x, j+potentialDestinationOffset.y)));
								}
							}
						}
						
						
						if (possible) {
							move(originPoint.x+potentialDestinationOffset.x, originPoint.y+potentialDestinationOffset.y);
						}else {
							_moving = false;
							changeFacing(_direction);
						}
					}else {
						move(originPoint.x+potentialDestinationOffset.x, originPoint.y+potentialDestinationOffset.y);
					}
				}
			}
		}
		
		protected function _spawned(moving:Boolean = false):void {
			this.filters = [];
			if (moving) {
				this.move(int(Math.random()*20),int(Math.random()*20));
			}
		}
		
		public function addBehaviour(newBehaviour:ZBehaviour):void {
			if (!_behaviours) {_behaviours = new Vector.<ZBehaviour>()}
			_behaviours.push(newBehaviour);
			if (newBehaviour.type == ZBehaviour.FOLLOW) {
				_moving = true;
			}
		}
		
		public function removeBehaviour(behaviourName:String):void {
			if (!_behaviours) {_behaviours = new Vector.<ZBehaviour>()}
			for (var i:int = 0; i < _behaviours.length;i++) {
				if (_behaviours[i].type == behaviourName) {
					_behaviours.splice(i,1);
					return;
				}
			}
			Debug.error("Behaviour "+behaviourName+" not found in "+this.name);
		}
		
		public function set clipping(clipping:Boolean):void {
			_clipping = true;
		}
		
		public function get clipping():Boolean {
			return _clipping;
		}
		
		public function get manager():ZManager {
			return _manager;
		}
		
		public function set manager(manager:ZManager):void {
			_manager = manager;
		}
		
		public function get spanGrid():Array2 {
			return _spanGrid;
		}
		
		public function set spanGrid(occupatingGrid:Array2):void {
			_spanGrid = occupatingGrid;
		}
		
		public function wait(ticks:int):void {
			_waitingTimer = ticks;	
		}
		
		protected function get _waiting():Boolean {
			return _waitingTimer > 0;
		}
	}
}