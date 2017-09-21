package ar 
{
	
	import flash.display.DisplayObjectContainer;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.system.System;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
//	import org.libspark.ui.SWFWheel;

	public class AllSetting
	{
		public function AllSetting()
		{
		}
		public static function stage_normal($stage:DisplayObjectContainer) : void
		{
			$stage.stage.align = StageAlign.TOP_LEFT;
			$stage.stage.scaleMode = StageScaleMode.NO_SCALE;
			$stage.stage.quality = StageQuality.BEST;
			
			$stage.stage.stageFocusRect = false;
			$stage.stage.tabChildren = true;
			//$stage.mouseEnabled = false;
			$stage.tabEnabled = false;
			
			
//			SWFWheel.initialize($stage.stage);
//			SWFWheel.browserScroll = true;
			
			
		}
		public static function setting($stage:DisplayObjectContainer):void
		{
//			AppData.ISLOCAL = !($stage.loaderInfo.url.substr(0,4)=="http");
			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			var top_title	:ContextMenuItem = new ContextMenuItem("INNISFREE");
			var c_url		:ContextMenuItem = new ContextMenuItem("Copy my video url");
			var c_code		:ContextMenuItem = new ContextMenuItem("Copy my video source code");
			var c_copyright	:ContextMenuItem = new ContextMenuItem("Copyright");
			
			c_copyright.enabled = top_title.enabled = false;
			c_copyright.separatorBefore =c_url.separatorBefore =  true;
			
			c_url.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void{
				
			});
			c_code.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:ContextMenuEvent):void{
				
			});
			
			cm.customItems.push(top_title, c_url, c_code, c_copyright);
			$stage.contextMenu = cm;
		}
		public static function security_all() : void
		{
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			System.useCodePage = false;
		}
		
	}
}