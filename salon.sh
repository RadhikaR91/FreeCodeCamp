#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU(){
   if [[ $1 ]]
   then
     echo -e "\n$1"
   fi

  AVAILABLE_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
      echo "$SERVICE_ID) $NAME"
    done
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
     1 | 2 | 3 | 4 | 5) ADD_APPOINTMENT ;;
     *) MAIN_MENU "I could not find that service. What would you like today?"
  esac
  
}

ADD_APPOINTMENT(){
  
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  #get customer's phone number
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  #get customer info
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  #if customer name does not exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get customer's name
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
   
    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')") 
  fi
    #get customer id
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    #get the customers comfortable time for the service 
    echo -e "\nWhat time would you like your $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g'), $CUSTOMER_NAME?"
    read SERVICE_TIME

    #create an appointment for the customer
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(time,customer_id,service_id) VALUES('$SERVICE_TIME',$CUSTOMER_ID ,$SERVICE_ID_SELECTED)")
    echo -e  "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU "Welcome to My Salon, how can I help you?\n"