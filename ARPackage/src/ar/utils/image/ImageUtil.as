package ar.utils.image
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class ImageUtil
	{
		public function ImageUtil()
		{
		}
		
		static public function copyBitmapData($source:BitmapData, $width:int, $height:int, $destPoint:Point, $rotate:Number=0):BitmapData
		{
			var __res_bitmapdata:BitmapData = new BitmapData($width, $height);
			
			var m:Matrix = new Matrix();
			m.translate(-$destPoint.x, -$destPoint.y);
			
			if ($rotate != 0)
			{
				m.rotate($rotate);
				if ($rotate == Math.PI/2)
					m.translate($width, 0);
				else if ($rotate == -Math.PI/2)
					m.translate(0, $height);
			}
			
			__res_bitmapdata.draw($source, m);
			
			return __res_bitmapdata;
		}
	}
}