#!/bin/bash

# COUNT=1000
COUNT=1

STR=101
END=$(($STR+$COUNT-1))

DB_HOST='bima-mentor.coic6imdwwxx.ap-south-1.rds.amazonaws.com'
DB_PORT=6603
DB_USER='root'
DB_PASSWORD='Hellobima'
DB_DATABASE='allocator'

USER_NAME='user_name'
USER_FIRST_NAME='user_last_name'
USER_LAST_NAME='user_last_name'
USER_NAME='user_name'
USER_MOBILE=1200068927
USER_EMAIL='user_name@junk.kom'
USER_PASSWORD_TOKEN='user_name_token'
CREATED_DATE='NOW()'
CREATED_BY=1010
USER_PASSWORD_TOKEN_EXPIRY='now() + INTERVAL 1 DAY'

QUERY='insert into bima_user 
(user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, user_password_token, 
user_password_token_expiry, created_by, created_date) values 
("'$USER_NAME'", "'$USER_FIRST_NAME'", "'$USER_LAST_NAME'", "'$USER_NAME'",'$USER_MOBILE',"'$USER_EMAIL'", "'$USER_PASSWORD_TOKEN'", '$USER_PASSWORD_TOKEN_EXPIRY', '$CREATED_BY', '$CREATED_DATE')'


# SSH_CMD='mysql -h '$DB_HOST' -u '$DB_USER' -p'$DB_PASSWORD' -e '$QUERY
SSH_CMD=$QUERY


for i in $(seq $STR $END)
do
  echo 'i:'$i;
  echo $SSH_CMD;

done


echo 'Done inserting '$COUNT' entries.'


# mysql -h host -u root -proot -e "show databases;";


# user_name - unique - using count
# user_password - same as user_name
# user_mobile - starting with 1, append count
# user_password_token - append count
# user_password_token_expiry - set time in future ?

# id, user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, user_password_token, user_password_token_expiry, user_status, is_mobile_verified, is_email_verified, user_retry_count, created_by, updated_by, created_date, updated_date, user_availability