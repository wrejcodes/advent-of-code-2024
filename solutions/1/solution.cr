class Solution

    def initialize
        @list1 = Array(Int32).new
        @list2 = Array(Int32).new
        @part1sum = 0
        @part2sum = 0
    end

    def process
        STDIN.each_line do |line|
            # process input
            a, b = line.split("   ")
            @list1 << a.to_i
            @list2 << b.to_i
        end
    end

    def part1
        @list1.sort.zip(@list2.sort).each do |a, b|
            @part1sum += (b - a).abs
        end
        puts @part1sum
    end

    def part2
        @list1.each do |num|
            @part2sum += @list2.select { |n| n == num }.size * num
        end
        puts @part2sum
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
