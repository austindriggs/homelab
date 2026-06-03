#!/bin/bash
shopt -s globstar

for file in **/*.mkv; do
    # Extract season and episode
    if [[ "$file" =~ S([0-9]{2})E([0-9]{2,}) ]]; then
        season=${BASH_REMATCH[1]}
        episode=${BASH_REMATCH[2]}
        
        # Extract episode title
        title=$(echo "$file" | sed -E 's/.*S[0-9]{2}E[0-9]{2,}(.+?)\.mkv/\1/' | tr '.' ' ' | sed -E 's/-\[.*\]//')
        
        # Construct new filename
        newfile="The Office S${season}E${episode} - ${title}.mkv"
        
        # Rename file
        mv -vn "$file" "$(dirname "$file")/$newfile"
    fi
done

