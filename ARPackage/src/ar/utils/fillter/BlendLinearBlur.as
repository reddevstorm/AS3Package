package ar.utils.fillter 
{
	import flash.display.Shader;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author jucina
	 */
	public class BlendLinearBlur extends Shader
	{
		//Parameters
        /**
         * (Parameter) lineEquation [Number, Number, Number]
         * @type float3
         * @minValue [-1, -1, -100]
         * @maxValue [1, 1, 100]
         * @defaultValue [0.7070000171661377, -0.7070000171661377, 30]
         */
        public function get lineEquation():Array { return data.lineEquation.value; }
        public function set lineEquation(value:Array):void { data.lineEquation.value = value; }
        public function get lineEquation_min():Array { return [-1, -1, -100]; }
        public function get lineEquation_max():Array { return [1, 1, 100]; }
        public function get lineEquation_default():Array { return [0.7070000171661377, -0.7070000171661377, 30]; }
        public function get lineEquation_type():String { return "float3"; }
        
        /**
         * (Parameter) uScale [Number]
         * @type float
         * @minValue [0]
         * @maxValue [10]
         * @defaultValue [1]
         */
        public function get uScale():Array { return data.uScale.value; }
        public function set uScale(value:Array):void { data.uScale.value = value; }
        public function get uScale_min():Array { return [0]; }
        public function get uScale_max():Array { return [10]; }
        public function get uScale_default():Array { return [1]; }
        public function get uScale_type():String { return "float"; }
        
        /**
         * (Parameter) vScale [Number]
         * @type float
         * @minValue [0]
         * @maxValue [10]
         * @defaultValue [1]
         */
        public function get vScale():Array { return data.vScale.value; }
        public function set vScale(value:Array):void { data.vScale.value = value; }
        public function get vScale_min():Array { return [0]; }
        public function get vScale_max():Array { return [10]; }
        public function get vScale_default():Array { return [1]; }
        public function get vScale_type():String { return "float"; }
        
        //Inputs
        /**
         * (Input) src
         * @channels 4
         */
        public function get src():Object { return data.src.input; }
        public function set src(input:Object):void { data.src.input = input; }
        public function get src_width():int { return data.src.width; }
        public function set src_width(width:int):void { data.src.width = width; }
        public function get src_height():int { return data.src.height; }
        public function set src_height(height:int):void { data.src.height = height; }
        
        //Constructor
        public function BlendLinearBlur(init:Object = null):void
        {
            if (_byte == null)
            {
                _byte = new ByteArray();
                for (var i:uint = 0, l:uint = _data.length; i < l; ++i) _byte.writeByte(_data[i]);
            }
            super(_byte);
            for (var prop:String in init) this[prop] = init[prop];
        }
        
        //Data
        private static var _byte:ByteArray = null;
        private static var _data:Vector.<int> = Vector.<int>([-91, 1, 0, 0, 0, -92, 18, 0, 70, 111, 99, 117, 115, 105, 110, 103, 76, 105, 110, 101, 97, 114, 66, 108, 117, 114, -96, 12, 110, 97, 109, 101, 115, 112, 97, 99, 101, 0, 70, 111, 99, 117, 115, 105, 110, 103, 76, 105, 110, 101, 97, 114, 66, 108, 117, 114, 0, -96, 12, 118, 101, 110, 100, 111, 114, 0, 80, 101, 116, 114, 105, 32, 76, 101, 115, 107, 105, 110, 101, 110, 0, -96, 8, 118, 101, 114, 115, 105, 111, 110, 0, 1, 0, -96, 12, 100, 101, 115, 99, 114, 105, 112, 116, 105, 111, 110, 0, 108, 105, 110, 101, 97, 114, 32, 98, 108, 117, 114, 32, 98, 121, 32, 97, 32, 108, 105, 110, 101, 32, 101, 113, 117, 97, 116, 105, 111, 110, 0, -95, 1, 2, 0, 0, 12, 95, 79, 117, 116, 67, 111, 111, 114, 100, 0, -95, 1, 3, 1, 0, 14, 108, 105, 110, 101, 69, 113, 117, 97, 116, 105, 111, 110, 0, -94, 3, 109, 105, 110, 86, 97, 108, 117, 101, 0, -65, -128, 0, 0, -65, -128, 0, 0, -62, -56, 0, 0, -94, 3, 109, 97, 120, 86, 97, 108, 117, 101, 0, 63, -128, 0, 0, 63, -128, 0, 0, 66, -56, 0, 0, -94, 3, 100, 101, 102, 97, 117, 108, 116, 86, 97, 108, 117, 101, 0, 63, 52, -3, -12, -65, 52, -3, -12, 65, -16, 0, 0, -95, 1, 1, 0, 0, 2, 117, 83, 99, 97, 108, 101, 0, -94, 1, 109, 105, 110, 86, 97, 108, 117, 101, 0, 0, 0, 0, 0, -94, 1, 109, 97, 120, 86, 97, 108, 117, 101, 0, 65, 32, 0, 0, -94, 1, 100, 101, 102, 97, 117, 108, 116, 86, 97, 108, 117, 101, 0, 63, -128, 0, 0, -95, 1, 1, 0, 0, 1, 118, 83, 99, 97, 108, 101, 0, -94, 1, 109, 105, 110, 86, 97, 108, 117, 101, 0, 0, 0, 0, 0, -94, 1, 109, 97, 120, 86, 97, 108, 117, 101, 0, 65, 32, 0, 0, -94, 1, 100, 101, 102, 97, 117, 108, 116, 86, 97, 108, 117, 101, 0, 63, -128, 0, 0, -93, 0, 4, 115, 114, 99, 0, -95, 2, 4, 2, 0, 15, 100, 115, 116, 0, 29, 1, 0, 16, 1, 0, 0, 0, 3, 1, 0, 16, 0, 0, 0, 0, 29, 3, 0, -128, 1, 0, 64, 0, 3, 3, 0, -128, 0, 0, 64, 0, 29, 3, 0, 64, 1, 0, -64, 0, 1, 3, 0, 64, 3, 0, 0, 0, 29, 1, 0, 16, 3, 0, 64, 0, 1, 1, 0, 16, 1, 0, -128, 0, 29, 3, 0, -128, 1, 0, -64, 0, 50, 1, 0, 16, 60, 35, -41, 10, 3, 3, 0, -128, 1, 0, -64, 0, 29, 3, 0, 97, 3, 0, 0, 0, 3, 3, 0, 97, 1, 0, 16, 0, 29, 4, 0, -63, 3, 0, 96, 0, 29, 3, 0, 97, 0, 0, -96, 0, 3, 3, 0, 97, 4, 0, 16, 0, 29, 4, 0, 49, 3, 0, 96, 0, 29, 3, 0, 97, 0, 0, 16, 0, 1, 3, 0, 97, 4, 0, -80, 0, 49, 5, 0, -15, 3, 0, 96, 0, 29, 3, 0, 97, 0, 0, 16, 0, 2, 3, 0, 97, 4, 0, -80, 0, 49, 6, 0, -15, 3, 0, 96, 0, 29, 7, 0, -13, 5, 0, 27, 0, 1, 7, 0, -13, 6, 0, 27, 0, 29, 2, 0, -13, 7, 0, 27, 0, 29, 3, 0, 64, 4, 0, 64, 0, 50, 1, 0, 16, 0, 0, 0, 0, 2, 1, 0, 16, 4, 0, 0, 0, 29, 3, 0, 32, 1, 0, -64, 0, 29, 5, 0, -63, 0, 0, -16, 0, 3, 5, 0, -63, 3, 0, 96, 0, 29, 4, 0, 49, 5, 0, 16, 0, 29, 3, 0, 97, 0, 0, 16, 0, 1, 3, 0, 97, 4, 0, -80, 0, 49, 5, 0, -15, 3, 0, 96, 0, 29, 3, 0, 97, 0, 0, 16, 0, 2, 3, 0, 97, 4, 0, -80, 0, 49, 6, 0, -15, 3, 0, 96, 0, 29, 7, 0, -13, 5, 0, 27, 0, 1, 7, 0, -13, 6, 0, 27, 0, 1, 2, 0, -13, 7, 0, 27, 0, 50, 1, 0, 16, 62, -128, 0, 0, 3, 2, 0, -13, 1, 0, -1, 0]);
		
	}

}