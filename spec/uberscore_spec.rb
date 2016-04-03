require_relative "../lib/uberscore"
require "pry"

describe Uberscore do
  it "works" do
    expect(%w[A B C].map(&_.downcase)).to eq(%w[a b c])
  end

  it "chains method calls" do
    expect(%w[0x 0d ea].map(&_.hex.divmod(13)[1] == 0)).to eq(%w[0x 0d ea].map { |element| element.hex.divmod(13)[1] == 0 })
  end

  it "can call ::new" do
    expect([Array, Hash].map(&_.new(4))).to eq([Array, Hash].map { |a_class| a_class.new(4) })
  end

  it "can be nested" do
    expect([[2, 3]].map(&_.map(&_ * 2))).to eq([[2, 3]].map { |array| array.map { |element| element * 2 } })
  end

  it "can subscript" do
    expect([{ name: "foo" }, { name: "bar" }].map(&_[:name])).to eq([{ name: "foo" }, { name: "bar" }].map { |hash| hash[:name] })
  end

  it "works with two or more underscores" do
    expect((_ + _).to_proc.call(3)).to eq 3 + 3
    expect((_ + _*_).to_proc.call(3)).to eq 3 + 3*3
  end
end
