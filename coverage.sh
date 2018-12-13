#!/usr/bin/env bash

# Create coverage reports
rm -rf coverage-reports
mkdir coverage-reports
slather coverage --html --show --output-directory coverage-reports