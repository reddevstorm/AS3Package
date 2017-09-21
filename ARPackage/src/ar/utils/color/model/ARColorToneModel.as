package ar.utils.color.model 
{
	/**
	 * ...
	 * @author ...
	 */
	public class ARColorToneModel 
	{
		public var colorTone	:String = "";
		public var R			:uint = 0;
		public var G			:uint = 0;
		public var B			:uint = 0;
		
		public function ARColorToneModel($colorTone:String, $r:uint, $g:uint, $b:uint) 
		{
			colorTone = $colorTone;
			R = $r;
			G = $g;
			B = $b;
		}
		
	}

}