#! /bin/bash
TAGS_FILE="tags"
if [ -f ${TAGS_FILE} ]; then
    # Use the tags file
    TAGS_LIST=$(cat ${TAGS_FILE})
else
    # Parse with ctags
    TAGS_LIST=$(ctags -R --c-kinds=cfst -o-)
fi

TYPE_LIST="$(echo -n "${TAGS_LIST}" | awk -F "\t" '/!/ {next} {printf("%s,%s\n", $1, $4)}' | sort -t "," -k2 -r)"

# Determine the highlight group for each line
while read -r line; do
    KEYWORD="${line%,*}"
    TYPE="${line#*,}"
    HIGHLIGHT_GROUP=""

    # Uses the ctag kinds (ctags --list-kinds)
    case "${TYPE}" in
        "c")
            HIGHLIGHT_GROUP="Identifier";;
        "f")
            HIGHLIGHT_GROUP="Function";;
        "s")
            HIGHLIGHT_GROUP="Identifier";;
        "t")
            HIGHLIGHT_GROUP="Identifier";;
        *)
            HIGHLIGHT_GROUP="";;
    esac

    if [ ! -z "${HIGHLIGHT_GROUP}" ]; then
        OUTPUT="${OUTPUT}syntax keyword ${HIGHLIGHT_GROUP} ${KEYWORD}"$'\n'
    fi
done <<< "${TYPE_LIST}"

echo "${OUTPUT}"
