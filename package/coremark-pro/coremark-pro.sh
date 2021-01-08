#!/bin/sh
# SPDX-License-Identifier: Apache-2.0

workloads="cjpeg-rose7-preset core linear_alg-mid-100x100-sp \
    loops-all-mid-10k-sp nnet_test parser-125k radix2-big-64k sha-test zip-test"

rm -rf /tmp/coremark-pro
mkdir -p /tmp/coremark-pro
cp /usr/share/coremark-pro/Rose256.bmp /tmp/coremark-pro
cp /usr/share/coremark-pro/logs/*.size.log /tmp/coremark-pro

cd /tmp/coremark-pro

for contype in single best; do
    cat /usr/share/coremark-pro/util/perl/headings.txt >>result.log
    for wld in $workloads; do
        [ "$contype" = "single" ] && XCMD="-c1 -w1"
        [ "$contype" = "best" ] && XCMD="-c$(nproc) -w$(nproc)"
        echo "#Results for verification run started at $(date +%y%j:%H:%M:%S) XCMD=$XCMD" >$wld-$contype-result.log
        echo "Verification run for $wld"
        $wld $XCMD -v1 > $wld.run.log
        LC_ALL=C perl /usr/share/coremark-pro/util/perl/results_parser.pl $wld-$contype-result.log $wld.run.log
        echo "#Results for performance runs started at $(date +%y%j:%H:%M:%S) XCMD=$XCMD" >>$wld-$contype-result.log
        echo "Performance run for $wld"
        for i in 1 2 3; do
            $wld $XCMD -v0 > $wld.run.log
            LC_ALL=C perl /usr/share/coremark-pro/util/perl/results_parser.pl $wld-$contype-result.log $wld.run.log
        done
        echo "#Median for final result $wld" >>$wld-$contype-result.log
        LC_ALL=C perl /usr/share/coremark-pro/util/perl/cert_median.pl $wld-$contype-result.log $contype >>$wld-$contype-result.log
        cat $wld-$contype-result.log >>result.log
    done
done
LC_ALL=C perl /usr/share/coremark-pro/util/perl/cert_mark.pl -i result.log -s coremarkpro > result.mark
cat result.mark
cd - >/dev/null
