STRINGS_FILE='./DailyBanking/Resources/hu.lproj/Localizable.strings'
UNUSED_KEYS='unused.txt'

if [ ! -f "$UNUSED_KEYS" ]; then
    echo "Create a file named $UNUSED_KEYS containing the unused keys in separate lines"
    exit 1
fi

cat unused.txt | while read line
do
   grep -v "$line" "$STRINGS_FILE" > temp && mv temp "$STRINGS_FILE"
done

