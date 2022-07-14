#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "select * from teams")" 

# read games.csv for teams table
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != 'winner' ]]
  then
    echo $WINNER  
    # get teamd_id if name existed in table
    WINNER_ID = $($PSQL "select team_id from teams where name = '$WINNER'")
    # if team_id = null, insert team name to table teams
    if [[ -z $WINNER_ID ]]
    then
      INSERT_WINNER_RESULT= $($PSQL "insert into teams(name) values ('$WINNER')")
      if [[ $INSERT_WINNER_RESULT = 'INSERT 0 1' ]]
      then
        echo Insert into team, $WINNER
      fi
    fi
  fi

  if [[ $OPPONENT != 'opponent' ]]
  then
    # Get the opponent id of the team
    OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "insert into teams(name) values ('$OPPONENT')")

      if [[ $INSERT_OPPONENT_RESULT = 'INSERT 0 1' ]]
      then
        echo Insert into team, $OPPONENT
      fi
    fi

  fi

done

# read games.csv for games table
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_GOALS OPP_GOALS
do


  if [[ $YEAR != 'year' ]]
  then
  #Get the winner id
  echo $WINNER
  WINNER_TEAM_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
  
  #Get the opponent id
  echo $OPPONENT
  OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")

  INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
  values ($YEAR, '$ROUND', $WINNER_TEAM_ID, $OPPONENT_TEAM_ID, $WIN_GOALS, $OPP_GOALS)")

  if [[ $INSERT_GAME_RESULT = 'INSERT 0 1' ]]
  then
    echo INSERT INTO GAMES, $ROUND
  fi

  fi



done;

# get every value and insert together
