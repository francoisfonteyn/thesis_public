# Test files for comprehensions
---
This directory contains all the files composed with all the tests executed. They aim to be executed by shell using the command

	run.sh
Use the -h option to get help.

All the *.oz* files are test files except *Tester.oz* which is a functor used by all tests to execute. Performance tests are in all the files *(Space|Time)_Performance_X.oz* where X goes from 01 to 10. The results of all the performance tests are in *results.txt*. To parse these results into a LaTeX tabular, use

	python results_parse.py

The directory *Applications* contains small examples.
