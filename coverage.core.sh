#!/usr/bin/env bash

# Create coverage reports for core (non-UI) code
rm -rf coverage-reports
mkdir coverage-reports
slather coverage --html --show --output-directory coverage-reports --ignore AutocompleteClientTests/\* --ignore AutocompleteClient/FW/UI/\* --ignore AutocompleteClient/Utils/\*\*/UI\*