#! /bin/bash
tagsFile="tags"
if [ -f ${tagsFile} ]; then
    # Use the tags file
    tagsList=$(cat ${tagsFile})
else
    # Parse with ctags
    tagsList=$(ctags -R --c-kinds=cfst -o-)
fi

typeList="$(echo -n "${tagsList}" | awk -F "\t" '/^!/ {next} /^operator/ {next} {printf("%s,%s\n", $1, $4)}')"

cList=""
fList=""
sList=""
tList=""
# Determine the highlight group for each line
while read -r line; do
    tagKeyword="${line%,*}"
    tagType="${line#*,}"
    highlightGroup=""

    # Uses the ctag kinds (ctags --list-kinds)
    case "${tagType}" in
        "c")
            highlightGroup="Identifier"
            cList="${cList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
        "f")
            highlightGroup="Function"
            fList="${fList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
        "s")
            highlightGroup="Identifier"
            sList="${sList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
        "t")
            highlightGroup="Identifier"
            tList="${tList}syntax keyword ${highlightGroup} ${tagKeyword}"$'\n';;
        *)
            highlightGroup="";;
    esac
done <<< "${typeList}"

echo "${fList}${tList}${sList}${cList}"
