package com.zpstudios.engine.filters 
{
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	
	public class PixelateFilter extends ShaderFilter
	{
		//the file that contains the binary bytes of the PixelBender filter
		[Embed("../assets/gfx/filters/pixelate.pbj", mimeType="application/octet-stream")]
		private var Filter:Class;		
		
		private var _shader:Shader;
		
		public function PixelateFilter(dimension:int = 10)
		{
			//initialize the ShaderFilter with the PixelBender filter
			_shader = new Shader(new Filter() as ByteArray);
			
			//set the default value
			this.dimension 	= dimension;
			
			super(_shader);
		}
		
		public function set dimension(value:int):void {
			_shader.data.dimension.value = [value];
		}
		
		public function get dimension():int {
			return _shader.data.dimension.value;
		}
		
	}
}