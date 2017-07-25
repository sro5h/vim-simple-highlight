#! /bin/bash
# gen.bash: Generate a set of vim commands to highlight a list of tags generated by:
#   [exuberant ctags](ctags.sourceforge.com).
# Author: Paul Meffle

# Global variables
tagsFile="tags"
tagsDir=""
tagsList=""
typeList=""

showUsage() {
        echo "Usage:"
        echo "    gen.bash <options>"
        echo ""
        echo "    -c [cmd]: The ctags command to run"
        echo "    -d [dir]: The directory to search for the tags file"
        echo "    -f:       Force to invoke ctags even if a tag file exists"
}

# Parse arguments
while getopts "hf:d:" opt; do
        case "${opt}" in
                h)
                        showUsage
                        exit 0
                        ;;
                f)
                        tagsFile="${OPTARG}"
                        ;;
                d)
                        tagsDir="${OPTARG}"
                        ;;
                :|?)
                        exit 1
                        ;;
        esac
done

if [ -n "${tagsDir}" ]; then
        tagsFile="${tagsDir}/${tagsFile}"
fi

# Check whether the specified tags file exists. If it exists sort it by the
# fourth column (the tag kind) and store it in a variable.
if [ -f ${tagsFile} ]; then
        tagsList="$(cat ${tagsFile} | sort -k4 -t\	)"
else
        exit 0;
fi

# The variables holding the highlight group for each `kind`.
hgC=Identifier
hgF=Function
hgS=Identifier
hgT=Identifier

# Converts the tags file into vim syntax commands. Lines starting with `!`
# (comment) or `operator` (c++ operator) are ignored. For each language
# specific `kind` (`ctags --list-kinds`) there has to be a shell variable that
# holds the highlight group that should be used.
# e.g.:
#   kind c -> ${hgC}
# The order in which the syntax commands get printed is defined in the `END`
# block. This is important to avoid e.g. a constructor overriding the class
# highlight.
awkProgram='/^!/ { next } /^operator/ { next }
{
        if ($4 == "c") {
                cList = cList sprintf("syntax keyword '"${hgC}"' %s\n", $1);
        } else if ($4 == "f") {
                fList = fList sprintf("syntax keyword '"${hgF}"' %s\n", $1);
        } else if ($4 == "s") {
                sList = sList sprintf("syntax keyword '"${hgS}"' %s\n", $1);
        } else if ($4 == "t") {
                tList = tList sprintf("syntax keyword '"${hgT}"' %s\n", $1);
        }
}
END {
        printf("%s%s%s%s", cList, fList, sList, tList);
}'

# Runs the `${awkProgram}` to convert the tags file into vim syntax commands.
# e.g.:
#   syntax keyword Identifier ExampleClass
typeList="$(printf "%s" "${tagsList}" | awk -F "\t" "${awkProgram}")"

# Output the vim syntax commands.
printf "%s" "${typeList}"
