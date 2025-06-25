# Step 0 - make sure you have all the utils and that you are willing to install them
# Check for Linux-specific utilities: xdg-open and xclip/xsel
which bash sed jq grep cat xargs unzip rm xdg-open xclip || echo 'You are missing some utils. Please install them (e.g., sudo pacman -S <utility_name>).'

# Step 1 - Manually download the roadmaps folder
echo "Please manually download the roadmaps folder from:"
echo "https://download-directory.github.io?url=https://github.com/kamranahmedse/developer-roadmap/tree/master/content/roadmaps"
echo "Press Enter when you have downloaded and placed it in the current directory."
read

# Step 2 - Unzip the roadmaps
unzip kamranahmedse*roadmaps.zip -d roadmaps

# Step 3 - Delete the zip file
rm kamranahmedse*roadmaps.zip

# Step 4 - Build large Markdown files
for roadmap_id in ./roadmaps/*; do
  cat "$roadmap_id"/content-paths.json \
    | jq 'to_entries | "." + .[].value' -r \
    | xargs cat \
    | sed \
    -e "s/\"/'/g" \
    -e "s/\' >/'>/g" \
    -e "s/# #/#/g" \
    -e "s/^### /\n\n#### /g" \
    -e "s/^## /\n\n### /g" \
    -e "s/^# /\n\n## /g" \
    -e "s/<ResourceGroupTitle>\(.*\)<\/ResourceGroupTitle>/### \1/g" \
    -e "s/### Free Content//g" \
    -e "s/<BadgeLink colorScheme='\(.*\)' badgeText='\(.*\)' href='\(.*\)'>\(.*\)<\/BadgeLink>/ - [ ] [\4]\(\3\) (\2)/g" \
    -e "s/<BadgeLink badgeText='\(.*\)' colorScheme='\(.*\)' href='\(.*\)'>\(.*\)<\/BadgeLink>/ - [ ] [\4]\(\3\) (\1)/g" \
    -e "s/<BadgeLink badgeText='\(.*\)' href='\(.*\)'>\(.*\)<\/BadgeLink>/ - [ ] [\3]\(\2\) (\1)/g" \
    | grep -v "BadgeLink" \
    | cat > "$(echo "$roadmap_id" | sed -e 's/roadmaps\///')".md
done

# Step 5 - Create a new gist
echo "Opening a new Gist page in your browser..."
xdg-open https://gist.new

# Step 6 - Copy file to clipboard and paste it into your new gist
echo "Copying 101-backend.md to your clipboard. You can paste it into the Gist."
cat 101-backend.md | xclip -selection clipboard

# Utils ----------------

# Debug (example of how to use for debugging)
# Uncomment and adjust as needed:
#    | grep -v "BadgeLink" \
#    | cat >> debug.md

# @TODO Fix and use this: Remove all </BadgeLink>, add them when line starts with <BadgeLink, then remove all the signle <\/BadgeLink>
#    -e "/^<BadgeLink/s/<\/BadgeLink>$//; /^<BadgeLink/s/$/<\/BadgeLink>/" \

