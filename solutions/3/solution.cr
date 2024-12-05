class Solution

    def initialize
        @matches = [] of Int32
        @lines = [] of String
    end

    def process
        STDIN.each_line do |line|
            @lines.push(line)
        end
    end

    def part1
        sum = 0
        regex = /mul\((\d{1,3}),(\d{1,3})\)/
        @lines.each do |line|
            line.scan(regex).each do |match|
                @matches.push(match[1].to_i, match[2].to_i)
            end
        end
        @matches.each_slice(2) do |slice|
            sum += slice[0] * slice[1]
        end
        puts sum
    end

    class State
        EXPLORE = 0
        INFUNCNAME = 1
        FIRSTPARAM = 2
        SECONDPARAM = 3

        def initialize
            @current_state = 0
        end

        def advance!
            @current_state += 1
            reset! if @current_state > SECONDPARAM
        end

        def reset!
            @current_state = EXPLORE
        end

        def state
            @current_state
        end
    end

    class Sequence
        START = 0
        INPROG = 1
        COMPLETE = 2
        FAIL = 3

        def initialize(str : String)
            @index = 0
            @state = START
            @id = str
        end

        def advance!
            @state += 1
        end

        def fail!
            @state = FAIL
        end

        def complete!
            @state = COMPLETE
        end

        def complete?
            @state == COMPLETE
        end

        def fail?
            @state == FAIL
        end

        def check!(current : Char)
            return if self.complete? || self.fail?
            self.fail! if current != @id[@index]
            case @state
            when START
                self.advance!
                @index += 1
            when INPROG
                @index += 1
                self.complete! if @index == @id.size
            end
        end

        def reset!
            @index = 0
            @state = START
        end

        def state
            @state
        end
    end

    class Parser
        # I could probably do this in regex but let's build a parser!
        MUL = "mul"
        DO = "do"
        DONT = "don't"

        def initialize(lines : Array(String))
            @sequences = [Sequence.new(MUL), Sequence.new(DO), Sequence.new(DONT)]
            @id = ""
            @param1 = ""
            @param2 = ""
            @enabled = true
            @state = State.new
            @sum = 0
            @lines = lines
        end

        def reset_sequences
            @sequences.map {|seq| seq.reset! }
        end

        def complete_sequence
            @sequences.select {|seq| seq.complete? }
        end

        def inprog_sequences
            @sequences.select {|seq| !seq.complete? && !seq.fail?}
        end

        def failed_sequences
            @sequences.select {|seq| seq.fail? }
        end

        def check_sequences(char : Char)
            @sequences.each do |seq|
                seq.check!(char)
            end
        end

        def reset_all
            @state.reset!
            self.reset_sequences
            @id = ""
            @param1 = ""
            @param2 = ""
        end

        def execute
            case @id
            when MUL
                @sum += @param1.to_i * @param2.to_i if @enabled
            when DO
                @enabled = true
            when DONT
                @enabled = false
            end
            self.reset_all
        end

        def handle_explore(current)
            if inprog_sequences().size > 0
                @state.advance!
                @id += current
            end
        end

        def handle_funcname(current, index, line)
            @id += current
            if complete_sequence().size > 0
                if @id == DO && index + 1 < line.size && line[index + 1] == 'n'
                    @sequences[1].fail!
                    return
                end
                @state.advance!
            end
        end

        def handle_firstparam(current)
            if @id == MUL
                return if current == '('
                if current == ','
                    @state.advance!
                    return
                end
                if current.to_s.match(/\d/) && @param1.size < 3
                    @param1 += current
                else
                    self.reset_all
                end
            else
                if current == '('
                    @state.advance!
                else
                    self.reset_all
                end
            end
        end

        def handle_secondparam(current)
            if current == ')'
                self.execute
            elsif current.to_s.match(/\d/) && @param2.size < 3
                @param2 += current
            else
                self.reset_all
            end
        end

        def parse!
            @lines.each do |line|
                line.each_char_with_index do |current, index|
                    self.check_sequences(current)
                    if failed_sequences().size == @sequences.size
                        self.reset_all
                        next
                    end
                    case @state.state
                    when State::EXPLORE
                        handle_explore(current)
                        next
                    when State::INFUNCNAME
                       handle_funcname(current, index, line)
                       next
                    when State::FIRSTPARAM
                       handle_firstparam(current)
                       next
                    when State::SECONDPARAM
                        handle_secondparam(current)
                        next
                    end
                end
            end
        end

        def sum
            @sum
        end
    end

    def part2
        parser = Parser.new(@lines)
        parser.parse!
        puts parser.sum
    end

    def run
        process()
        part1()
        part2()
    end

end

Solution.new().run()
