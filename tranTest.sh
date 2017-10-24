#!/bin/bash

COUNT=2

STR=1
END=$(($STR+$COUNT-1))

DB_HOST='localhost'
DB_PORT=3306
DB_USER='root'
DB_PASSWORD='Bima1'
DB_DATABASE='allocator'

declare -a FIRST_NAMES=("Rahul" "Suresh" "Mahendra" "Murali" "Ashwin" "Virat" "Sourav" "Venkat")
FIRST_NAMES_LEN=${#FIRST_NAMES[@]}

declare -a FIRST_NAMES_FEM=("Jhansi" "Aishwarya" "Vijaya" "Catherine" "Shamili" "Urmila" "Ramya" "Jaya")
FIRST_NAMES_FEM_LEN=${#FIRST_NAMES[@]}

declare -a LAST_NAMES=("Dravid" "Raina" "Dhoni" "Karthik" "Ramchandra" "Kohli" "Ganguly" "Laxman")
LAST_NAMES_LEN=${#LAST_NAMES[@]}

CREATED_DATE='NOW()'
CREATED_BY=10109
USER_PASSWORD='r5SPC2M0xdboIsm8jPJANA=='
CID_MIN=1; 
CID_MAX=5;
ROLE_ID_MIN=1;
ROLE_ID_MAX=4;
USER_ROLE_STATUS_MIN=1;
USER_ROLE_STATUS_MAX=1;
DEPENDANT_COUNT_MIN=1;
DEPENDANT_COUNT_MAX=3;
MSISDN_MIN=11111111;
MSISDN_MAX=19999999;
DEP_STATUS_MIN=1;
DEP_STATUS_MAX=1;
AGE_MIN=1;
AGE_MAX=111;
VALUES=''

SSH_CMD="mysql -h'"$DB_HOST"' -P"$DB_PORT" -u'"$DB_USER"' -p'"$DB_PASSWORD"' -s -N -e'"

USER_INSERT_QUERY='insert into '$DB_DATABASE'.bima_user (user_name, user_first_name, user_last_name, user_password, user_mobile, user_email, created_by, created_date) values '



SELECT_LAST_INSERTED='SELECT LAST_INSERT_ID();'

INSERT_USER_ROLE_QUERY='insert into '$DB_DATABASE'.bima_user_role_permission (user_id, partner_country_id, role_id, status, created_by, created_date) values '

INSERT_DEPENDANT_QUERY='insert into '$DB_DATABASE'.bima_customer (user_id, first_name, last_name, msisdn, status, created_by, created_date) values '

INSERT_DEP_META_QUERY='insert into '$DB_DATABASE'.customer_meta_data (customer_id, meta_key, meta_value, created_by, created_date) values '

BEGIN_TXN='BEGIN work;';
END_TXN="commit;"

LAST_USER_ID_QRY='select @userId := LAST_INSERT_ID();'

LAST_CUST_ID_QRY='SELECT @custId := LAST_INSERT_ID();'
CUST_ID='@custId'

for i in $(seq $STR $END)
do
  	echo 'Inserting user number: '$i;
  	CUR_VALUE=''

  	fn=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)
  	lna=$(shuf -i 0-$(($LAST_NAMES_LEN-1)) -n 1)
  	USER_MOBILE=$(shuf -i 1230000000-1239999999 -n 1)

	CUR_TIME_SEC=$(date +%s)
	USER_NAME='un_'$CUR_TIME_SEC'_'$i
	USER_FIRST_NAME=${FIRST_NAMES[$fn]}
	USER_LAST_NAME=${LAST_NAMES[$lna]}
	USER_EMAIL=$USER_NAME'@junk.kom'

	PARTNER_COUNTRY_ID=$(shuf -i $CID_MIN-$CID_MAX -n 1)
	ROLE_ID=$(shuf -i $ROLE_ID_MIN-$ROLE_ID_MAX -n 1)
	USER_ROLE_STATUS=$(shuf -i $USER_ROLE_STATUS_MIN-$USER_ROLE_STATUS_MAX -n 1)

	CUR_VALUE='("'$USER_NAME'","'$USER_FIRST_NAME'","'$USER_LAST_NAME'","'$USER_PASSWORD'",'$USER_MOBILE',"'$USER_EMAIL'",'$CREATED_BY','$CREATED_DATE')'
	
	CUR_USER_INSERT_QUERY=$USER_INSERT_QUERY' '$CUR_VALUE';'$LAST_USER_ID_QRY

	INSERT_USER_ROLE_VAL='(@userId, '$PARTNER_COUNTRY_ID', '$ROLE_ID', '$USER_ROLE_STATUS', '$CREATED_BY','$CREATED_DATE')'

	CUR_INSERT_USER_ROLE=$INSERT_USER_ROLE_QUERY' '$INSERT_USER_ROLE_VAL';'

	CUR_TXN=$SSH_CMD''$BEGIN_TXN''$CUR_USER_INSERT_QUERY''$CUR_INSERT_USER_ROLE''$END_TXN"  select @userId;'"

	echo 'Executing query : '$CUR_TXN;
	eval $CUR_TXN &> a.out
	cat a.out >> all.out

	LAST_USER_ID=`cat a.out | tail -1 | awk '{ print $1}'`
	echo '	LAST_USER_ID: '$LAST_USER_ID

	if [ $LAST_USER_ID -gt 0 ]
	then

		echo "		Inserting customers for: "$LAST_USER_ID
		DEPENDANT_COUNT=$(shuf -i $DEPENDANT_COUNT_MIN-$DEPENDANT_COUNT_MAX -n 1)
		DEP_LAST_NAME=$USER_LAST_NAME

		echo '		DEPENDANT_COUNT: '$DEPENDANT_COUNT
		for d in $(seq $DEPENDANT_COUNT_MIN $DEPENDANT_COUNT)
		do
			echo '		Inserting customer '$d', for user: '$LAST_USER_ID
			fn=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)

			MSISDN=$(shuf -i $MSISDN_MIN-$MSISDN_MAX -n 1)
			DEP_STATUS=$(shuf -i $DEP_STATUS_MIN-$DEP_STATUS_MAX -n 1)

			# Taking male names in case d is odd.
			rem=$(( $d % 2 ))

			if [ $rem -eq 0 ]
			then
				DEP_FIRST_NAME=${FIRST_NAMES_FEM[$fn]}
				GENDER_VAL="FEMALE"
			else
				DEP_FIRST_NAME=${FIRST_NAMES[$fn]}
				GENDER_VAL="MALE"
			fi

			# (user_id, first_name, last_name, msisdn, status, created_by, created_date)
			CUR_INSERT_DEP_VALUE='('$LAST_USER_ID', "'$DEP_FIRST_NAME'", "'$DEP_LAST_NAME'", '$MSISDN', '$DEP_STATUS', '$CREATED_BY','$CREATED_DATE')'
			CUR_INSERT_DEPENDANT_QUERY=$INSERT_DEPENDANT_QUERY' '$CUR_INSERT_DEP_VALUE';'$LAST_CUST_ID_QRY
			
			# CUR_INSERT_DEPENDANT_QUERY=$SSH_CMD''$CUR_INSERT_DEPENDANT_QUERY"'"
			# echo 'Executing query : '$CUR_INSERT_DEPENDANT_QUERY;
			# eval $CUR_INSERT_DEPENDANT_QUERY &> a.out
			# LAST_DEPENDANT_ID=`cat a.out | tail -1 | awk '{ print $1}'`
			# echo '		LAST_DEPENDANT_ID: '$LAST_DEPENDANT_ID


			CUR_META_VALUES=''

			# CUSTOMER_ID=$LAST_DEPENDANT_ID
		  	META_KEY="GENDER"
		  	META_VALUE=$GENDER_VAL

			# (customer_id, meta_key, meta_value, created_by, created_date)
		  	CUR_META_VALUES='('$CUST_ID',"'$META_KEY'","'$META_VALUE'",'$CREATED_BY','$CREATED_DATE')'
			CUR_INS_DEP_META_GENDER_QRY=$INSERT_DEP_META_QUERY' '$CUR_META_VALUES';'

		  	# CUR_INS_DEP_META_QRY=$SSH_CMD''$CUR_INS_DEP_META_QRY"'"

			# echo 'Executing query : '$CUR_INS_DEP_META_QRY;
			# eval $CUR_INS_DEP_META_QRY &> a.out

			# LAST_DEPENDANT_META_ID=`cat a.out | tail -1 | awk '{ print $1}'`
			# echo '			Gender Meta data Id: '$LAST_DEPENDANT_META_ID

			# if [ $LAST_DEPENDANT_META_ID -le 0 ]
			# then
			# 	echo 'Error inserting meta data Gender for '$LAST_DEPENDANT_ID
			# 	break
			# fi

			# echo '			Adding meta data, Age for customer: '$LAST_DEPENDANT_ID
			META_KEY="AGE"
		  	META_VALUE=$(shuf -i $AGE_MIN-$AGE_MAX -n 1)

		  	CUR_META_VALUES='('$CUST_ID',"'$META_KEY'","'$META_VALUE'",'$CREATED_BY','$CREATED_DATE')'
			CUR_INS_DEP_META_AGE_QRY=$INSERT_DEP_META_QUERY' '$CUR_META_VALUES';'

		  	# CUR_INS_DEP_META_QRY=$SSH_CMD''$CUR_INS_DEP_META_QRY"'"
			# echo 'Executing query : '$CUR_INS_DEP_META_QRY;
			# eval $CUR_INS_DEP_META_QRY &> a.out
			# LAST_DEPENDANT_META_ID=`cat a.out | tail -1 | awk '{ print $1}'`
			# echo '			Age Meta data Id: '$LAST_DEPENDANT_META_ID

			CUST_TXN=$BEGIN_TXN''$CUR_INSERT_DEPENDANT_QUERY''$CUR_INS_DEP_META_GENDER_QRY''$CUR_INS_DEP_META_AGE_QRY''$END_TXN'SELECT '$CUST_ID";'"
			CUST_TXN=$SSH_CMD''$CUST_TXN

			echo 'Executing query : '$CUST_TXN;
			eval $CUST_TXN &> a.out
			cat a.out >> all.out
		done

	else
		echo 'Error inserting user!'
		break
	fi
	echo ''
done


# Should each user also have an entry correspondingly in customer table?
# For each User, insert a customer and random number of dependants.
# For each customer, insert a customer, customer meta data.

# Todo:
# Enable sql logs.