#!/bin/bash


# help
usage()
{
    echo -e "\nusage: $0 -b <input_bam> -c <input_contig> -o <output_dir> -p <output_prefix>\n"
}




# ---- #
# MAIN #
# ---- #

#echo $#

if [ "$#" != "8" ]; then
    echo -e "\nERROR: Not enough arguments provided!"
    usage
    exit 1 
fi 

while [[ $# -gt 0 ]]; do
    opt="$1"
    case "$opt" in
        -b|--input_bam )
            shift
            input_bam=$1
            ;;
        -c|--input_contig )
            shift
            input_contig=$1
            ;;
        -o|--output_dir )
            shift   
            output_dir=$1
            ;;
        -p|--output_prefix )
            shift
            output_prefix=$1
            ;;
        -h|--help )           
            usage
            exit
            ;;
        * )                     
            usage
            exit 1
            ;;
    esac
    shift
done

if [ ! -d $output_dir ]; then
    mkdir $output_dir
fi

# sort_bam input_bam output_bam
sort_bam(){
    samtools sort -T ./tmp-samtools -@ 10 -O bam -o $2 $1
}

# index_bam $1
index_bam(){
    samtools index $1
}


# try index bam, or sort and index
if [ ! -e ${input_bam}.bai ]; then
    sort_bam $input_bam ${input_bam}_sorted && \
    mv ${input_bam}_sorted $input_bam && \
    index_bam $input_bam
fi

echo "[INFO] slice ${input_bam} file by input fasta file ${input_contig}, generate sliced contigname, bam and readname files ..."
# get contigname
grep -e ">" $input_contig | awk 'sub(/^>/, "")' | awk '{print $1}' > $output_dir/${output_prefix}.contigname

# slice bam, sort and index
samtools view -bh $input_bam `cat $output_dir/${output_prefix}.contigname | tr "\n" " "` > $output_dir/${output_prefix}.bam
sort_bam $output_dir/${output_prefix}.bam $output_dir/${output_prefix}_sorted
mv $output_dir/${output_prefix}_sorted $output_dir/${output_prefix}.bam 
index_bam $output_dir/${output_prefix}.bam
# get readname
samtools view $output_dir/${output_prefix}.bam | awk '{print $1}'  > $output_dir/${output_prefix}.readname
echo "[INFO] done!"
