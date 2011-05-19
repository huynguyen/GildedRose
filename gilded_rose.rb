require './item.rb'

class GildedRose
  attr_accessor :items

  @items = []

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  #Update this method
  def update_quality
    list = @items.reject { |item| item.name =~ /Sulfuras, Hand of Ragnaros/ }
    list.reject! { |item| item.quality >= 50 }
   
    list.each do |item|
      case item.name
      when  /Brie/i
        updateable?(item.quality, 1) ? item.quality = 50 : item.quality += 1
      when /backstage passes/i
        case item.sell_in
        when 0
          item.quality = 0
        when 1...5
          updateable?(item.quality, 3) ? item.quality = 50 : item.quality += 3
        when 6...10
          updateable?(item.quality, 2) ? item.quality = 50 : item.quality += 2
        else
          updateable?(item.quality, 1) ? item.quality = 50 : item.quality += 1
        end
      when /conjured/i
        case item.sell_in
        when item.sell_in <= 0
          item.quality -= 4
        else
          item.quality -= 2
        end
      else
        item.quality -= 1
      end
    end
  end

  def updateable?(item_value, tickv)
    item_value + tickv >= 50
  end
end
