#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ $1 ]]
  then
  if [[ $1 =~ ^[0-9]+$ ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1")
  elif [[ ${#1} -le 2 ]]
    then
      ELEMENT=$($PSQL "SELECT atomic_number,name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' ")
  else
      ELEMENT=$($PSQL "SELECT atomic_number ,name ,symbol ,type ,atomic_mass ,melting_point_celsius,boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name LIKE '$1%'")
  fi

  if [[ -z $ELEMENT ]]
    then
     echo "I could not find that element in the database."
  else
     echo "$ELEMENT" | while IFS=\| read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELT_POINT BOIL_POINT
     do
      echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $(echo $NAME | sed -r 's/^ *| *$//g') ($(echo $SYMBOL | sed -r 's/^ *| *$//g')). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g') amu. $(echo $NAME | sed -r 's/^ *| *$//g') has a melting point of $(echo $MELT_POINT | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $BOIL_POINT | sed -r 's/^ *| *$//g') celsius."
     done
  fi
  else
    echo "Please provide an element as an argument."
fi
  
