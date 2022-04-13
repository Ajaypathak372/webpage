#!/bin/bash

if [[ $(which terraform) ]]; then
	terraform_bin=$(which terraform)
else
        echo "Terraform command not found"
        exit 2
fi

terraform_files_dir=$1

if [[ $terraform_files_dir == '' ]]; then
        echo "Directory path cannot be empty, please provide a valid path"
        exit 2
else
        if [[ ! -d $terraform_files_dir ]]; then
                echo "Path: $terraform_files_dir:  does not exist"
                exit 2
        fi
fi

#output_file=

for i in $(find $terraform_files_dir -type f -name 'main.tf' -printf '%h\n')
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

