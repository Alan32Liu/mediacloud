#!/bin/bash

supervisorctl -c `dirname "$0"`/supervisord.conf -s http://localhost:4398 -u supervisord -p qHujfp7n4J $*