#!/bin/bash

: <<'DESCRIPTION'
### File Description: clean_finetuning_dataset.sh

This Bash script preprocesses a text dataset for machine learning applications, specifically for fine-tuning tasks in NLP. It accepts two arguments: an input file and an output file. The script cleans the dataset by removing line numbering and inserting blank lines after every 10th line, preparing the data for model training.


#### Features:
- Validates the presence of exactly two arguments.
- Checks if the input file exists.
- Removes numbering at the beginning of each line using AWK.
- Inserts a blank line after every 10th line.

#### Usage:
```bash
./clean_finetuning_dataset.sh <inputfile> <outputfile>
./clean_finetuning_dataset.sh ../data/fine-tuning_dataset_RAW.txt ../data/fine-tuning_dataset_CLEAN.txt
```


Ensure the script is executable:
```bash
+chmod +x clean_finetuning_dataset.sh
```

#### Requirements:
- Bash shell
- AWK

This script is useful for data preprocessing in NLP tasks, making datasets more structured and suitable for model fine-tuning.
DESCRIPTION



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

