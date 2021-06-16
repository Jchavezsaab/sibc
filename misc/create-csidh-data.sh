#!/bin/bash

# this generates all the required data for csidh

echo '# logs generated by create-csidh-data.sh'

declare -a configuration=(\
    "--prime p512 --style df --exponent 10" \
    "--prime p512 --style wd1 --exponent 10" \
    "--prime p512 --style wd2 --exponent 5" \
    "--prime p1024 --style df --exponent 3" \
    "--prime p1024 --style wd1 --exponent 3" \
    "--prime p1024 --style wd2 --exponent 2" \
    "--prime p1792 --style df --exponent 2" \
    "--prime p1792 --style wd1 --exponent 2" \
    "--prime p1792 --style wd2 --exponent 1" \
    "--prime p2048 --style df --exponent 1" \
    "--prime p2048 --style wd1 --exponent 1" \
    "--prime p2048 --style wd2 --exponent 1" \
    "--prime p4096 --style df --exponent 1" \
    "--prime p4096 --style wd1 --exponent 1" \
    "--prime p4096 --style wd2 --exponent 1" \
    "--prime p5120 --style df --exponent 1" \
    "--prime p5120 --style wd1 --exponent 1" \
    "--prime p5120 --style wd2 --exponent 1" \
    "--prime p6144 --style df --exponent 1" \
    "--prime p6144 --style wd1 --exponent 1" \
    "--prime p6144 --style wd2 --exponent 1" \
    "--prime p8192 --style df --exponent 1" \
    "--prime p8192 --style wd1 --exponent 1" \
    "--prime p8192 --style wd2 --exponent 1" \
    "--prime p9216 --style df --exponent 1" \
    "--prime p9216 --style wd1 --exponent 1" \
    "--prime p9216 --style wd2 --exponent 1"
    )

for i in `eval echo {0..${#configuration[@]}}`; do
    echo
    echo "# $(date) # Base configuration: ${configuration[$i]}"
    prime=`echo "${configuration[$i]}" | sed -E 's/.*--prime (.*) --style.*/\1/'`
    sibc-precompute-sdacs --prime $prime --algorithm csidh
    for multievaluation in "--multievaluation" ""; do
        echo "# Processing: sibc ${configuration[$i]} --formula hvelu --algorithm csidh $multievaluation csidh-precompute-parameters"
        sibc ${configuration[$i]} --formula hvelu --algorithm csidh $multievaluation csidh-precompute-parameters
        for tuned in "--tuned" ""; do
            for formula in tvelu svelu hvelu; do
                    if [ "$formula" == "tvelu" ] && ([ "$multievaluation" != "" ] || [ "$tuned" != "" ])
                    then
                        continue
                    fi
                    echo "# Processing: sibc ${configuration[$i]} --formula $formula --algorithm csidh $multievaluation $tuned -u csidh-precompute-strategy"
                    sibc ${configuration[$i]} --formula $formula --algorithm csidh $multievaluation $tuned -u csidh-precompute-strategy
                done
            done
    done
done
echo
echo "# create-csidh-data.sh finished at $(date)"

