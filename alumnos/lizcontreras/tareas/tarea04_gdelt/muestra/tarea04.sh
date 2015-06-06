#!/bin/bash

#1. Reemplazar el bloque de cut por awk

# En serie
for gdelt_file in *.zip
do
unzip -p $gdelt_file | \
#cut -f3,27,31 | \
awk -F' ' '{print $3, $27, $31}' | \
awk '{$2 = substr($2,0,2); print $0 }' | \
awk '{
  evento[$1,$2]++;
  goldstein_scale[$1,$2]+=$3
} END { for (i in evento) print i "\t" evento[i]"\t"goldstein_scale[i]}'
done | \
awk  '{
  evento[$1]+=$2;
  goldstein_scale[$1]+=$3
} END {
  for (i in evento)
    print substr(i, 0, 4) "\t" substr(i,5,2) "\t" substr(i,8,2) "\t" evento[i] "\t" goldstein_scale[i]/evento[i]
}' | \
sort -k1 -k2

#En paralelo
find . -type f -name '*.zip' -print0 | \
parallel -0 -j100% \
"unzip -p {} | \
# cut -f3,27,31 | \
awk -F' ' '{print \$3, \$27, \$31}' | \ 
awk '{\$2 = substr(\$2,0,2); print \$0 }' | \
awk '{
  evento[\$1,\$2]++;
  goldstein_scale[\$1,\$2]+=\$3
} END { for (i in evento) print i FS evento[i] FS goldstein_scale[i]}'" | \
awk  '{
  evento[$1]+=$2;
  goldstein_scale[$1]+=$3
} END { for (i in evento) print substr(i, 0, 4) "\t" substr(i,5,2) "\t" substr(i,8,2) "\t" evento[i] "\t" goldstein_scale[i]/evento[i]}' | sort -k1 -k2

#2. Sustituir awk por mawk que dificultad se presenta

#En awk es substr(string, start, length)

#En mawk substr(s,i,n)  substr(s,i) 
 # Returns the substring of string s, starting at  index  i, of  length n.  If n is omitted, the suffix of s, starting at i is returned.


