# Test files for comprehensions
---
This directory contains all the files composed with all the tests executed. 

### Generic tests to execute in shell
---
*Generic:* They aim to be executed by shell using the command

    run.sh
Use the -h option to get help.

### Performace tests to execute in shell
*Performance:* They aim to be executed by shell using the command
   
    run.sh
Use the -h option to get help. To parse the results into a Matlab script generating a graph, use

    run.sh -n results.txt && python results_parse.py results.txt

### More complex tests to run in Mozart2
---
The directory *Applications* contains small examples.

The directory *Concurrency* contains concurrent examples.
