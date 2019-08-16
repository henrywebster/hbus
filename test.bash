#!/usr/bin/env bash

function no_config() {
    if ./hbus.bash; then
        return 1
    else
        return 0
    fi
}

TESTS=(
    no_config
)

PASSED=0

for test_case in ${TESTS[@]}; do
    if $test_case; then
        printf "%s passed!\n" $test_case
        PASSED=$((PASSED+1))
    else
        printf "%s failed!\n" $test_case 1>&2
    fi
done

printf "[final results] \n %s / %s\n" $PASSED ${#TESTS[@]}

if [ "$PASSED" -eq "${#TESTS[@]}" ]; then
    echo "all tests passed!"
    exit 0
else
    echo "test cases failed!" 1>&2
    exit 1
fi
