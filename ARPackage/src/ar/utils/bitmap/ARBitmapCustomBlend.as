package ar.utils.bitmap
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.getTimer;

	/**
	 * author  : kimcoder
	 * created : Nov 6, 2012
	 */
	public class ARBitmapCustomBlend extends EventDispatcher
	{
		public function ARBitmapCustomBlend()
		{
		}
		
		
		
		
		/*public static function colorDodge($overBD:BitmapData, $underBD:BitmapData):BitmapData
		{
			var newBD:BitmapData  = new BitmapData($overBD.width, $overBD.height);
			var __rect:Rectangle  = newBD.rect;
			var __totalPixel:uint = __rect.width*__rect.height;
			var __x:int;
			var __y:int;
			
			var __timer:int = getTimer();
			trace("__totalPixel",__totalPixel);
			for (var i:uint=0; i<__totalPixel; i++)
			{
				__x = i%__rect.width;
				__y = Math.floor(i/__rect.width);
				
				var c1:int   = ARBitmapPixels.getNum16($overBD.getPixel(__x,__y));
				var c2:int   = ARBitmapPixels.getNum16($underBD.getPixel(__x,__y));
				var col:uint = ARBitmapPixels.getColorDodgeColor(c1, c2);		
				var c3:int   = ARBitmapPixels.getColor(col);		
				newBD.setPixel(__x, __y, c3);
			}
			
			$overBD.dispose();
			$underBD.dispose();
			trace("__totalPixel",__totalPixel, getTimer()-__timer);
		
			return newBD;
		}*/
		
		
		
		public static function colorDodge($overBD:BitmapData, $underBD:BitmapData):BitmapData
		{
			var newBD:BitmapData  = new BitmapData($overBD.width, $overBD.height);
			var __rect:Rectangle  = newBD.rect;
			var __totalPixel:uint = __rect.width*__rect.height;
			var __x:int;
			var __y:int;
			var _tp:uint;
			var _bp:uint;
			var _op:uint;
			
			var __timer:int = getTimer();
			trace("__totalPixel",__totalPixel);
			for (var i:uint=0; i<__totalPixel; i++)
			{
				__x = i%__rect.width;
				__y = Math.floor(i/__rect.width);
				
				_tp = $overBD.getPixel(__x, __y);
				_bp = $underBD.getPixel(__x, __y);
				_op = colorDodgeWrap(_tp, _bp);
				
				newBD.setPixel(__x, __y, _op);
			}
			
			$overBD.dispose();
			$underBD.dispose();
			trace("__totalPixel",__totalPixel, getTimer()-__timer);
	
			return newBD;
		}
		
		
		
		private static function colorDodgeWrap($color1:uint, $color2:uint):uint
		{
			return combineRGB(colorDod((($color1>>16)&0xFF),(($color2>>16)&0xFF))  ,colorDod((($color1>>8)&0xFF),(($color2>>8)&0xFF))  ,colorDod(($color1&0xFF),($color2&0xFF)));
		}
		private static function colorDod($color1:uint, $color2:uint):uint
		{
			if ($color2 == 0xff)
				return $color2;
			var returnColor:uint = ($color1 << 8) / (0xff - $color2);
			return (returnColor > 0xff) ? 0xff : returnColor;
		}
		private static function combineRGB($r:uint,$g:uint,$b:uint):uint
		{
			return (($r<<16)|($g<<8)|$b)
		}
	}
}