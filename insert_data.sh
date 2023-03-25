~#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL 'TRUNCATE TABLE games,teams;')
echo $($PSQL 'ALTER SEQUENCE games_game_id_seq RESTART;')
echo $($PSQL 'ALTER SEQUENCE teams_team_id_seq RESTART;')
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $WINNER != winner ]]
  then
    echo $WINNER
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
      if [[ INSERT_WINNER_TEAM == "INSERT 0 1" ]]
      then
        echo INSERTED TEAM: $WINNER
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
      
    fi
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
      if [[ INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
      then
        echo INSERTED TEAM: $OPPONENT
      fi
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    fi
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND', $WINNER_ID, $OPPONENT_ID, $W_GOALS, $O_GOALS);")
    if [[ INSERT_GAME == "INSERT 0 1" ]]
    then
      echo INSERTED TEAM: $OPPONENT
    fi
  fi

done