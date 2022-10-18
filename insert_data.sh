#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo  $($PSQL "TRUNCATE TABLE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
  #get the team id if already added to db
   WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

  #if name of the team is not already in the table 
   if [[ -z $WINNER_ID ]]
   then
    #insert name of the team
    INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    #get the new team id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
   fi

  #if name of the team is not already in the table 
   if [[ -z $OPPONENT_ID ]]
   then 
   #insert name of the team
    INSERT_TEAM_OP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    #get the team id
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
   fi
   
   #insert values in the games table
   INSERT_RESULT=$($PSQL "INSERT INTO 
                   games(year,round,winner_id,opponent_id,winner_goals,opponent_goals)
                   VALUES('$YEAR','$ROUND',$WINNER_ID,$OPPONENT_ID,'$WINNER_GOALS','$OPPONENT_GOALS')")
   if [[ $INSERT_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into teams, $YEAR,$WINNER_ID,$WINNER,$OPPONENT_ID,$OPPONENT
    fi
  fi
done
