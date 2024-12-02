# advent-of-code-2022
Tooling &amp; Solutions for Advent of Code 2023 problems

## Compile CLI

CLI can be compiled via shards
```shards build```

This will create an executable file in bin named cli

## CLI
CLI currently supports:
- scaffolding of a new solution folder structure with base solution file
- running a solution against a given input file located within the solution folder

You can create a new solution folder by running the following command in the root directory

```bin/cli new -f <folder_name>```

You can run a solution against the sample input by running the following command in the root directory

```bin/cli run -f <folder_name>```

You can also run a solution against an arbitrary input file in ```solutions/<folder_name>/in/<input_name>.in``` with the following command in the root directory

```bin/cli run -f <folder_name> -i <input_name>```

You can also run a solution with debug enabled if the solution has additional debugging output (ex: solution 9)

```bin/cli run -f 9 -i larger -d```


### Supported Systems
Currently MacOS (although not tested after some tweaks for windows) and Git BASH on Windows
