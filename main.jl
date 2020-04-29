# Argument Parser Function
using ArgParse

function parse_arguments()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--number", "-n"
            help = "Number of reads to subsample"
            arg_type = Int
        "--percent", "-p"
            help = "Percent of reads to subsample"
            arg_type = Int
        "file1"
            help = "Path to forward reads"
            arg_type = String
            required = true
        "file2"
            help = "Path to reverse reads"
            arg_type = String
            required = true
    end

    return parse_args(s)
end

function file_exists(path::String)
    if !isfile(path)
        println("File not found at '$path'")
        exit()
    end
end

function main()
    parsed_args = parse_arguments()
# Store arguments as variables
    reads_f = parsed_args["file1"]
    reads_r = parsed_args["file2"]
    number = parsed_args["number"]
    percent = parsed_args["percent"]

# Test arguments
    file_exists(reads_f)
    file_exists(reads_r)

    if isnothing(number) & isnothing(percent)
        println("Please indicate a depth to subsample with '-n' or '-p'!")
        exit()
    end
end

main()
