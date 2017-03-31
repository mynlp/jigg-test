# NLP-CI test program for jigg

This is a repository to be used by NLP-CI (https://github.com/mynlp/nlp-ci) for testing jigg (https://github.com/mynlp/jigg) and evaluating the accuracy.

## Description
1. Dockerfile
  - A docker image for testing. It is needed to install the required packages.
1. test.sh
  - A script for the test project. This script is run on the docker image.
1. gen_eval
  - A script for generating a XML file, which is used for plotting, from a result of evaluation.