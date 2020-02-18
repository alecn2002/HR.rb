# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Hand
  attr_reader :cards

  def initialize(cards_str)
    @cards = cards_str.split(' ').collect {|c| Card.new(c) }
  end
  
  
end
