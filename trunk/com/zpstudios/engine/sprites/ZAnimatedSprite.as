package com.zpstudios.engine.sprites
{
	import com.carlcalderon.arthropod.Debug;
	import com.zpstudios.engine.ZConstants;
	import com.zpstudios.engine.vo.ZAnimation;
	
	public class ZAnimatedSprite extends ZSprite{
		
		//Animation variables
		protected var _animations:Vector.<ZAnimation>;
		
		protected var _freq:int;
		protected var _animated:Boolean;
		protected var _repeat:Boolean;
		protected var _animIndex:int;
		protected var _activeAnimation:ZAnimation;
		//protected var _activeAnimationName
		
		//test
		
		public function ZAnimatedSprite(unitSize:int, unitWidth:int, unitHeight:int) {
			super(unitSize, unitWidth, unitHeight);
			_animated = false;
			_repeat = false;
			_animIndex = 0;
			_freq = 5;
			_animations = new Vector.<ZAnimation>;
		}
		
		public function set frequency(freq:int):void {
			_freq = freq;
		}
		
		public function addAnimation(animation:ZAnimation):void{
			_animations.push(animation);
		}
		
		
		override protected function _checkFacing():void {
			super._checkFacing();
			//trace("poop");
			if (xFacing > 0) {
				changeAnimation(ZConstants.RIGHT_ANIMATED,true,true,0,_freq);
			}else if (xFacing < 0) {
				changeAnimation(ZConstants.LEFT_ANIMATED,true,true,0,_freq);
			}else if (yFacing > 0) {
				changeAnimation(ZConstants.DOWN_ANIMATED,true,true,0,_freq);
			}else if (yFacing < 0) {
				changeAnimation(ZConstants.UP_ANIMATED,true,true,0,_freq);
			}
		}
		
		override public function tick(value:int) : void{
			super.tick(value);
			
			if (_animated&&_moving) {
				if (value%_freq == 0) {
					//trace("rendering "+this);
					_renderSprite(_activeAnimation.tileCoords[_animIndex]);
					//trace("cockels");
					if (_animIndex == _activeAnimation.tileCoords.length-1){
						if (!_repeat){
							_animated = false;
							
						}
						_animIndex = 0;
					}else {
						_animIndex++;
					}
				}
			}
		}
		
		public function changeAnimation(animationName:String, animated:Boolean = true, repeat:Boolean = true, animIndex:int = 0, freq:int = 4):void {
			if (_activeAnimation == null || _activeAnimation.name != animationName) {
				_activeAnimation = _getAnimationByName(animationName);
				_freq = freq;
				_animated = animated;
				_repeat = repeat;
				_animIndex = 0;
			}
		}
		
		protected function _getAnimationByName(name:String):ZAnimation {
			for (var i:int = 0; i < _animations.length; i++) {
				if (_animations[i].name == name) {
					return _animations[i]
				}
			}
			Debug.error("Animation "+name+" not found in Sprite:"+this.name);
			return null;
		}
		
		override public function spawn(moving:Boolean = false) : void{
			super.spawn(moving);
			_animated = false;
		} 
		
		override protected function _spawned(moving:Boolean = false):void {
			super._spawned(moving);
			_animated = moving;
		}
		
		
		
	}
}