require 'spanning_tree'

class PiligrimsNPortals < SpanningTree
  attr_reader :shrines_count
  
  def initialize(num_nodes, edges, shrines)
    super(num_nodes, edges)
    @shrines_count = shrines
  end
  
  def add_bi_dir!(weight, n1, n2)
    [[n1, n2], [n2, n1]].each {|(node1, node2)|
      @tree[node1] << edge_klass.new(weight, node2)
    }
  end
  
  def between(l, v, u)
    l < v && v <= u
  end
  
  def squeeze_non_shrines!
    non_shrines_count = tree.size - shrines_count
    (1 .. non_shrines_count).each {|d|
      cur_node = tree[tree.size - d]
      check = lambda {|nid| between(shrines_count, nid, cur_node.id) }
      cur_node.conns.each.with_index {|(to_node, e), idx|
        cur_node.conns.each_pair.to_a[idx+1 ... cur_node.conns.size].each {|(to_node2, e2)|
          add_bi_dir!(e.weight + e2.weight, to_node, to_node2) unless check.call(to_node2)
        } unless check.call(to_node)
      }
    }
    @tree = tree[0..shrines_count]
    tree.each {|n|
      n.conns.delete_if {|to_node, _| to_node > shrines_count}
    }
  end

  def solve
    squeeze_non_shrines!
    prim(1)
  end

end

if $0 == __FILE__ then
  t = readline.to_i
  
  t.times {
    n, m, k = read_int_line
    edges = m.times.collect {|_| read_int_line }
    puts PiligrimsNPortals.new(n, edges, k).solve
  }
end
