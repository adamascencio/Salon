#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU() {
  if [[ ! -z "$1" ]];
  then echo -e "$1\n";
  fi

  SERVICES=$($PSQL "SELECT * FROM services;")
  
  echo $SERVICES | while read -r SERVICE_1 SERVICE_2 SERVICE_3
  do 
    echo $SERVICE_1 | sed 's/|/) /';
    echo $SERVICE_2 | sed 's/|/) /';
    echo $SERVICE_3 | sed 's/|/) /';
  done 

  read SERVICE_ID_SELECTED
  SELECTED_SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")

  if [[ -z $SELECTED_SERVICE ]];
  then 
    MAIN_MENU "I could not find that service. What would you like today?";
  else 
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

    if [[ -z $CUSTOMER_NAME ]];
    then
      echo -e "\nWhat's your name?"
      read CUSTOMER_NAME;
      INSERTED_CUSTOMER_DATA=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME');")
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME';")
    echo -e "\nWhat time would you like your $SELECTED_SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME
    INSERTED_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME');")
    echo -e "\nI have put you down for a $SELECTED_SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU