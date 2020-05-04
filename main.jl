# Fastq_Subsampler
# Andrew Wilson
# 29 April 2020


using ArgParse
using StatsBase

include("fastq_parser.jl")

function parse_arguments()
    s = ArgParseSettings()

    @add_arg_table! s begin
        "--number", "-n"
            help = "Number of reads to subsample"
            arg_type = Int
        "--percent", "-p"
            help = "Percent of reads to subsample"
            arg_type = Int
        "--output", "-o"
            help = "Basename of output files"
            arg_type = String
            default = "./subsampled"
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

function fastq_subsampler(forward, reverse, num_reads::Int, depth::Int)
    read_indices = sample(1:num_reads, depth; replace=false)
    farray = Array{String, 2}(undef, 3, depth)
    rarray = Array{String, 2}(undef, 3, depth)
    for i in 1:depth
        farray[[CartesianIndex(1,i)]] .= forward[1][read_indices[i]]
        farray[[CartesianIndex(2,i)]] .= forward[2][read_indices[i]]
        farray[[CartesianIndex(3,i)]] .= forward[3][read_indices[i]]
        rarray[[CartesianIndex(1,i)]] .= reverse[1][read_indices[i]]
        rarray[[CartesianIndex(2,i)]] .= reverse[2][read_indices[i]]
        rarray[[CartesianIndex(3,i)]] .= reverse[3][read_indices[i]]
    end
    return farray, rarray
end


function main()
    parsed_args = parse_arguments()
    # Store arguments as variables
    reads_f = parsed_args["file1"]
    reads_r = parsed_args["file2"]
    n = parsed_args["number"]
    percent = parsed_args["percent"]
    output = parsed_args["output"]

    # Test arguments
    file_exists(reads_f)
    file_exists(reads_r)

    if isnothing(n) & isnothing(percent)
        println("Please indicate a depth to subsample with '-n' or '-p'!")
        exit()
    end

    # Parse files
    fwd = fastq_parser(reads_f)
    rev = fastq_parser(reads_r)

    num_f = length(fwd[1])
    num_r = length(rev[1])

    if num_f != num_r
        println("both fastq files should be the same size!")
        exit()
    end

    # Convert percentage to Number
    if !isnothing(percent)
        n = floor(Int, percent / 100 * num_f)
    end

    # Ensure number of reads to subsample is less than total
    if n > num_f
        println("n is greater than the number of reads")
        exit()
    end

    # Build new array of sequences
    new_farray, new_rarray = fastq_subsampler(fwd, rev, num_r, n)
    fastq_writer(new_farray, string("$output","_1.fastq"))
    fastq_writer(new_rarray, string("$output","_2.fastq"))
end

@time main()
