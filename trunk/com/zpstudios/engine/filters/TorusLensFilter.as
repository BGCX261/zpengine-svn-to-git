package com.zpstudios.engine.filters 
{
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	
	public class TorusLensFilter extends ShaderFilter
	{
		//the file that contains the binary bytes of the PixelBender filter
		[Embed("../assets/gfx/filters/torus_lense.pbj", mimeType="application/octet-stream")]
		private var Filter:Class;		
		
		private var _shader:Shader;
		
		public function TorusLensFilter(radiusIndex:Number = 8, radius:int = 50, thickness:int = 100, centerX:int = 0, centerY:int = 0)
		{
			//initialize the ShaderFilter with the PixelBender filter
			_shader = new Shader(new Filter() as ByteArray);
			
			//set the default value
			this.rIndex 	= radiusIndex;
			this.radius 	= radius;
			this.thickness 	= thickness;
			this.centerX 	= centerX;
			this.centerY 	= centerY;
			
			super(_shader);
		}
		
		public function set rIndex(value:Number):void {
			_shader.data.r_index.value = [value];
		}
		public function set radius(value:int):void {
			_shader.data.radius.value = [value];
		}
		public function set thickness(value:int):void {
			_shader.data.thickness.value = [value];
		}
		public function set centerX(value:int):void {
			_shader.data.center.value[0] = value;
		}
		public function set centerY(value:int):void {
			_shader.data.center.value[1] = value;
		}
		
		public function get rIndex():Number {
			return _shader.data.r_index.value;
		}
		public function get radius():int {
			return _shader.data.radius.value;
		}
		public function get thickness():int {
			return _shader.data.thickness.value;
		}
		public function get centerX():int {
			return _shader.data.center.value[0];
		}
		public function get centerY():int {
			return _shader.data.center.value[1];
		}
		
	}
}