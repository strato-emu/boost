#!/bin/bash

# Usage: ./build.sh [path]

if [ -z "$1" ]
then
    GIT="git"
else
    GIT="git -C $1"
fi

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

for i in "${modules[@]}"
do
    $GIT submodule add --name $i --depth 1 https://github.com/boostorg/$i.git libs/$i
    $GIT config -f .gitmodules submodule.$i.shallow true
    $GIT add .
    $GIT commit -m "Add \`$i\` submodule"
done

# Add cmake submodule in the tools folder
$GIT submodule add --name cmake --depth 1 https://github.com/boostorg/cmake.git tools/cmake
$GIT config -f .gitmodules submodule.cmake.shallow true
$GIT add .

# Prefix $1 to CMakeLists.txt if it's not empty
if [ -z "$1" ]
then
    CMAKE_OUT_FILE="CMakeLists.txt"
else
    CMAKE_OUT_FILE="$1/CMakeLists.txt"
fi

# Fetch CMakeLists.txt from the boostorg/boost repo
wget https://raw.githubusercontent.com/boostorg/boost/master/CMakeLists.txt -O $CMAKE_OUT_FILE

# Path CMakeLists.txt to define a Boost::boost target as a sum of all modules
echo "" >> $CMAKE_OUT_FILE
echo "add_library(boost INTERFACE)" >> $CMAKE_OUT_FILE
echo "target_link_libraries(boost INTERFACE" >> $CMAKE_OUT_FILE
for i in "${modules[@]}"
do
    echo "    Boost::$i" >> $CMAKE_OUT_FILE
done
echo ")" >> $CMAKE_OUT_FILE
echo "add_library(Boost::boost ALIAS boost)" >> $CMAKE_OUT_FILE
echo "" >> $CMAKE_OUT_FILE

# Commit CMake stuff
$GIT add $CMAKE_OUT_FILE
$GIT commit -m "Add \`CMakeLists.txt\` and \`cmake\` submodule"
