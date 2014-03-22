package pieces
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;
	
	public class PokerCard extends UIComponent
	{
		public static var SUITS:Array = [Spade, Club, Heart, Diamond];
		public static var VALUES:Array = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"];
		
		public static var SPADE:int = 0;
		public static var CLUB:int = 1;
		public static var HEART:int = 2;
		public static var DIAMOND:int = 3;
		
		private var card:MovieClip;
		
		private var _suit:int;
		private var _value:int;
		private var _layout:Class;
		
		public var suitGraphics:Array;
		
		
		private var _suitBitmapData:BitmapData;
		public function get suitBitmapData():BitmapData { return _suitBitmapData; }
		public function set suitBitmapData(new_data:BitmapData):void
		{
			_suitBitmapData = new_data;
			trace("SUIT BITMAP DATA = " + new_data);
			update();
		}
		
		
		public function PokerCard()
		{
			super();
			
			suitGraphics = [];
			
			setStyle("paddingLeft", 0);
			setStyle("paddingRight", 0);
			
		}
		
		public function clearSuits():void
		{
			while(suitGraphics.length > 0)
			{
				var kid:DisplayObject = suitGraphics.shift() as DisplayObject;
				kid.parent.removeChild(kid);
			}
		}
		
		public function get layout():Class
		{
			return _layout;
		}
		
		public function set layout(new_layout:Class):void
		{
			_layout = new_layout;
			
			if(card != null)
			{
				removeChild(card);
			}
			
			card = new new_layout();
			addChild(card);
			
			card.width = unscaledWidth;
			card.scaleY = card.scaleX;
			
			update();
		}
		
		public function get value():int
		{
			return _value;
		}
		
		public function set value(new_value:int):void
		{
			if(new_value == _value) return;
			_value = new_value;
			
			update();
		}
		
		public function get suit():int
		{
			return _suit;
		}
		
		public function set suit(new_suit:int):void
		{
			if(new_suit == _suit) return;
			_suit = new_suit;
			
			update();
		}
		
		private function update():void
		{
			if(card == null) return;
			
			clearSuits();
			card.gotoAndStop(_value);
			
			var suits:Array = findChildren(card, "suit");
			var values:Array = findChildren(card, "value");
			
			for each(var tf:TextField in values)
			{
				tf.text = VALUES[_value - 1];
			}
			
			for each(var suit:MovieClip in suits)
			{	
				var bitmap_data:BitmapData;
				if(_suitBitmapData == null)
				{
					trace("USE THE DEFAULT IMAGE FOR YOUR SUIT");
					var suit_klass:Class = SUITS[_suit];
					bitmap_data = new suit_klass();
				}else{
					bitmap_data = _suitBitmapData;
				}
				
				var suit_clip:Bitmap = new Bitmap(bitmap_data);
				sizeDOtoDO(suit, suit_clip);
				
				suit.parent.addChild(suit_clip);
				suitGraphics.push(suit_clip);
				
				suit.visible = false;
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(card != null)
			{
				card.width = unscaledWidth;
				card.scaleY = card.scaleX;
			}
			
		}
		
		
		
		//HELPERS
		public static function sizeDOtoDO(baseClip:DisplayObject, newClip:DisplayObject):void
		{
			trace("SIZE CLIP (" + newClip.width + "x" + newClip.height +") to fit within (" + baseClip.width + "x" + baseClip.height + ")");
			var w_aspect:Number = baseClip.width / newClip.width;
			var h_aspect:Number = baseClip.height / newClip.height;
			
			var aspect:Number = Math.min(w_aspect, h_aspect);
			newClip.scaleX = aspect;
			newClip.scaleY = aspect;
			
			newClip.x = baseClip.x + (baseClip.width - newClip.width)/2;
			newClip.y = baseClip.y + (baseClip.width - newClip.height)/2;
		}
		
		//move this to a helper
		public static function findChildren(container:DisplayObjectContainer, name_or_regex:*):Array
		{
			if(name_or_regex is String) return findChildrenByName(container, name_or_regex);
			if(name_or_regex is RegExp) return findChildrenByRegex(container, name_or_regex);
			
			return null;
		}
		
		public static function findChildrenByRegex(container:DisplayObjectContainer, pattern:RegExp):Array
		{
			var found:Array = [];
			for(var i:int = 0; i < container.numChildren; i++)
			{
				if(container.getChildAt(i).hasOwnProperty("name"))
				{
//					trace("TESTING " + pattern + "    ---> " + container.name + "     -----> " + container.name.search(pattern));
					if(container.getChildAt(i).name.search(pattern) != -1)
					{
						found.push(container.getChildAt(i));
					}
				}
				
				if(container.getChildAt(i) is DisplayObjectContainer)
				{
					found = found.concat(findChildrenByRegex(container.getChildAt(i) as DisplayObjectContainer, pattern));
				}
			}
			
			return found;
		}
		
		public static function findChildrenByName(container:DisplayObjectContainer, name:String):Array
		{
			var found:Array = [];
			for(var i:int = 0; i < container.numChildren; i++)
			{
				if(container.getChildAt(i).hasOwnProperty("name"))
				{
					if(container.getChildAt(i).name == name)
					{
						found.push(container.getChildAt(i));
					}
				}
				
				if(container.getChildAt(i) is DisplayObjectContainer)
				{
					found = found.concat(findChildrenByName(container.getChildAt(i) as DisplayObjectContainer, name));
				}
			}
			
			return found;
		}
	}
}