#/bin/bash/sh

strategy=$1
topology=$2
total_node=$3
interest_freq=$4
wifi=$5
range=$6
log_file_name="log/${7}"
l3_file_name=$8
app_delay_file_name=$9
l2_file_name=${10}
consumer_node=${11}
producer_node=${12}

#diagonal_connection="no"
#alpha=05

compiled_data_file="clf_compiled_data.csv"

interest_count=$(awk '{if($3==257) print $N}' $l3_file_name | grep -w OutInterests | awk '{total += $8} END{print total}')
data_count=$(awk '{if($3==257) print $N}' $l3_file_name | grep -w OutData | awk '{total += $8} END{print total}')
protocl_overhead=$((interest_count + data_count))

# satisfaction ratio of consumer node
out_sat_int=$(awk -v cn="$consumer_node" '{if($3==257 && $2 == cn) print $N}' $l3_file_name | grep -w OutSatisfiedInterests | awk '{print $8}')
out_int=$(awk -v cn="$consumer_node" '{if($3==257 && $2 == cn) print $N}' $l3_file_name | grep -w OutInterests | awk '{print $8}')
sat_ratio=$(bc <<< "scale=2; $out_sat_int/$out_int")

avg_delay=$(awk '{if (NR > 1) {total += $7}} END{print total/NR}' $app_delay_file_name)
nin_five_th_delay=$(awk '{if(NR > 1) print $7}' $app_delay_file_name | awk '{printf "%.6f\n", $1}' | sort -n | awk '{all[NR] = $0} END{print all[int(NR*0.95 - 0.5)]}')
fifth_delay=$(awk '{if(NR > 1) print $7}' $app_delay_file_name | awk '{printf "%.6f\n", $1}' | sort -n | awk '{all[NR] = $0} END{print all[int(NR*0.05 + 0.5)]}')
median_delay=$(awk '{if(NR > 1) print $7}' $app_delay_file_name | sort -n | awk ' { a[i++]=$1; } END { x=int((i+1)/2); if (x < (i+1)/2) print (a[x-1]+a[x])/2; else print a[x-1]; }')

time_out_interest=$(grep -a "ndn.Consumer:OnTimeout" $log_file_name | wc -l)
hop_count=$(awk '{if(NR > 1) print $9}' $app_delay_file_name | sort -n | awk ' { a[i++]=$1; } END { x=int((i+1)/2); if (x < (i+1)/2) print (a[x-1]+a[x])/2; else print a[x-1]; }')

if [ ! -f "$compiled_data_file" ]; then
    echo "Strategy, MobilityType, Topology, TotalNode, InterestFrequency, ProtocolOverhead, SatisfactionRatio, 95thPercentileDelay, 5thPercentileDelay, MedianDelay, TimeOutInt" > $compiled_data_file
fi

echo "$strategy, $topology, ${consumer_node}_${producer_node}, $total_node, $interest_freq, $protocl_overhead, $sat_ratio, $nin_five_th_delay, $fifth_delay, $median_delay, $hop_count, $time_out_interest, $interest_count, $data_count" >> $compiled_data_file
