# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Enumerable
  def inject_with_index(initial)
    each_index {|i| initial = yield(initial, self[i], i)}
    initial
  end
end

class Array
  def to_indexed_hash
    inject_with_index({}) {|r, v, i| r.update(v => i); r }
  end
end

class Card
  
  RANK_SORT_ORDER = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].to_indexed_hash
  SUIT_SORT_ORDER = 'DSCH'.split('').to_indexed_hash
  
  attr_reader :rank, :suit, :rank_order, :suit_order
  
  def initialize(str)
    @rank, @suit = str[0...-1], str[-1..-1]
    @rank_order, @suit_order = RANK_SORT_ORDER[rank], SUIT_SORT_ORDER[suit]
  end
  
  def compare_by(other, *comp_orders)
    comp_orders.each {|field|
        cmp = send(field) <=> other.send(field)
        return cmp unless cmp == 0
    }
    0
  end
  
  def rank_order
    RANK_SORT_ORDER[rank]
  end
  
  def suit_order
    SUIT_SORT_ORDER[suit]
  end
  
  def compare_by_rank(other)
    compare_by(other, :rank)
  end
  
  def compare_by_suit(other)
    compare_by(other, :suit)
  end
  
  def compare_by_rank_suit(other)
    compare_by(other, :rank, :suit)
  end
  
  def compare_by_suit_rank(other)
    compare_by(other, :suit, :rank)
  end
end
