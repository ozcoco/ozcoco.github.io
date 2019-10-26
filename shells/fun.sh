#! /bin/bash

is_dir()
{
	DIR_NAME=$1
	if [ ! -d "$DIR_NAME" ];
	then
		
		return 1;
	else

		return 0;
	fi
}


create_dir()
{
	DIR_NAME=$1
	
	mkdir $DIR_NAME > /dev/null 2>&1

	if [ "$?" = 0 ];
	then
	    echo "$DIR_NAME created a dir ";
	else
	    echo "Cannot create dir $DIR_NAME";
	fi		
}


for DIR in "$@";
do
   if is_dir "$DIR"
   then

	   echo "$DIR dir exist";

    else
	
	  create_dir "$DIR"
   fi

done


exit 0
