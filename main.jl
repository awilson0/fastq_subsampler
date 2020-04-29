# Argument Parser
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

function main()
    parsed_args = parse_arguments()
    for (arg, val) in parsed_args
        println(" $arg => $val")
    end
end

main()
