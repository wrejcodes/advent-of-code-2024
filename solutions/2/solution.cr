class Solution

    def initialize
        @reports = [] of Array(Int32)
    end

    def process
        STDIN.each_line do |line|
            # process input
            @reports.push(line.split(" ").map {|x| x.to_i})
        end
    end

    def report_safe?(report : Array(Int32))
        previous_diff = Int32::MAX;
        report.each_with_index do |num, index|
            next if index == 0
            diff = num - report[index - 1]
            if diff == 0 || (diff/previous_diff < 0  && previous_diff != Int32::MAX) || diff.abs > 3
                return false
            end
            previous_diff = diff
        end
        return true
    end

    def report_safe_with_skip?(report)
        return true if report_safe?(report)
        report.size.times do |num|
            report_with_skip = report.each_with_index.select {|v, i| i != num}.map {|x, i| x}.to_a
            return true if report_safe?(report_with_skip)
        end
        return false
    end

    def part1
        puts @reports.select {|report| report_safe?(report)}.size
    end

    def part2
        puts @reports.select {|report| report_safe_with_skip?(report)}.size
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
