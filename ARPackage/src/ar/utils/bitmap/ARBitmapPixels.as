package ar.utils.bitmap
{
	/**
	 * author  : kimcoder
	 * created : Nov 6, 2012
	 */
	public class ARBitmapPixels
	{
		public function ARBitmapPixels()
		{
		}
		
		public static function getNum16(num:int):int 
		{
			var n1:String = int(num).toString(16);
			var s1:String = String(n1).substring(4);
			var t1:String = "0x" + s1;
			return int(int(t1).toString(10));
		}
		
		public static function getColor(num:int):int 
		{
			var s:String  = int(num).toString(16);
			var t1:String = "0x" + s + s+ s;
			return int(int(t1).toString(10));
		}
		
		public static function getColorDodgeColor(color1:uint,color2:uint):uint
		{
			return (color1>=255) ? 255 : Math.min(color2*255/(255-color1),255);
		}
	}
}