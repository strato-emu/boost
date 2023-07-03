#!/bin/bash

declare -a modules=(
    "array"
    "assert"
    "bind"
    "concept_check"
    "config"
    "container"
    "container_hash"
    "conversion"
    "core"
    "date_time"
    "describe"
    "detail"
    "function"
    "function_types"
    "fusion"
    "icl"
    "integer"
    "intrusive"
    "io"
    "iterator"
    "move"
    "mp11"
    "mpl"
    "optional"
    "predef"
    "preprocessor"
    "range"
    "rational"
    "regex"
    "smart_ptr"
    "static_assert"
    "throw_exception"
    "tuple"
    "type_index"
    "type_traits"
    "typeof"
    "utility"
    "functional"
    "variant"
    "winapi"
)

print_help() {
    echo "Usage: $0 [-s] PATH"
    echo "Options:"
    echo "  -s      Skip updating existing submodules, but only add new ones"
    echo "Arguments:"
    echo "  PATH    Path to the working repo"
}

skip_update=false

# Parse command line arguments
while getopts hs option
do
    case "$option"
    in
        s) skip_update=true;;
        h) print_help; exit 0;;
    esac
done
shift $(($OPTIND-1))
path="$1"

# cd into the specified path
if [ -n "$path" ]
then
    cd $path &> /dev/null
    if [ $? -ne 0 ]
    then
        echo "Error: $path is not a valid path"
        exit 1
    fi
fi

# $1 - submodule name
# $2 - submodule path
add_submodule() {
    echo "Adding submodule $1"
    git submodule add --name $1 --depth 1 https://github.com/boostorg/$1.git $2/$1
    git config -f .gitmodules submodule.$1.shallow true
    git add .
    git commit -m "Add \`$1\` submodule"
}

# $1 - submodule name
# $2 - submodule path
update_submodule() {
    if [ $skip_update = true ]
    then
        echo "Skipping submodule $1 update"
        return
    fi

    echo "Updating submodule $1"
    cd $2/$1
    git fetch --depth 1
    git checkout origin/HEAD
    cd -
    git add $2/$1
    git commit -m "Update \`$1\` submodule"
}

# $1 - submodule name
# $2 - submodule path
add_or_update_submodule() {
    git submodule status $2/$1
    if [ $? -eq 0 ]
    then
        update_submodule $1 $2
    else
        add_submodule $1 $2
    fi
}

for i in "${modules[@]}"
do
    add_or_update_submodule $i libs
done

# Add/Update cmake submodule in the tools folder
add_or_update_submodule cmake tools

# Fetch CMakeLists.txt from the boostorg/boost repo
wget https://raw.githubusercontent.com/boostorg/boost/master/CMakeLists.txt -O CMakeLists.txt

# Patch CMakeLists.txt to define a Boost::boost target as a sum of all modules
echo "" >> CMakeLists.txt
echo "add_library(boost INTERFACE)" >> CMakeLists.txt
echo "target_link_libraries(boost INTERFACE" >> CMakeLists.txt
for i in "${modules[@]}"
do
    echo "    Boost::$i" >> CMakeLists.txt
done
echo ")" >> CMakeLists.txt
echo "add_library(Boost::boost ALIAS boost)" >> CMakeLists.txt
echo "" >> CMakeLists.txt

# Commit CMake stuff
git add CMakeLists.txt
git commit -m "Update \`CMakeLists.txt\`"
