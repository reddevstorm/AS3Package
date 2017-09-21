package org.libspark.ui
{
	import flash.display.*;
	import flash.events.*;
	import flash.external.*;
	import flash.system.*;
	
	public class SWFWheel extends Object
	{
		public static const DEFINE_LIBRARY_FUNCTION:String = "function(){if(window.SWFWheel)return;var win=window,doc=document,nav=navigator;var SWFWheel=window.SWFWheel=function(id){this.setUp(id);if(SWFWheel.browser.msie)this.bind4msie();else this.bind();};SWFWheel.prototype={setUp:function(id){var el=SWFWheel.retrieveObject(id);if(el.nodeName.toLowerCase()==\'embed\'||SWFWheel.browser.safari)el=el.parentNode;this.target=el;this.eventType=SWFWheel.browser.mozilla?\'DOMMouseScroll\':\'mousewheel\';},bind:function(){this.target.addEventListener(this.eventType,function(evt){var target,name,delta=0;if(/XPCNativeWrapper/.test(evt.toString())){var k=evt.target.getAttribute(\'id\')||evt.target.getAttribute(\'name\');if(!k)return;target=SWFWheel.retrieveObject(k);}else{target=evt.target;}name=target.nodeName.toLowerCase();if(name!=\'object\'&&name!=\'embed\')return;if(!target.checkBrowserScroll()){evt.preventDefault();evt.returnValue=false;}if(!target.triggerMouseEvent)return;switch(true){case SWFWheel.browser.mozilla:delta=-evt.detail;break;case SWFWheel.browser.opera:delta=evt.wheelDelta/40;break;default:delta=evt.wheelDelta/80;break;}target.triggerMouseEvent(delta);},false);},bind4msie:function(){var _wheel,_unload,target=this.target;_wheel=function(){var evt=win.event,delta=0,name=evt.srcElement.nodeName.toLowerCase();if(name!=\'object\'&&name!=\'embed\')return;if(!target.checkBrowserScroll())evt.returnValue=false;if(!target.triggerMouseEvent)return;delta=evt.wheelDelta/40;target.triggerMouseEvent(delta);};_unload=function(){target.detachEvent(\'onmousewheel\',_wheel);win.detachEvent(\'onunload\',_unload);};target.attachEvent(\'onmousewheel\',_wheel);win.attachEvent(\'onunload\',_unload);}};SWFWheel.browser=(function(ua){return{version:(ua.match(/.+(?:rv|it|ra|ie)[/:\\s]([\\d.]+)/)||[0,\'0\'])[1],chrome:/chrome/.test(ua),stainless:/stainless/.test(ua),safari:/webkit/.test(ua)&&!/(chrome|stainless)/.test(ua),opera:/opera/.test(ua),msie:/msie/.test(ua)&&!/opera/.test(ua),mozilla:/mozilla/.test(ua)&&!/(compatible|webkit)/.test(ua)}})(nav.userAgent.toLowerCase());SWFWheel.join=function(id){var t=setInterval(function(){if(SWFWheel.retrieveObject(id)){clearInterval(t);new SWFWheel(id);}},0);};SWFWheel.force=function(id){if(SWFWheel.browser.safari||SWFWheel.browser.stainless)return true;var el=SWFWheel.retrieveObject(id),name=el.nodeName.toLowerCase();if(name==\'object\'){var k,v,param,params=el.getElementsByTagName(\'param\'),len=params.length;for(var i=0;i<len;i++){param=params[i];if(param.parentNode!=el)continue;k=param.getAttribute(\'name\');v=param.getAttribute(\'value\')||\'\';if(/wmode/i.test(k)&&/(opaque|transparent)/i.test(v))return true;}}else if(name==\'embed\'){return/(opaque|transparent)/i.test(el.getAttribute(\'wmode\'));}return false;};SWFWheel.retrieveObject=function(id){var el=doc.getElementById(id);if(!el){var nodes=doc.getElementsByTagName(\'embed\'),len=nodes.length;for(var i=0;i<len;i++){if(nodes[i].getAttribute(\'name\')==id){el=nodes[i];break;}}}return el;};}";
		public static const CHECK_FORCE_EXTERNAL_FUNCTION:String = "SWFWheel.force";
		public static const EXECUTE_LIBRARY_FUNCTION:String = "SWFWheel.join";
		private static var _item:InteractiveObject;
		public static const VERSION:String = "1.2 alpha";
		private static var _event:MouseEvent;
		private static var _browserScroll:Boolean = false;
		private static var _stage:Stage;
		
		public function SWFWheel()
		{
			return;
		}// end function
		
		public static function set browserScroll(objectID:Boolean) : void
		{
			_browserScroll = objectID;
			return;
		}// end function
		
		public static function get available() : Boolean
		{
			var f:Boolean;
			if (!ExternalInterface.available)
			{
				return f;
			}
			try
			{
				f = Boolean(ExternalInterface.call("function(){return true;}"));
			}
			catch (e:Error)
			{
				//trace("Warning: turn off SWFWheel because can\'t access external interface.");
			}
			return f;
		}// end function
		
		private static function triggerMouseEvent(objectID:Number) : void
		{
			if (_event == null || _item == null)
			{
				return;
			}
			var _loc_2:* = new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, _event.localX, _event.localY, _event.relatedObject, _event.ctrlKey, _event.altKey, _event.shiftKey, _event.buttonDown, int(objectID));
			_item.dispatchEvent(_loc_2);
			return;
		}// end function
		
		private static function mouseMoved(event:MouseEvent) : void
		{
			_item = InteractiveObject(event.target);
			_event = MouseEvent(event);
			return;
		}// end function
		
		private static function checkBrowserScroll() : Boolean
		{
			return _browserScroll;
		}// end function
		
		public static function get browserScroll() : Boolean
		{
			return _browserScroll;
		}// end function
		
		public static function initialize(objectID:Stage) : void
		{
			if (!available || isReady)
			{
				return;
			}
			_stage = objectID;
			ExternalInterface.call(DEFINE_LIBRARY_FUNCTION);
			ExternalInterface.call(EXECUTE_LIBRARY_FUNCTION, ExternalInterface.objectID);
			ExternalInterface.addCallback("checkBrowserScroll", checkBrowserScroll);
			var _loc_2:* = Boolean(Capabilities.os.toLowerCase().indexOf("mac") !== -1);
			var _loc_3:* = Boolean(ExternalInterface.call(CHECK_FORCE_EXTERNAL_FUNCTION, ExternalInterface.objectID));
			if (!_loc_2 && !_loc_3)
			{
				return;
			}
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoved);
			ExternalInterface.addCallback("triggerMouseEvent", triggerMouseEvent);
			return;
		}// end function
		
		public static function get isReady() : Boolean
		{
			return _stage != null;
		}// end function
		
	}
}