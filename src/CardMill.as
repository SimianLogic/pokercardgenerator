package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	[SWF(width='1024', height='768', backgroundColor='#555555')]
	public class CardMill extends Sprite
	{
		
		public function CardMill()
		{
			var all_suits:Array = [Spade, Club, Heart, Diamond];
			var labels:Array = ["A","2","3","4","5","6","7","8","9","10","J","Q","K"];
			var card_width:Number = stage.stageWidth / 13;
			for(var i:int = 0; i < 4; i++)
			{
				for(var j:int = 0; j < 13; j++)
				{
					var card:LayoutClassic = new LayoutClassic();
					
					card.width = card_width;
					card.scaleY = card.scaleX;
					
					card.gotoAndStop(j+1);
					addChild(card); 
					card.x = card.width * j;
					card.y = card.height * i;
					
					var suits:Array = findChildren(card, "suit");
					var jacks:Array = findChildren(card, "jack");
					var queens:Array = findChildren(card, "queen");
					var kings:Array = findChildren(card, "king");
					var values:Array = findChildren(card, "value");
					
					trace("VALUES: " + values.length);
					for each(var tf:TextField in values)
					{
						tf.text = labels[j];
					}
					
					for each(var suit:MovieClip in suits)
					{
						var suit_width:Number = suit.width;
						
						var suit_klass:Class = all_suits[i];
						var suit_clip:Bitmap = new Bitmap(new suit_klass());
						
						sizeDOtoDO(suit, suit_clip);
						
						suit.parent.addChild(suit_clip);
						suit.visible = false;
						
						suit_clip.x = suit.x;
						suit_clip.y = suit.y;
					}
					
					//TODO: recursively find any children named jack/queen/king and set the graphic
				}
			}
		}
		
		public static function sizeDOtoDO(baseClip:DisplayObject, newClip:DisplayObject):void
		{
			var w_aspect:Number = baseClip.width / newClip.width;
			var h_aspect:Number = baseClip.height / newClip.height;
			
			var aspect:Number = Math.min(w_aspect, h_aspect);
			newClip.scaleX = aspect;
			newClip.scaleY = aspect;
		}
		
		//move this to a helper
		public static function findChildren(container:DisplayObjectContainer, name:String):Array
		{
			var found:Array = [];
			for(var i:int = 0; i < container.numChildren; i++)
			{
				if(container.getChildAt(i).hasOwnProperty("name"))
				{
					trace("NAME: " + container.getChildAt(i).name);
					if(container.getChildAt(i).name == name)
					{
						found.push(container.getChildAt(i));
						trace("FOUND LENGTH: " + found.length);
					}
				}
				
				if(container.getChildAt(i) is DisplayObjectContainer)
				{
					found = found.concat(findChildren(container.getChildAt(i) as DisplayObjectContainer, name));
					trace("+ CONCAT = " + found.length);
				}
			}
			
			trace("RETURNING " + found.length);
			return found;
		}
	}
}