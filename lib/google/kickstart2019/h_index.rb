class Solver
    attr_reader :n, :a
    
    def initialize(n, a)
        @n, @a = n, a
    end
    
    def solve
        a.each_with_index.inject([0]) {|r, (h, i)|
            d = ((h < (r.last + 1)) ? 0 : 1)
            $stderr.puts "r=#{r} h=#{h} i=#{i} d=#{d}"
            r << r.last + d
        }[1..-1].collect(&:to_s).join(' ')
    end
end

t = readline.strip.to_i

t.times {
    n = readline.strip.to_i
    a = readline.strip.split(' ').collect(&:to_i)
    puts Solver.new(n, a).solve
}
