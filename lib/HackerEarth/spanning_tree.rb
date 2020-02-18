require 'priority_queue'

class Node
    attr_reader :id, :marked, :conns
    
    def initialize(id)
        @id, @marked, @conns = id, false, {}
    end
    
    def <<(edge)
        @conns.update(edge.to_node => edge) if (!conns.has_key?(edge.to_node) || edge.weight < conns[edge.to_node].weight)
        self
    end
    
    def mark!(m = true)
        @marked = m
    end
end

class Edge
    include Comparable
  
    attr_reader :weight, :to_node
    
    def initialize(weight, to_node)
        @weight, @to_node = weight, to_node
    end
    
    def <=>(other)
#      $stderr.puts "Edge#{self}#<=> called with #{other}"
      return other.weight <=> weight if weight != other.weight
      to_node <=> other.to_node
    end
    
    def to_s
      "<w=#{weight} to=#{to_node}>"
    end
end
   
class SpanningTree
    attr_reader :tree, :edge_klass
    
    # edges represented as [from, to, weight]
    def initialize(num_nodes, edges, edge_klass = Edge)
        @tree = (num_nodes+1).times.collect {|id|  Node.new(id) }
        @edge_klass = edge_klass
        edges.each {|e|
#            $stderr.puts "e=#{e}"
            [[0, 1], [1, 0]].collect {|sel| 
                e.values_at(*sel) 
            }.each {|ee| 
                @tree[ee.first] << edge_klass.new(e.last, ee.last) 
            }
        }
    end

    def prim(from)
      min_cost = 0
      pq = PriorityQueue.new
      pq << edge_klass.new(0, from)
#      $stderr.puts "Initial PQ=#{pq.elements}"
      until pq.empty? do
        p = pq.pop
#        $stderr.puts "Popped #{p}"
        unless tree[p.to_node].marked then
          min_cost += p.weight
          cur_node = tree[p.to_node]
          cur_node.mark!
          cur_node.conns.each {|to_node, conn|
            pq << conn unless tree[to_node].marked
          }
        end
#        $stderr.puts "After pop/add PQ=#{pq.elements}"
      end
      min_cost
    end
end

def read_int_line
  readline.strip.split(' ').collect(&:to_i)
end

if $0 == __FILE__ then
  n, m = read_int_line
  edges = m.times.collect {|_| read_int_line }

  # $stderr.puts "n=#{n} m=#{m} edges=#{edges}"

  puts SpanningTree.new(n, edges).prim(1)
end
