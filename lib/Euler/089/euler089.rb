class String
  ROMAN = {'I' => 1,
           'V' => 5,
           'X' => 10,
           'L' => 50,
           'C' => 100,
           'D' => 500,
           'M' => 1000 }

  def roman_to_i
    split('').collect {|s| 
      ROMAN[s] 
    }.inject([0, nil]) {|r, v|
      [r.first + v - ((!r.last.nil? && (r.last < v)) ? 2 * r.last : 0), v]
    }.first
  end  
end

class Integer
  
  class MagnitudeToRoman
    attr_reader :order
    
    def initialize(mag, chars)
    
      l1 = lambda {|r, ds|
        (r.last >= ds.first) ? [r.first + ds.last, r.last - ds.first] : r
      }

      l2 = lambda {|r, ds|
        [r.first + ds.last * (r.last / ds.first), r.last % ds.first]
      }
      chars = chars.split('')
      @order = [[9 * mag, chars.last + chars.first, l1],
                [5 * mag, chars[1],                 l1],
                [4 * mag, chars.last + chars[1],    l1],
                [    mag, chars.last,               l2]
      ]
    end
    
    def call(r)
      order.inject(r) {|r1, o|
        o.last.call(r1, o[0...-1])
      }
    end
  end
  
  MAG_ORDER = [ MagnitudeToRoman.new(100, "MDC"),
                MagnitudeToRoman.new(10,  "CLX"),
                MagnitudeToRoman.new(1,   "XVI"),
              ]
  
  def to_roman
    MAG_ORDER.inject(['M' * (self/1000), self % 1000]) {|r, mtr|
      mtr.call(r)
    }.first
  end
end

n = readline.to_i

n.times {
  puts readline.strip.roman_to_i.to_roman
}
