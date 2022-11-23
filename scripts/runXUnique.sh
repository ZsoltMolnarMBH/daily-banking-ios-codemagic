#!/bin/sh

# xUnique - https://github.com/truebit/xUnique
# xUnique, is a pure Python script to regenerate project.pbxproj, a.k.a the Xcode project file, and make it unique and same on any machine.
# Compiled to binary by: pyinstaller --onefile xUnique.py
# Python version used: 3.8

# Find Xcode project files
IFS=$'\n'
FILES=(`find . -name "*.pbxproj"`)
unset IFS

# Run xUnique on selected files
for file in "${FILES[@]}"
do :
    echo "\n${file}"
    ./scripts/xunique -v -s -p -c $file
done