/**
    @codehint     Gives you a way to change the Hue and Saturation
                on DisplayObjects.
 
    @example    
                import com.ar.fillter.HueColorMatrixFilter;
				import flash.display.BitmapData;
				
				
				import flash.display.DisplayObject;
				import flash.display.MovieClip;
                import flash.events.*;
                
                var HCMF = new HueColorMatrixFilter();
                var H = 0;
                var I = 0;
                
                clip.addEventListener(Event.ENTER_FRAME, oEF);
                
                function oEF(e:Event)
                {
                    HCMF.reset();
                    HCMF.Hue = H++;
                    I += Math.PI/360;
                    HCMF.Saturation = Math.sin(I);
                    clip.filters = [HCMF.Filter];
                }            

*/
package ar.utils.fillter 
{
	import flash.filters.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	/**
	 * ...
	 * @author jucina
	 */
	public class ColorMatrixFilterManager
	{
		private var matrix:Array;
		public function ColorMatrixFilterManager() 
		{
			Identity();
		}
		private function Identity():void
        {
            matrix = [    1, 0, 0, 0, 0,
                        0, 1, 0, 0, 0,
                        0, 0, 1, 0, 0,
                        0, 0, 0, 1, 0    ];
        }
        
        public function reset():void
        {
            Identity();
        }
		
		
        public static function setSaturation($mc:DisplayObject, $amount:Number):void {
			$amount = $amount/100;
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			var redIdentity:Array = [1, 0, 0, 0, 0];
			var greenIdentity:Array = [0, 1, 0, 0, 0];
			var blueIdentity:Array = [0, 0, 1, 0, 0];
			var alphaIdentity:Array = [0, 0, 0, 1, 0];
			var grayluma:Array = [.3, .59, .11, 0, 0];
			var colmatrix:Array = new Array();
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, redIdentity, $amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, greenIdentity, $amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, blueIdentity, $amount));
			colmatrix = colmatrix.concat(alphaIdentity);
			colorFilter.matrix = colmatrix;
			$mc.filters = [colorFilter];
			
		}
		
		
		public static function setBitSaturation($mc:BitmapData, $amount:Number):BitmapData 
		{
			$amount = $amount/100;
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter();
			var redIdentity:Array = [1, 0, 0, 0, 0];
			var greenIdentity:Array = [0, 1, 0, 0, 0];
			var blueIdentity:Array = [0, 0, 1, 0, 0];
			var alphaIdentity:Array = [0, 0, 0, 1, 0];
			var grayluma:Array = [.3, .59, .11, 0, 0];
			var colmatrix:Array = new Array();
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, redIdentity, $amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, greenIdentity, $amount));
			colmatrix = colmatrix.concat(interpolateArrays(grayluma, blueIdentity, $amount));
			colmatrix = colmatrix.concat(alphaIdentity);
			colorFilter.matrix = colmatrix;
			$mc.applyFilter($mc, $mc.rect, new Point(), colorFilter);
			return $mc;
		}
		
		
		private static function interpolateArrays(ary1:Array, ary2:Array, t:Number):Array 
		{
			var result:Array = (ary1.length>=ary2.length) ? ary1.slice() : ary2.slice();
			var i:uint = result.length;
			while (i--) {
				result[i] = ary1[i]+(ary2[i]-ary1[i])*t;
			}
			return result;
		}
		
		
        public function set Saturation(saturation:Number):void
        {
            saturation = (saturation > 1)?1:(saturation < 0)?0:saturation;
            
            var M1:Array = [    0.213, 0.715, 0.072,
                                0.213, 0.715, 0.072,
                                0.213, 0.715, 0.072];
            var M2:Array = [    0.787, -0.715, -0.072,
                                -0.212, 0.285, -0.072,
                                -0.213, -0.715, 0.928];
            var M3:Array = add(M1, multiply(saturation, M2));

            concat([    M3[0], M3[1], M3[2], 0, 0,
                        M3[3], M3[4], M3[5], 0, 0,
                        M3[6], M3[7], M3[8], 0, 0,
                            0,       0,      0, 1, 0]);
        }
        private var _h:Number = 0;
            
        public function set Hue(hue:Number):void
        {
            _h = hue;
            // convert from Rad to Degrees
            hue = _h*0.0174532925;
            
            var M1:Array = [    0.213, 0.715, 0.072,
                                0.213, 0.715, 0.072,
                                0.213, 0.715, 0.072];
                                
            var M2:Array = [    0.787, -0.715, -0.072,
                                -0.212, 0.285, -0.072,
                                -0.213, -0.715, 0.928];
                                
            var M3:Array = [    -0.213, -0.715, 0.928,
                                0.143, 0.140, -0.283,
                                -0.787, 0.715, 0.072];
            var M4:Array = add(M1, add(multiply(Math.cos(hue), M2), multiply(Math.sin(hue), M3)));

            concat([    M4[0], M4[1], M4[2], 0, 0,
                        M4[3], M4[4], M4[5], 0, 0,
                        M4[6], M4[7], M4[8], 0, 0,
                            0,       0,      0, 1, 0]);
        }
        
        public function get Hue():Number
        {
            return _h;
        }
        
        private function add(A:Array, B:Array):Array
        {
            var C:Array = [];
            for(var i:uint=0; i<A.length; i++)
            {
                C.push( A[i] + B[i] );
            }
            return C;
        }
        
        private function multiply(x:Number, B:Array):Array
        {
            var A:Array = [];
            for each(var n:Number in B)
            {
                if(n == 0)
                    A.push(0);
                else
                    A.push(x * n);
            }
            return A;
        }
        
        private function concat(B:Array):void
        {
            var nM:Array = [];
            var A:Array = matrix;
            
            nM[0] = (A[0] * B[0]) + (A[1] * B[5]) + (A[2] * B[10]);
            nM[1] = (A[0] * B[1]) + (A[1] * B[6]) + (A[2] * B[11]);
            nM[2] = (A[0] * B[2]) + (A[1] * B[7]) + (A[2] * B[12]);
            nM[3] = 0;
            nM[4] = 0;
            
            nM[5] = (A[5] * B[0]) + (A[6] * B[5]) + (A[7] * B[10]);
            nM[6] = (A[5] * B[1]) + (A[6] * B[6]) + (A[7] * B[11]);
            nM[7] = (A[5] * B[2]) + (A[6] * B[7]) + (A[7] * B[12]);
            nM[8] = 0;
            nM[9] = 0;
            
            nM[10] = (A[10] * B[0]) + (A[11] * B[5]) + (A[12] * B[10]);
            nM[11] = (A[10] * B[1]) + (A[11] * B[6]) + (A[12] * B[11]);
            nM[12] = (A[10] * B[2]) + (A[11] * B[7]) + (A[12] * B[12]);
            nM[13] = 0;
            nM[14] = 0;
            
            nM[15] = 0;
            nM[16] = 0;
            nM[17] = 0;
            nM[18] = 1;
            nM[19] = 0;

            matrix = nM;
        }
        
        public function get Filter():ColorMatrixFilter
        {
            return new ColorMatrixFilter(matrix);
        }
	}

}