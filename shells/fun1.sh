#! /bin/bash

echo "Please input dir name"

is_dir()
{

  if [ -d $1 ];
  then
	return 0;
  else

	return 1;
  fi

}


read dir

if is_dir "$dir";
then
	echo "the $dir is dir";
else
	echo "the $dir not is dir";
fi

exit 0
