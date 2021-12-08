class Product
  attr_accessor :amount, :possition, :name, :price

  def initialize(options = {})
    @amount = options[:amount]
    @possition = options[:possition]
    @name = options[:name]
    @price = options[:price]
  end

  def available?
    @amount.positive?
  end

  def self.find(products, possition)
    products.find { |product| product.possition == possition }
  end

  def human_price
    [@price.fdiv(100), 'gryvna'].join(' ')
  end
end

AVAILABLE_COINS = {
  '10': 10,
  '25': 25,
  '50': 50,
  '100': 100
}.freeze

CHANGE_MONEY = {
  10 => 80,
  25 => 50,
  50 => 50,
  100 => 3
}.freeze
