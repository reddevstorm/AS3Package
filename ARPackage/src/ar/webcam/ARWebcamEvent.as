package ar.webcam
{
	import flash.events.Event;
	
	public class ARWebcamEvent extends Event
	{
		public static const THERE_IS_NO_CAM		:String = "THERE_IS_NO_CAM";
		public static const REFUCE_USING_CAM	:String = "REFUCE_USING_CAM";
		public static const ACCEPT_USING_CAM	:String = "ACCEPT_USING_CAM";
//		public static const SUCCESS_CONNECT		:String = "SUCCESS_CONNECT";
		public static const FAIL_CONNECT		:String = "FAIL_CONNECT";
		public static const ACTIVE_CAM			:String = "ACTIVE_CAM";
		
		public function ARWebcamEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}