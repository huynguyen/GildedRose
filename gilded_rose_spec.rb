require './gilded_rose.rb'
require "rspec"

describe GildedRose do

  context "Single Item" do
    subject do
      rose = GildedRose.new
      rose.items.clear
      rose
    end

    def update_helper(elapse_time=1)
      org_item = subject.items.first.dup
      elapse_time.times do
        subject.update_quality
      end
      updated_item = subject.items.first
      return org_item, updated_item
    end

    context "Regular Type Item" do
      before(:each) do
        subject.items << Item.new("Regular Item", 5, 25)
      end

      context "before sell date" do
        let!(:before_date) do
          subject.items.first.sell_in = 10
        end
        it "should decrease in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality-1
        end
        it "should decrease in sell_in" do
          org_item, updated_item = update_helper
          updated_item.sell_in.should eq org_item.sell_in-1
        end
      end

      context "on sell date" do
        let!(:sell_date) {subject.items.first.sell_in = 0}
        it "should decrease in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality-1
        end
        it "should decrease in sell_in" do
          org_item, updated_item = update_helper
          updated_item.sell_in.should eq org_item.sell_in-1
        end
      end

      context "after sell date" do
        let!(:after_date) {subject.items.first.sell_in = -10}
        it "should decrease in quality twice as fast" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality-2
        end
        it "should decrease in sell_in" do
          org_item, updated_item = update_helper
          updated_item.sell_in.should eq org_item.sell_in-1
        end
      end

      context "at min quality" do
        let!(:max_quality) {subject.items.first.quality = 0}
        it "should have quality 0" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq 0
        end
      end
    end

    context "Cheese Type Item" do
      before(:all) do
        subject.items << Item.new("Aged Brie", 2, 0)
      end
      context "before sell date" do
        let!(:before_date) {subject.items.first.sell_in = 10}
        it "should increase in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality+1
        end
      end
      context "on sell date" do
        let!(:sell_date) {subject.items.first.sell_in = 0}
        it "should increase in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality+1
        end
      end
      context "after sell date" do
        let!(:after_date) {subject.items.first.sell_in = -10}
        it "should increase in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality+1
        end
      end
      context "at max quality" do
        let!(:max_quality) {subject.items.first.quality = 50}
        it "should have quality stay at 50" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq 50
        end
      end

    end

    context "Conjured Type Item" do
      before(:each) do
        subject.items << Item.new("Conjured Mana Cake", 3, 6)
      end
      context "before sell date" do
        let!(:before_date) {subject.items.first.sell_in = 10}
        it "should decrease in quality twice as fast" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality-2
        end
      end
      context "on sell date" do
        let!(:sell_date) {subject.items.first.sell_in = 0}
        it "should have decrease in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality-4
        end
      end
      context "after sell date" do
        let!(:after_date) {subject.items.first.sell_in = -10}
        it "should decrease in quality 4x as fast" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality-4
        end
      end
    end

    context "Legendary Type Item" do
      before(:each) do
        subject.items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
      end
      context "before sell date" do
        let!(:before_date) {subject.items.first.sell_in = 10}
        it "should not change in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality
        end
      end
      context "on sell date" do
        let!(:sell_date) {subject.items.first.sell_in = 0}
        it "should not change in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality
        end
      end
      context "after sell date" do
        let!(:after_date) {subject.items.first.sell_in = -10}
        it "should not change in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality
        end
      end
    end

    context "Backstage Pass Type Item" do
      before(:each) do
        subject.items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
      end
      context "More then 10 days before sell date" do
        let!(:early_date) {subject.items.first.sell_in = 50}
        it "should increase in quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality+1
        end
      end
      context "10 days before sell date" do
        let!(:before_date) {subject.items.first.sell_in = 10}
        it "should increase in quality by 2" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality+2 
        end
      end
      context "5 days before sell date" do
        let!(:sell_date) {subject.items.first.sell_in = 5}
        it "should increase in quality by 3" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq org_item.quality+3
        end
      end
      context "after sell date" do
        let!(:after_date) {subject.items.first.sell_in = -10}
        it "should have zero quality" do
          org_item, updated_item = update_helper
          updated_item.quality.should eq 0
        end
      end
    end
  end

  context "Default Items" do
    it "should update default items" do
      result_items = []
      result_items << Item.new("+5 Dexterity Vest", 9, 19)
      result_items << Item.new("Aged Brie", 1, 1)
      result_items << Item.new("Elixir of the Mongoose", 4, 6)
      result_items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
      result_items << Item.new("Backstage passes to a TAFKAL80ETC concert", 14, 21)
      result_items << Item.new("Conjured Mana Cake", 2, 4)
      subject.update_quality
      subject.items.each_with_index do |item, n|
        item.quality.should == result_items[n].quality
        item.sell_in.should == result_items[n].sell_in
      end
    end
  end
end
