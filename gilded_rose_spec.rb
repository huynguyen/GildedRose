require './gilded_rose.rb'
require "rspec"

describe GildedRose do

  #Add more items for greater test coverage
  #negative quality?
  it "should do something" do
    subject.update_quality
  end

  it "item quality should not be negative" do
    subject.items.each do |item|
      item.quality.should be >= 0
    end
  end

  it "item quality should not be > 50" do
    subject.items.each do |item|
      item.quality.should be <= 50 unless item.name == "Sulfuras, Hand of Ragnaros"
    end
  end

  it "bree should increase in quality" do
    brees = subject.items.select { |item| item.name == "Aged Brie" }
    brees.each do |bree|
      org_quality = bree.quality
      subject.update_quality
      bree.quality.should be > org_quality unless bree.quality == 50
    end
  end

  it "doube degrade post sell_in" do
    special_case = [/Sulfuras/i, /Brie/i, /conjured/i, /backstage passes/i]
    regular_items = subject.items.reject do |item|
      special_case.each do |thing|
        item =~ thing
      end
    end
    regular_items.each do |item|
      org_quality = item.quality
      subject.update_quality
      item.quality.should be == (org_quality - 2) if item.sell_in <= 0
    end
  end

  it "conjured item degrade twice as fast" do
    conjured = subject.items.select { |item| item.name =~ /conjured/i }
    conjured.each do |item|
      org_quality = item.quality
      subject.update_quality
      item.quality.should be == (org_quality - 2)
    end
  end

  it "backstage passes special case" do
    passes = subject.items.select { |item| item.name == "Backstage passes" }
    passes.each do |pass|
      org_quality = pass.quality
      subject.update_quality
      pass.quality.should be == (org_quality + 2) if pass.sell_in <= 10
      pass.quality.should be == (org_quality + 3) if pass.sell_in <= 5
      pass.quality.should be == 0 if pass.sell_in <= 0
    end
  end
end
