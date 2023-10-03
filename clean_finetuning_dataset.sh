#!/bin/bash

# Check if the file name is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 inputfile outputfile"
    exit 1
fi

inputfile=$1
outputfile=$2

# Check if the input file exists
if [ ! -f "$inputfile" ]; then
    echo "Input file not found!"
    exit 1
fi

awk '
{
    # Remove numbering
    sub(/^[[:space:]]*[0-9]+\./, "")
    
    # Print the line
    print $0
    
    # Add a blank line after every 10th line
    if (NR % 10 == 0) {
        print ""
    }
}' "$inputfile" > "$outputfile"

