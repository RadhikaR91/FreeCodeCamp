#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\nEnter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
if [[ -z $USER_ID ]]
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM users INNER JOIN games USING(user_id) WHERE username='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN users USING(user_id) WHERE username='$USERNAME'")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUMBER=$(( RANDOM % 1000 + 1 ))
GUESS=1
echo -e "\nGuess the secret number between 1 and 1000:"

while read NUM
do
 if [[ ! $NUM =~ ^[0-9]+$ ]]
 then
   echo -e "\nThat is not an integer, guess again:"
 else
   if [[ $NUM -eq $RANDOM_NUMBER ]]
   then
    echo -e "\nYou guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"
    break;
   elif [[ $NUM -gt $RANDOM_NUMBER ]]
   then
    echo -e "\nIt's lower than that, guess again:"
   elif [[ $NUM -lt $RANDOM_NUMBER ]]
   then
    echo -e "\nIt's higher than that, guess again:"
   fi
 fi
GUESS=$(( $GUESS + 1 ))
done
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username = '$USERNAME'")
INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(guesses,user_id) VALUES($GUESS,$USER_ID)")
