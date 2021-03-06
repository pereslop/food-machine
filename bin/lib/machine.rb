require 'colorize'

class Machine
  AVAILABLE_PAPERS = {
    '1g': 100,
    '2g': 200,
    '5g': 500,
    '10g': 1000,
  }.freeze

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
    100 => 40
  }.freeze

  PEPCI = { possition: "1a", price: 200, amount: 1, name: "PEPCI" }
  COLA = { possition: "1b", price: 250, amount: 5, name: "COLA" }
  SPRITE = {possition: "1c", price: 300, amount: 5, name: "SPRITE" }
  BOUNTY = { possition: "2a", price: 200, amount: 10, name: "BOUNTY" }
  SNIKERS = { possition: "2b", price: 500, amount: 10, name: "SNIKERS" }
  TWIX = { possition: "2c", price: 600, amount: 10, name: "TWIX" }

  AVAILABLE_PRODUCTS = [PEPCI, COLA, SPRITE, BOUNTY, SNIKERS, TWIX, BOUNTY]

  ALLOWED_MONEY = AVAILABLE_COINS.merge(AVAILABLE_PAPERS).freeze

  class << self
    attr_accessor :balance, :input, :products, :wallet
  end

  def self.start
    self.products = AVAILABLE_PRODUCTS.map { |product| Product.new(product) }
    self.wallet = CHANGE_MONEY
  end

  def self.input_money
    input = gets.chomp.downcase.to_sym
    self.balance ||= 0
    self.balance += ALLOWED_MONEY.fetch(input, 0)
    puts "Balance: #{human_balance}".underline.green
    puts 'press continue(C) to choose the product or input more money'

    if input == :c
      chose_product
    elsif ALLOWED_MONEY.keys.include?(input)
      input_money
    else
      puts 'wrong input'.red
      input_money
    end
  end

  def self.chose_product
    chose_products_message

    possition = gets.chomp.downcase
    if available_products.any? { |product| product.possition == possition }
      product = Product.find(products, possition)
      get_product(product)
    else
      puts 'WRONG POSSITON. try to select again'.red
    end
  end

  def self.get_product(product)
    if self.balance >= product.price
      self.loader_message
      puts "take your #{product.name}".green
      self.update_products(product)
      self.update_balance(product.price)
    else
      puts 'you do not have enough money, please put more'
      input_money
    end
  end

  def self.human_balance
    "#{balance.fdiv(100)} gryvna"
  end

  def self.available_products 
    products.select(&:available?)
  end

  def self.update_products(product)
    self.products = self.products.reject { |p| p == product }
    product.amount = product.amount - 1
    self.products << product
  end

  def self.chose_products_message
    puts 'please chose product, available products:'
    self.available_products.each do |product|
      puts "#{product.name}: ".underline + product.possition.blue.bold + ", price: #{product.human_price}"
    end
  end

  def self.update_balance(amount)
    self.balance -= amount
    puts "your balance is #{human_balance}".green
    puts 'you can return(r) money or continue(c) shopping'
    input = gets.chomp.downcase.to_sym
    case input
    when :r
      return_money
    when :c
      input_money
    else
      puts 'wrong input'.red
      Machine.update_balance(0)
    end
  end

  def self.return_money
    change = {}
    new_wallet = wallet.sort_by {|k, _| -k }.reduce({}) do |memo, (coin, amount)|
      if amount.zero? || coin > self.balance
        memo[coin] = amount
      else
        loop do
          memo[coin] = memo.fetch(coin, amount)
          break unless self.balance >= coin && memo[coin].nonzero?

          self.balance = self.balance - coin
          change[coin] = change.fetch(coin, 0) + 1
          memo[coin] = memo.fetch(coin) - 1
        end
      end
      memo
    end

    self.wallet = new_wallet
    change_message(change)
    self.input_money
  end

  def self.loader_message
    80.times do
      putc '.'
      sleep 0.005
    end
  end

  def self.change_message(change)
    puts 'TAKE YOUR MONEY'.green
    change.each do |coin, amount|
      amount.times { self.loader_message; puts " -  #{ coin == 100 ? '1 gryvja' : "#{coin} coins"}".red }
    end
    puts 'not enough cash to change, you can by something else' if self.balance.positive?
    puts self.wallet
  end
end
