echo "# get i# of Data that reached Consumer: "
grep "onOutgoingData" test_beacon.log > temp.log
for i in {0..59}; do grep /test/prefix/a/b/$i/ temp.log | awk '{if ($2 == 0) print $7}'; done | uniq 

echo " # of Data that was sent by producer: "
for i in {0..59}; do grep /test/prefix/a/b/$i/ temp.log | awk '{if ($2 == 19) print $7}'; done | uniq 
