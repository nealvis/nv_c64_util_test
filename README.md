# nv_c64_util_test
This repository contains test programs for the [https://github.com/nealvis/nv_c64_util](https://github.com/nealvis/nv_c64_util) repository.  Each folder contains one or more programs that test a particular part of nv_C64_util.

# Setup
## Repositories
To use the test programs, clone this repository into an empty directly and then clone [https://github.com/nealvis/nv_c64_util](https://github.com/nealvis/nv_c64_util) as well.  These commands will do that:
1. `git clone https://github.com/nealvis/nv_c64_util.git`
2. `git clone https://github.com/nealvis/nv_c64_util_test.git`
Its important that these repositories are cloned into the same directory because the test repo assumes the util repo will be at that relative location. After you have cloned both you should have one directory with two subdirectories named nv_c64_util and nv_c64_util_test.

## Building
In order to build the code in this repository you will need to setup kick assembler and other tools the same as needed for the nv_c64_util repository.  The instructions for that are in the [environment and tools setup page](https://github.com/nealvis/nv_c64_util/blob/master/env_setup.md) in that repo.

Each directory in this repository has at least one program that can be run to test something.  Some directories have more than one program in them.  Almost all the programs are a single .asm source file.  The easiest way to run them is to open the folder that contains a program you want to run in VS Code.  As long as the Kick Assembler extension is installed per the environment and tools setup page pressing F6 will build and run the currently open .asm file with in the VICE emulator.

















