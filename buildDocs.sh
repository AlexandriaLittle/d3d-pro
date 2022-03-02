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

# copy source/images/ directory to dist/
echo "copy source/images/ directory to dist/..."
cp -r source/images/ dist/

# generate dist/assemblyInstructions.adoc
echo "generating dist/assemblyInstructions.adoc..."
docker run --rm -v $PWD:/src -w /src node node dof-helpers/generateAssemblyInstructions.js

# generate dist/assemblyInstructions.html
echo "generating dist/assemblyInstructions.html..."
docker run --rm --volume $PWD:/src -w "/src" asciidoctor/docker-asciidoctor asciidoctor dist/assemblyInstructions.adoc -o dist/assemblyInstructions.html

# generate dist/assemblyInstructions.pdf
echo "generating dist/assemblyInstructions.pdf..."
docker run --rm --volume $PWD:/src -w "/src" asciidoctor/docker-asciidoctor asciidoctor dist/assemblyInstructions.adoc -o dist/assemblyInstructions.pdf -r asciidoctor-pdf -b pdf
