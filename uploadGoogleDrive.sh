# Step 1 : setup your root folder id
ROOT_FOLDER_ID=""
if [ -z "$ROOT_FOLDER_ID" -a "$ROOT_FOLDER_ID"=="" ]; then
        echo "error - ROOT_FOLDER_ID is empty"
        exit
fi

# Step 2 : check backup folder exist
BACKUP=./backup/
if [ ! -d "$BACKUP" ]; then
  mkdir $BACKUP
fi

# Step 3 : variable
me=`basename "$0"`
TMPFILE=${BACKUP}tmpfile
find . -type f -path "./*" ! -path "./$me" ! -path "./backup/*" ! -name ".DS_Store" >$TMPFILE

# Step 4 : read folder name
read -p 'FolderName: ' FolderName
echo $FolderName

# Step 5 : check gdrive / install gdrive
if test "x$(which gdrive)" = "x"; then
  brew install gdrive
fi

# Step 6 : read list of google driver
FOLDER_LIST=$(gdrive list)
echo $FOLDER_LIST

# Step 7 : create folder on google drive
RESULT=$(gdrive mkdir $FolderName -p $ROOT_FOLDER_ID)
DIR_GID=$(echo $RESULT | awk '{print $2}')

# Step 8 : upload files
while read line
do
	echo $line
 	gdrive upload -p $DIR_GID "$line"

  	# remove files to backup folder
  	mv "$line" $BACKUP
done < $TMPFILE

# Step 9 : show information
gdrive info $DIR_GID

# Step 10 : remove tmpfile
rm $TMPFILE

