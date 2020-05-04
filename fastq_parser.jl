# Fastq IO

function fastq_parser(file::String)
    seqname = []
    sequence = []
    qual = []


    seqs = open(file, "r") do f
        readlines(f)
    end

    for i = 1:length(seqs)
        line_num = i % 4
        if line_num == 1
            push!(seqname, seqs[i])
        elseif line_num == 2
            push!(sequence, seqs[i])
        elseif line_num == 0
            push!(qual, seqs[i])
        end
    end
 return [seqname, sequence, qual]
end

function fastq_writer(seqarray::Array{String}, filename::String)
    open(filename, "w") do file
        for i in eachindex(seqarray)
            if i % 3 == 0
                println(file, "+")
                println(file, seqarray[i])
            else
                println(file, seqarray[i])
            end
        end
    end
end
