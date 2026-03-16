#!/bin/bash

find . -type f -name "*.mkv" | while read -r file; do
    new_name=$(echo "$file" | sed 's/ 720p x264//g')
    if [ "$file" != "$new_name" ]; then
        mv "$file" "$new_name"
        echo "Renamed: $file -> $new_name"
    fi
done

