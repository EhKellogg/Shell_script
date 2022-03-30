#!/bin/bash
if [ $# -lt 2 ]; then
	echo "Missing database name or bash function"
fi
word=$2
case $word in 
	create)
	if [ $# -lt 2 ]; then
		echo "Must specify a DB"
	
	elif [ $# -lt 3 ]; then
		echo "Untitled Database" >> $1
	fi
	databasename=$1
	touch $databasename
	echo $3 >> $1 
	;;
	insert)
	if [ $# -lt 6 ]; then
		echo -e "Not enough details about the car\nPlease enter Make, Model, Year, Color "
	fi
	echo $3"," $4"," $5"," $6 >> $1 
	;;
	display)
	if [ $3 = "all" ]; then
		cat $1
	elif [ $3 = "single" ]; then
		sed -n -e "$(($4+1))p" $1
	elif [ $3 = "range" ]; then
		sed -n -e "$(($4+1)),$(($5+1))p" $1
	else 
		echo -e "Plese specify what lines you would like to print\nUsing all, single, or range"
	fi
	;;
	delete)
	if [ $3 = "all" ]; then
		sed -i "2,$ d" $1
		echo "all items deleted"
	elif [ $3 = "single" ]; then
		sed -i "$(($3+1))d" $1
		echo "1 item deleted"
	elif [ $3 = "range" ]; then
		sed -i "$(($4+1)),$(($5+1))d" $1
		echo "$(($5-$4+1)) items deleted"
	else 
		echo -e "Plese specify what lines you would like to delete\nUsing all, single, or range"
	fi
	;;
	count)
	count=$(grep -o , $1 | wc -l)
	echo $((count/3))
	;;
esac
