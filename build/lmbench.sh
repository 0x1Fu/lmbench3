os=`uname -s`

if [ $os = "Darwin" ]; then
	ncpus=`sysctl -n hw.ncpu`
elif [ $os = 'Linux' ]; then
	ncpus=`cat /proc/cpuinfo | grep "processor" | wc -l`
else
	echo Warning: Unsupported OS \'$os\'
	exit
fi

if [ $ncpus = '6' ]; then
	all_cores=(
		'-' '1' '5'
		'0 1 2 3' '4 5'
	)
elif [ $ncpus = '8' ]; then
	all_cores=(
		'-' '1' '5' '7'
		'0 1 2 3' '6 7'
	)
else
	echo Warning: Unsupported cpus \'$ncpus\'
	exit
fi

timestamp() {
	echo time: `date "+%Y%m%d_%H%M%S"`
}

bw_mem() {
	echo -n 'bw_mem' $@ ' '
	./bw_mem $@
	[ ! -z "$interval" ] && sleep $interval
}

bw_mem_all() {
	IFS=" " ncores="($@)"
	ops=(
		'rd' 'wr' 'rdwr' 'cp' 'fwr' 'frd' 'fcp' 'bzero' 'bcopy'
	)
	sizes=(
		'2k' '4k' '8k' '16k' '32k' '48k' '64k' '96k' '128k' '256k' '512k'
		'1m' '2m' '3m' '4m' '5m' '6m' '7m' '8m' '9m' '10m' '11m' '12m' '13m' '14m' '15m' '16m'
		'32m' '48m' '64m' '96m' '128m' '256m'
	)
	for op in ${ops[@]}; do
		echo --- begin bw_mem $op ---
		for size in ${sizes[@]}; do
			bw_mem -P ${#ncores[@]} $size $op
		done
		echo --- end ---
	done
}

lat_mem_rd() {
	echo --- begin lat_mem_rd $@ ---
	./lat_mem_rd $@
	[ ! -z "$interval" ] && sleep $interval
	echo --- end ---
}

lat_mem_rd_all() {
	size="200M"
	strides=(1024 4096 16384)
	for stride in ${strides[@]}; do
		lat_mem_rd -P $1 $size $stride
		lat_mem_rd -P $1 -t $size $stride
	done
}

while getopts "i:" opt; do
    case "$opt" in
    i) interval=$OPTARG
       ;;
    esac
done

timestamp
[ ! -z "$interval" ] && echo interval: $interval
echo system: `uname -a`

IFS="."
for cores in ${all_cores[@]}; do
	IFS=" " ncores="($cores)"
	echo === begin "[$cores] (${#ncores[@]})" ===

	if [ ${#ncores[@]} = "1" ] && [ $cores = "-" ]; then
		export LMBENCH_SCHED=
	else
		export LMBENCH_SCHED="CUSTOM $cores"
	fi

	if [ ${#ncores[@]} = "1" ]; then
		lat_mem_rd_all ${#ncores[@]}
	fi

	bw_mem_all $cores

	echo === end ===
	echo
done

timestamp
