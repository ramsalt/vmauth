.PHONY: check-ready check-live

host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0
command = curl -s -o /dev/null -H 'Authorization: Bearer ${VICTORIA_METRICS_TOKEN}' -I -w '%{http_code}' http://${host}:8427/debug/pprof/ | grep -q 200
service = vmauth

default: check-ready

check-ready:
	wait_for "$(command)" $(service) $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
