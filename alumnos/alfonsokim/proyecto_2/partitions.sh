#/bin/bash

for y in {1979..2015}
do
   echo "CREATE TABLE gdelt_y$y ( CHECK ( Year >= $y AND Year < $y ) ) INHERITS ( gdelt_reduced );"
done
