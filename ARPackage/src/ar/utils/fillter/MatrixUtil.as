package ar.utils.fillter 
{
	import flash.filters.ColorMatrixFilter;
	import flash.filters.ConvolutionFilter;

	/**
	 * ...
	 * @author jucina
	 */
	public class MatrixUtil
	{
		/**
		 * sets brightness value available are -100 ~ 100 @default is 0
		 * @param 		value:int	brightness value
		 * @return		ColorMatrixFilter
		 */
		public static function setBrightness(value:Number):ColorMatrixFilter
		{
			value = value*(255/250);

			var m:Array = new Array();
    		m = m.concat([1, 0, 0, 0, value]);	// red
   		 	m = m.concat([0, 1, 0, 0, value]);	// green
   		 	m = m.concat([0, 0, 1, 0, value]);	// blue
    		m = m.concat([0, 0, 0, 1, 0]);		// alpha

    		return new ColorMatrixFilter(m);
		}

		/**
		 * sets contrast value available are -100 ~ 100 @default is 0
		 * @param 		value:int	contrast value
		 * @return		ColorMatrixFilter
		 */
		public static function setContrast(value:Number):ColorMatrixFilter
		{
			value /= 100;
			var s: Number = value + 1;
    		var o : Number = 128 * (1 - s);

			var m:Array = new Array();
			m = m.concat([s, 0, 0, 0, o]);	// red
			m = m.concat([0, s, 0, 0, o]);	// green
			m = m.concat([0, 0, s, 0, o]);	// blue
			m = m.concat([0, 0, 0, 1, 0]);	// alpha

			return new ColorMatrixFilter(m);
		}

		/**
		 * sets saturation value available are -100 ~ 100 @default is 0
		 * @param 		value:int	saturation value
		 * @return		ColorMatrixFilter
		 */
		public static function setSaturation(value:Number):ColorMatrixFilter
		{
			const lumaR:Number = 0.212671;
    		const lumaG:Number = 0.71516;
    		const lumaB:Number = 0.072169;

			var v:Number = (value/100) + 1;
			var i:Number = (1 - v);
   		 	var r:Number = (i * lumaR);
    		var g:Number = (i * lumaG);
    		var b:Number = (i * lumaB);

			var m:Array = new Array();
			m = m.concat([(r + v), g, b, 0, 0]);	// red
			m = m.concat([r, (g + v), b, 0, 0]);	// green
			m = m.concat([r, g, (b + v), 0, 0]);	// blue
			m = m.concat([0, 0, 0, 1, 0]);			// alpha

 			return new ColorMatrixFilter(m);
		}
		
		
		
		public static function outline(value:Number=80):ConvolutionFilter
		{
			var q:Number = value / 4;
			var outlineArray:Array =  [	0,    q,   	  0, 
										q,   -value,  q, 
										0,    q,  	  0];
			
			return new ConvolutionFilter(3, 3, outlineArray, 10);
		}
		
		public static function get negative():ColorMatrixFilter
		{
			return new ColorMatrixFilter(   [
				-1  ,   0   ,   0   ,   0   ,   0xFF,
				0   ,   -1  ,   0   ,   0   ,   0xFF,
				0   ,   0   ,   -1  ,   0   ,   0xFF,
				0   ,   0   ,   0   ,   1   ,   0
			]   );
		}
		
		public static function get grayscale():ColorMatrixFilter
		{
			return new ColorMatrixFilter(   [
				.3086   ,   .6094   ,   .0820   ,   0   ,   0,
				.3086   ,   .6094   ,   .0820   ,   0   ,   0,
				.3086   ,   .6094   ,   .0820   ,   0   ,   0,
				0   ,   0   ,   0   ,   1   ,   0
			]   );
		}
	}

}