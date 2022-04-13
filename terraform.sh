#!/bin/bash

terraform_bin="/usr/local/bin/terraform"

if [[ ! -f "$terraform_bin" ]]; then
        echo "Terraform command not found"
        exit 2
fi

terraform_files_dir=$1

if [[ $1 == '' ]]; then
        echo "Directory path cannot be empty, please provide a valid path"
        exit 2
else
        if [[ ! -d $1 ]]; then
                echo "Path: $1:  does not exist"
                exit 2
        fi
fi

#output_file=

for i in $(find $1 -type f -name 'main.tf' -printf '%h\n')
do
        echo -e "\nTerraform initializing in $i/"
        ${terraform_bin} -chdir="$i/" init
        if [[ "$?" != "0" ]]; then
          echo -e "\nTerraform initialization failed in $i/"
          exit 2
        fi
        echo -e "\nRunning Terraform plan in $i/"
        if plan=$(${terraform_bin} -chdir="$i/"  plan -no-color); then
                output=$(echo "$plan" | grep -E '(^.*[#~+-] .*|^[[:punct:]]|Plan)')
                if [[ $output == '' ]]; then
                        echo -e "\nNo changes needed to be done"
                else
                        echo -e "\n$output"
                fi
        else
                echo -e "\nTerraform plan failed in $i/"
                echo -e "\n$plan"
                exit 2
        fi
done

# use absolute path
# specify type in find command
# do exit code check in plan
# check terraform binary

