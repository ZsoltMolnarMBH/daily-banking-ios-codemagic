#! /bin/sh.
inputDir="$1"
if [ -z "${inputDir}" ]; then
    echo "Missing first argument: inputDir (absolute path)"
    exit 1
fi
outputDir="$2"
if [ -z "${outputDir}" ]; then
    echo "Missing second argument: outputDir (absolute path)"
    exit 1
fi
mkdir -p "${outputDir}"
cd "${inputDir}"
for file in *; do
    color=$(grep -i "<rect" "$file" | grep -o 'fill="[^"]*"' | cut -c 8-13)
    red=$(cut -c 1-2 <<<"$color")
    green=$(cut -c 3-4 <<<"$color")
    blue=$(cut -c 5-6 <<<"$color")
    colorsetDir=$(echo "$file" | tr '[:upper:]' '[:lower:]'  | cut -f 1 -d '.')
    colorsetDir="${colorsetDir}.colorset"
    mkdir -p "${outputDir}/${colorsetDir}"
    #echo "${outputDir}/${colorsetDir}"
    #echo "color ${color} r${red} g${green} b${blue}"

template='{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0xBLUE_PLACEHOLDER",
          "green" : "0xGREEN_PLACEHOLDER",
          "red" : "0xRED_PLACEHOLDER"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}'
    template=${template//RED_PLACEHOLDER/$red}
    template=${template//GREEN_PLACEHOLDER/$green}
    template=${template//BLUE_PLACEHOLDER/$blue}
    #echo "$template"

    outputPath="${outputDir}/${colorsetDir}/Contents.json"
    echo "$template" >> "$outputPath"
done
