for i in {0..920}; do
step=7
start=`echo "$step * ($i + 0)" | bc`
end=`echo "$step * ($i + 1)" | bc`
echo $i $start $end

OMP_NUM_THREADS=1 \
condor_run -a accounting_group=cbc.imp.search -a request_memory=10000 unbuffer python ./pycbc_brute_bank \
--verbose \
--output-file emri-$i.hdf \
--minimal-match 0.92 \
--tolerance .005 \
--buffer-length 64 \
--sample-rate 1024 \
--tau0-threshold 0.5 \
--approximant HMR \
--tau0-crawl 1 \
--tau0-start $start \
--tau0-end $end \
--psd-file o3psd.txt \
--fixed-params duration \
--fixed-values 60.0 \
--params mass1 mass2 \
--min 0.01 20 \
--max 0.1 100 \
--seed 1 \
--low-frequency-cutoff 20.0 > $i.out &
sleep 0.25
done
