#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != year ]]
  then
    # get winner team_id
    WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    echo $WINNER_TEAM_ID
    # if not found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      # insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_WINNER_RESULT
      # get new team_id
      WINNER_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name=('$WINNER')")
      echo $WINNER_TEAM_ID
    fi

    OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    # if not found
    if [[ -z $OPPONENT_TEAM_ID ]]
    then
      # insert team
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_OPPONENT_RESULT
      # get new team_id
      OPPONENT_TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name=('$OPPONENT')")
      echo $OPPONENT_TEAM_ID
    fi
    if [[ -n $WINNER_TEAM_ID ]]
    then
      # insert game
      INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
      echo $INSERT_GAME_RESULT
      echo "Game inserted"
    fi
  fi


  
done