class Range
    def shift(n)
        exclude_end? ? (first+n ... last+n) : (first+n .. last+n)
    end

    alias __cover? cover?

    def cover?(v)
        return __cover?(v) unless v.kind_of?(Range)
        return false if empty? || v.empty?
        __cover?(v.first) && __cover?(v.last - (v.exclude_end? ? 1 : 0))
    end

    def split_to_halves
      return nil if size <= 1
      mid = first + size / 2
      [(first ... mid), (exclude_end? ? (mid ... last) : (mid .. last))]
    end

    def empty?
      size <= 0
    end

    def intersect?(other)
      return false if empty? || other.empty?
      cover?(other) || [first, last - (exclude_end? ? 1 : 0)].any? {|v| other.__cover?(v) }
    end
end

module Enumerable

  def self._def_f(sym)
    ssym = sym.to_s
    last_char = ssym.end_with?('?', '!') ? ssym[-1] : ""
    fname = [ssym[0 .. -1 - last_char.size], last_char].join("f")
    to_eval = "def #{fname}(fun, *args); #{ssym} {|v| v.send(fun, *args)}; end"
    eval(to_eval)
  end

  def self.def_f(*args)
    args.each {|n| self._def_f(n)}
  end

  def_f :map, :all?, :any?, :each

  alias collectf mapf

end

class Array

    def to_range
        (min .. max)
    end
end

class SegmentTree

  def self.node_factory(st, range)
    return nil if range.empty?

    ((range.size == 1) ? SegmentTreeLeafNode : SegmentTreeNode).new(st, range)
  end

  class SegmentTreeLeafNode
    attr_reader :st, :range

    def initialize(st, range)
      @st, @range = st, range
    end

    def get(r)
#      $stderr << "SegmentTreeLeafNode{range=#{range}} # get(#{r})\n"
      return nil unless range.intersect?(r)
#      $stderr << "    intersects\n"
      return st.ar[range.first]
    end

    def update!(*args)

    end
  end

    class SegmentTreeNode
        attr_reader :st, :range, :val
        attr_reader :children

        def initialize(st, range)
#          $stderr << "ar=#{ar} range=#{range}\n"
          range_spl = range.split_to_halves
          @st, @range, @children, @val = st, range, (range_spl.nil? ? [] : range_spl.map {|r| SegmentTree.node_factory(st, r) }.compact), nil
        end

        def get(r)
#          $stderr << "SegmentTreeNode{range=#{range}} # get(#{r})\n"
          return nil unless r.intersect?(range)
#          $stderr << "    intersects\n"
          if r.cover?(range) then
            return val unless val.nil?
#            $stderr << "    @val is nil, recalc-ing\n"
#            @val = st.fun.call( children.mapf(:get, r).compact )
            @val = children.mapf(:get, r).compact.min
          else
#            $stderr << "   Partial coverage\n"
#            st.fun.call( children.mapf(:get, r).compact )
            children.mapf(:get, r).compact.min
          end
        end

        def update!(r)
            return nil unless range.cover?(r)
            @val = nil
            children.eachf(:update!, r)
        end

        def to_s(level = 0)
          "#{" "*2*level}SegmentTreeNode range = #{range} #{ children.mapf(:to_s, level+1).join("\n")}"
        end
    end

    attr_reader :ar, :tree, :fun

    def initialize(ar, fun)
        @ar, @fun = ar, fun
        @tree = SegmentTree.node_factory(self, (0...ar.size))

#      $stderr << "Tree: #{tree}\n\n"
    end

    def get(range)
#      $stderr << "SegmentTree#get(#{range})\n"

      return nil if range.size < 1
      return ar[range.first] if range.size == 1
      tree.get(range)
    end

    def update!(r, v)
      ar[r] = v
      tree.update!(r)
    end
end

class MinSegmentTree < SegmentTree
    def initialize(ar)
        super(ar, lambda {|v| v.min } )
    end
end

if __FILE__ == $0 then
n, q = readline.strip.split(' ').mapf(:to_i)
st = MinSegmentTree.new(readline.strip.split(' ').mapf(:to_i))

readlines.each {|l|
    spl = l.strip.split(' ')
    xy = spl[1..2].mapf(:to_i)
    case spl.first
        when 'q'
            puts st.get( xy.to_range.shift(-1) )
        when 'u'
            st.update!( xy.first-1, xy.last )
        else
            $stderr >> "Unknown command '#{spl.first}'\n"
    end
}
end

