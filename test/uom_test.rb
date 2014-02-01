#require 'test_helper'
require 'minitest/autorun'
require 'fast-units'

describe 'FastUnits::Uom' do
  it "can parse mg" do
    uom = FastUnits::Uom.new('mg')
    assert_equal 'mg', uom.to_s
  end

  it "can parse ml" do
    uom = FastUnits::Uom.new('ml')
    assert_equal 'ml', uom.to_s
  end

  it "can make a simple mixture" do
    uom = FastUnits::Uom.new('mg/ml')
    assert_equal uom.num, ['mg']
    assert_equal uom.denom, ['ml']
    assert_equal 'mg/ml', uom.to_s
  end

  it "can make a simple mixture with complicated numerator" do
    uom = FastUnits::Uom.new('unit*mg/ml')
    assert_equal uom.num, ['unit','mg']
    assert_equal uom.denom, ['ml']
    assert_equal 'unit*mg/ml', uom.to_s
  end

  it "can condense units" do
    uom = FastUnits::Uom.new('mg*mg/ml')
    assert_equal uom.num, ['mg','mg']
    assert_equal uom.denom, ['ml']
    assert_equal 'mg^2/ml', uom.to_s
  end

  it "can multipy simple units" do
    uom = FastUnits::Uom.new('mg') * FastUnits::Uom.new('unit')
    assert_equal uom.num, ['mg','unit']
    assert_equal uom.denom, []
    assert_equal 'mg*unit', uom.to_s
  end

  it "can multipy two of the same units" do
    uom = FastUnits::Uom.new('mg') * FastUnits::Uom.new('mg')
    assert_equal uom.num, ['mg','mg']
    assert_equal uom.denom, []
    assert_equal 'mg^2', uom.to_s
  end

  it "can divide simple units" do
    uom = FastUnits::Uom.new('mg') / FastUnits::Uom.new('ml')
    assert_equal uom.num, ['mg']
    assert_equal uom.denom, ['ml']
    assert_equal 'mg/ml', uom.to_s
  end

  it "can divide two of the same units" do
    uom = FastUnits::Uom.new('mg') / FastUnits::Uom.new('ml') / FastUnits::Uom.new('ml')
    assert_equal uom.num, ['mg']
    assert_equal uom.denom, ['ml', 'ml']
    assert_equal 'mg/ml^2', uom.to_s
  end

  it "can handle exponents" do
    uom = FastUnits::Uom.new('mg/ml^2')
    assert_equal uom.num, ['mg']
    assert_equal uom.denom, ['ml','ml']
    assert_equal 'mg/ml^2', uom.to_s
  end

  it "can reduce from exponents" do
    uom = FastUnits::Uom.new('mg/ml^2')
    u2 = uom * FastUnits::Uom.new('ml')
    assert_equal 'mg/ml', u2.to_s
  end

  it "can simplify duplicate units" do
    uom = FastUnits::Uom.new('mg') * FastUnits::Uom.new('ml') / FastUnits::Uom.new('ml')
    assert_equal uom.num, ['mg']
    assert_equal uom.denom, []
    assert_equal 'mg', uom.to_s
  end
end