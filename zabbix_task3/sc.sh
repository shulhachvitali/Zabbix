#!/bin/bash
curl -sL -w "%{http_code} \\n" "http://192.168.33.26:8080" -o /dev/null
