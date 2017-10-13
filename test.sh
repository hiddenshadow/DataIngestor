#!/bin/bash
#local root Bima1


COUNT=10
STR=101
END=$(($STR+$COUNT-1))


# i=2

# if [ $i -lt 3 ]; then
# 	echo 'asd'
# fi


# CUR_TIME_SEC=$(date +%s)
# echo "$CUR_TIME_SEC"

# echo "$CUR_TIME_SEC"

# FIRST_NAMES=('Rahul' 'Raina' 'Dhoni')
declare -a FIRST_NAMES=("redhat" "debian" "gentoo")
FIRST_NAMES_LEN=${#FIRST_NAMES[@]}

echo 'FIRST_NAMES_LEN: '$FIRST_NAMES_LEN

for i in $(seq $STR $END)
do
	echo ''
	echo 'i:'$i;

	f=$(shuf -i 0-$(($FIRST_NAMES_LEN-1)) -n 1)
	echo 'f:'$f

	echo ${FIRST_NAMES[$f]}
done

# # CUR_TIME_SEC=$(date +%s)
# CUR_TIME_SEC_CMD='date +%s'
# echo $CUR_TIME_SEC_CMD

# OUT=$("($CUR_TIME_SEC_CMD)")
# echo $OUT



# define array
# name server names FQDN
# NAMESERVERS=("ns1.nixcraft.net." "ns2.nixcraft.net." "ns3.nixcraft.net.")

# tLen=${#NAMESERVERS[@]}# use for loop read all nameservers
# for (( i=0; i<${tLen}; i++ ));
# do
# echo ${NAMESERVERS[$i]}
# done



# ## declare an array variable
# declare -a arr=("element1")

# ## now loop through the above array
# for i in "${arr[@]}"
# do
#    echo "$i"
#    # or do whatever with individual element of the array
# done