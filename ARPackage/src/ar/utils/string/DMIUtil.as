package ar.utils.string
{
	import flash.utils.escapeMultiByte;
	import flash.utils.unescapeMultiByte;
	
	/**
	 * <p>AS3/PHP Encode and Decode method.</p>
	 * 
	 * @author 우야꼬 (victim4@gmail.com) www.as3.kr
	 * 
	 */
	public class DMIUtil
	{
		/**
		 * 
		 * It may help you. To communication between Flash and PHP, Special Character or Non-English language is not matching. <br>
		 * So, to use this encode and decode method to convert for transferable character can match. <br>
		 * In Flash, input string to DMIUtil.urlencode() method. then store returned value. <br>
		 * Finally, returned value can sending for http parameter to php file. <br>
		 * 
		 * @param str String for output parameter of URLRequest.
		 * @return Converted String from input String.
		 * 
		 */
		public static function urlencode(str:String):String
		{
			var rtn:String = str;
			
			rtn = escapeMultiByte(rtn);
			rtn = rtn.replace(/%20/g, "+");
			
			return rtn;
		}
		
		/**
		 * 
		 * If you receive a string from php, you have to convert to use correct.
		 * 
		 * @param str String be came from php output.
		 * @return String can use in flash.
		 * 
		 */
		public static function urldecode(str:String):String
		{
			var rtn:String = str;
			
			rtn = rtn.replace(/\+/g, "%20");
			rtn = unescapeMultiByte(rtn);
			
			return rtn;
		}
	}
}