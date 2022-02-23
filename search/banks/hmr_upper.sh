for i in {0..261}; do
step=5
start=`echo "$step * ($i + 0)" | bc`
end=`echo "$step * ($i + 1)" | bc`
echo $i $start $end

OMP_NUM_THREADS=1 \
condor_run -a accounting_group=cbc.prod.search -a request_memory=40000 unbuffer python ./pycbc_brute_bank \
--verbose \
--output-file emri-$i.hdf \
--minimal-match 0.96 \
--tolerance .005 \
--buffer-length 64 \
--sample-rate 2048 \
--tau0-threshold 0.5 \
--approximant HMR \
--tau0-crawl 2 \
--tau0-start $start \
--tau0-end $end \
--psd-file o3psd.txt \
--fixed-params duration \
--fixed-values 60.0 \
--params mass1 mass2 \
--min 0.1 7.0 \
--max 1 100 \
--seed 1 \
--low-frequency-cutoff 20.0 > $i.out &
sleep 1
done
