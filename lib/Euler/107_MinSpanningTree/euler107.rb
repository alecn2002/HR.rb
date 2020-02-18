
module Enumerable
  def collectf(f, *args)
    collect {|v| v.send(f, *args) }
  end
  
  def each_while_listed(list)
    until (list.empty?) do
      list = list.inject(list.class.new) {|new_list, e|
        new_list + yield(e)
      }
    end
  end
  
  def inject_while_listed(res, list)
    each_while_listed(list) {|e|
      yield(res, e)
    }
  end
end

class Edge
  include Comparable
  
  attr_reader :nodes, :weight
  
  def initialize(node1, node2, weight)
    @nodes, @weight = [node1-1, node2-1], weight
  end
  
  def to_s
    "(#{nodes.join('-')}: #{weight})"
  end
  
  def other_side(node)
    nodes.send((node == nodes.first) ? :last : :first)
  end
  
  def min_side
    nodes.min
  end
  
  def <=>(other)
    weight <=> other.weight
  end
  
  def has_not_added?
    nodes.any? {|n| !n.added }
  end
  
  def add!
    nodes.each {|n| n.added = true }
  end
end

class Node
  include Comparable
  
  attr_reader :id, :edges, :added
  
  def initialize(id)
    @id, @edges, @tree_edges, @added = id, [], [], false
  end
  
  def propagate_group_id(group_id)
    
  end
  
  def add_edge(edge)
    @edges << edge
  end
  
  def <=>(other)
    
    id <=> other.id
  end
end

class Euler107
  attr_reader :nodes_num, :edges, :nodes
  
  def initialize(nodes_num, edges_lines)
    @nodes_num, @edges = nodes_num, edges_lines.collect {|l| 
      Edge.new(*l.strip.split(' ').collectf(:to_i)) 
    }
    $stderr.puts "Edges: #{edges}"
    @nodes = nodes_num.times.colect {|id| Node.new(id) }
      
    edges.each {|e|
      e.nodes.each {|| @nodes[nid].add_edge(e) }
    }
    $stderr.puts "Nodes: #{nodes}"
  end
  
  def make_wave(node_num)
    $stderr.puts "make_wave(#{node_num})" # DEBUG
    ans = []
    ans[node_num] = 0
    cur = [ [node_num] ]
    while(!cur.empty?) do
      nxt = cur.inject([]) {|r, path|
        nodes[node].each {|edge|
          new_path, new_w = edge.travel(path, ans[path.last])
          if (ans[edge.first].nil? || ans[edge.first] > new_w) then
            ans[edge.first] = new_w
            r << edge.first
          end
        }
        r
      }
      cur = nxt
    end
    ans.sum
  end
  
  # Stupid approach: make waves from every node
  def solve_stupid
    nodes_num.times.collect{|node_num| make_wave(node_num) }.min
  end

  # Smarter approach:
  # 1. Start from min.link
  # 2. Mark linked parts with min. group_id of them
  # 3. Propagate with min.link that joins 2 unlinked parts (detected by group_id)
  def solve_prims
    linked, unlinked = [nodes.first], nodes[1..-1].dup
  end
  
  
  
  def solve
    solve_stupid
  end
end

n, m = readline.split(' ').collectf(:to_i)

puts Euler107.new(n, m.times.collect {|_| readline } ).solve
