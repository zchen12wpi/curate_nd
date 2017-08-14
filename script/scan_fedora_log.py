#!/usr/bin/env python

# Scan the fedora server logs and identify every fedora object requested.
# outputs a list of each PID (with namespace) without count.
# The environment variable SCAN_OUTPUT_DATE is used to identify which day
# of data should be dumped.
#
# This script is intended to be run by a daily cron job.
# If you want to run it by hand you can do it similar to this:
#
# $ env SCAN_OUTPUT_DATE=2017-08-13 ./scan_fedora_log.py /opt/fedora/server/log/fedora*


import os
import re
import sys

# for the given line, either return a fedora PID (with namespace) or None
def decode_pid(line):
    # decode the modern access route
    m = re.search(r'pid: (?P<pid>[^,]+),', line)
    if m:
        return m.group('pid')
    # decode the older "GET" route
    m = re.search(r'fedora/get/(?P<pid>[^/]+)', line)
    if m:
        return m.group('pid')
    return None

# date string --> Set of PIDS
counts = {}

for fname in sys.argv:
    with open(fname) as f:
        for line in f:
            m = re.match(r'INFO (?P<date>\d{4}-\d\d-\d\d) ', line)
            if m is None:
                continue
            pid = decode_pid(line)
            if pid is None:
                continue
            tab = counts.get(m.group('date'))
            if tab is None:
                tab = set()
                counts[m.group('date')] = tab
            tab.add(pid)

date = os.environ.get("SCAN_OUTPUT_DATE")

for d in counts:
    if date is None or d == date:
        for pid in counts[d]:
            print pid

