# Poker Hand Strength Evaluator

This is an implementation of **Poker Kata** in Ruby. It supports **Texas Hold'em**, **Omaha Hold'em**, and **Five Card Draw**. It assumes that all inputs are correct and have no invalid cards like `Ez`.

### Installation and running

It doesn't require external libraries nor packages. The only necessary thing is a Ruby package with a version higher than 2.7.

It was tested on `Dockerfile` in the root directory, which uses `ubuntu:latest` as the base image.

```bash
./prepare.sh # Install a valid Ruby version on Ubuntu/Debian
./run.sh < test-cases.txt > output.txt # Run program
```

### Known limitations

Ruby isn't a fast language. Sometimes Ruby is unbearable slow language. This implementation takes about 6 minutes to parse 100k records on my MacBook Pro 2017. Please, be patient if it takes too long in comparison with fast, compiled languages.

Even though Ruby supports functions with side effects (so, there are versions `map!`, `sort!`, `reverse!` etc.) that are usually faster, this implementation prefers to use pure functions that don't mutate passed objects.

### P.S.

It was a pleasure to implement this kata and meet some interesting corner cases. It was a little bit painful to speed up the code to show that Ruby is somehow but, at least, able to do such things relatively fast. Special thanks for the detailed requirements with all the necessary information.
