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
   
    list.each do |item|
      case item.name
      when  /Brie/i
        set_quality(item, 1)
      when /backstage passes/i
        case
        when item.sell_in <= 0
          item.quality = 0
        when item.sell_in <= 5
          set_quality(item, 3)
        when item.sell_in <= 10
          set_quality(item, 2)
        else
          set_quality(item, 1)
        end
      when /conjured/i
        case
        when item.sell_in <= 0
          set_quality(item, -4)
        else
          set_quality(item, -2)
        end
      else
        item.sell_in < 0 ? set_quality(item, -2) : set_quality(item, -1)
      end
      item.sell_in -= 1
    end
  end

  def set_quality(item, tickv)
    item.quality = case
    when (item.quality + tickv >= 50)
      50
    when (item.quality + tickv <= 0)
      0
    else
      item.quality + tickv
    end
  end
end
