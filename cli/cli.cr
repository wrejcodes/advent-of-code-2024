require "option_parser"
require "file_utils"

root_dir = Path.new(__DIR__).parent
template_dir = Path.new("#{root_dir}/templates/")
new = false
run = false
debug = false
folder = ""
input = "sample.in"

parser = OptionParser.new do |parser|
    parser.banner = "Happy Advent of Code"
    parser.on("new", "Create a new solution template") do 
        new = true
        parser.banner = "Usage: new [arguments]"
        parser.on("-f FOLDER", "--folder=FOLDER", "Specify the folder name ie: 3") { |_folder| folder = _folder }
    end
    parser.on("run", "Run a solution against an input") do
        run = true
        parser.banner = "Usage: run [arguments]"
        parser.on("-i INPUT", "--input=INPUT", "Specify the input file. Defaults to sample.in") { |_input| input = _input }
        parser.on("-f FOLDER", "--folder=FOLDER", "Specify the folder") { |_folder| folder = _folder }
        parser.on("-d", "--debug", "Enable debug mode") { debug = true }
    end
    parser.on("-h", "--help", "Show Help") do 
        puts parser
        exit
    end
    parser.invalid_option do |flag|
        STDERR.puts "ERROR: #{flag} is not a valid option."
        STDERR.puts parser
        exit(1)
    end
end

parser.parse

if new
    # create new folder template
    puts "Creating folder #{folder}..."

    target_dir = Path.new("#{root_dir}/solutions/#{folder}")

    ins = "#{target_dir}/in"
    outs = "#{target_dir}/out"
    dirs = [ins, outs]

    files = ["#{ins}/sample.in", "#{ins}/test.in", "#{outs}/sample.out", "#{outs}/test.out"]

    dirs.each do |dir|
        FileUtils.mkdir_p(dir) if !Dir.exists?(dir)
    end

    files.each do |file|
        FileUtils.touch(file) if !File.exists?(file)
    end

    FileUtils.cp("#{template_dir}/solution.cr.template", "#{target_dir}/solution.cr") if !File.exists?("#{target_dir}/solution.cr")

elsif run
    # only run if folder exists
    puts "Running..."

    target_dir = Path.new("#{root_dir}/solutions/#{folder}")

    if !Dir.exists?(target_dir)
        STDERR.puts "No solution found for #{target_dir}"
        exit(1)
    end

    input = input + ".in" if File.extname(input) == ""
    input_file = "#{target_dir}/in/#{input}"
    solution_file = "#{target_dir}/solution.cr"
    output_file = "#{target_dir}/out/#{File.basename(input, ".in")}.out"
    env = {} of String => String
    env["AOC_DEBUG"] = "true" if debug
    if File.exists?(input_file) && File.exists?(solution_file)
        target_dir_unix = target_dir.to_s.gsub("\\", "/")
        input_file_unix = input_file.to_s.gsub("\\", "/")
        output_file_unix = output_file.to_s.gsub("\\", "/")
        Process.run("sh", ["-c", "crystal #{target_dir_unix}/solution.cr < #{input_file_unix} > #{output_file_unix}"], shell: false, error: STDERR, env: env)
    end 

else
    puts parser
    exit(1)
end