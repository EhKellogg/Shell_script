#!/bin/bash
#word = $2
loop=y
#if no arguments are supplied then it enters interactive mode
if [ $# -eq 0 ]; then
	#loops through script while its in interactive mode so you can keep using it
	while [ $loop = y ]; do
		echo -e "You are in Interactive mode\nPlease choose from the following commands to complete"
		echo -e "Create: creates a database and a title for the database\nInsert: inserts a new car to track"
		echo -e "Display: displays the contents of the database in the form of all, single item, or a range of items"
		echo -e "Delete: deletes the contents of the databse in the form of all, single item, or a range of items"
		echo -e "Count: shows how many items are in the database\n"
		read -p "Please enter what you would like to do: " command
		#creates a new database and adds a title with a default as untitled database
		if [ $command = create ]; then
			read -p "Enter database name and title of database: " dbname title
			touch $dbname
			if [ "$title" = "" ]; then
				title="Untitled Database"
			fi
			echo $title >> $dbname 
		#inserts items into the database must have four arguments
		elif [ $command = insert ]; then			
			read -p "Enter the database name and the details of the car in this order: Make, Model, year(####), and color: " dbname Make Model year color 
			echo $Make"," $Model"," $year"," $color >> $dbname 
			echo "Successfully added a record to the database"
		#displays the items in the database
		elif [ $command = display ]; then
			read -p "Enter the database name to display and how many lines you like to display with all, single and the line you would like to print, or range and the range of lines to print: " dbname operation 
			if [ "$operation" = all ]; then
				cat $dbname
			elif [ "$operation" = single ]; then
				read -p "Enter the line number you like to display: " line
				sed -n -e "$(($line+1))p" $dbname
			elif [ "$operation" = "range" ]; then
				read -p "Enter the line numbers in the range you would like printed: " num1 num2
				sed -n -e "$(($num1+1)),$(($num2+1))p" $dbname
			else 
				echo -e "Plese specify what lines you would like to print\nUsing all, single, or range"
			fi
		#deletes the specific lines in the database
		elif [ $command = delete ]; then
			read -p "Enter the database name and the number of lines you would like to delete with: all, single, or range: " dbname operation
			if [ $operation = "all" ]; then
				sed -i "2,$ d" $dbname
				echo "all items deleted"
			elif [ $operation = "single" ]; then
				read -p "Enter the line you would like to delete: " line
				sed -i "$(($line+1))d" $dbname
				echo "1 item deleted"
			elif [ $operation = "range" ]; then
				read -p "Enter the line numbers in the range you would like to delete: " num1 num2
				sed -i "$(($num1+1)),$(($num2+1))d" $dbname
				echo "$(($5-$4+1)) items deleted"
			else 
				echo -e "Plese specify what lines you would like to delete\nUsing all, single, or range"
			fi
		#counts the number of items in the database
		elif [ $command = count ]; then
			read -p "Enter the database to find out how many entries are in it: " dbname
			count=$(grep -o , $dbname | wc -l)
			echo $((count/3))	
		fi
		read -p "Would you like to do something else (y/n)? " loop


	done

elif [ $# -eq 1 ]; then
	echo "Missing database name or bash function"

fi
#takes the 2nd argument to give the script directions on what to do
word=$2
case $word in 
	#creates databases
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
	#inserts items and if there aren't enough arguments supplied it gives an error
	insert)
	if [ $# -lt 6 ]; then
		echo -e "Not enough details about the car\nPlease enter Make, Model, Year, Color "
	fi
	echo $3"," $4"," $5"," $6 >> $1 
	echo "Successfully added a record to the database"
	;;
	#displays the items in the database
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
	#deletes items in the database
	delete)
	if [ $3 = "all" ]; then
		sed -i "2,$ d" $1
		echo "all items deleted"
	elif [ $3 = "single" ]; then
		sed -i "$(($4+1))d" $1
		echo "1 item deleted"
	elif [ $3 = "range" ]; then
		sed -i "$(($4+1)),$(($5+1))d" $1
		echo "$(($5-$4+1)) items deleted"
	else 
		echo -e "Plese specify what lines you would like to delete\nUsing all, single, or range"
	fi
	;;
	#counts the items and displays the number 
	count)
	count=$(grep -o , $1 | wc -l)
	echo $((count/3))
	;;
esac
