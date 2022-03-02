#!/usr/bin/env bash

# Install dof-helpers/node_modules, if not already installed
if [ ! -r ./dof-helpers/node_modules ]; then
    docker run --rm -v $PWD:/src -w /src node bash -c 'cd dof-helpers && npm ci'
fi

# Make dist/ directory, if none exists
if [ ! -r ./dist ]; then
    mkdir dist/
fi

# generate dist/component.yaml
echo "generating dist/component.yaml..."
docker run --rm -v $PWD:/src -w /src node node dof-helpers/parseComponent.js

# generate dist/assemblyInstructions.adoc
echo "generating dist/assemblyInstructions.adoc..."
docker run --rm -v $PWD:/src -w /src node node dof-helpers/generateAssemblyInstructions.js
