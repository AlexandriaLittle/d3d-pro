#!/usr/bin/env bash

# Install dof-helpers/node_modules, if not already installed
if [ ! -r ./dof-helpers/node_modules ]; then
   cd dof-helpers && npm ci
fi

# Make dist/ directory, if none exists
if [ ! -r ./dist ]; then
    mkdir dist/
fi

# generate dist/component.yaml
echo "generating dist/component.yaml..."
node dof-helpers/parseComponent.js

# copy source/images/ directory to dist/
echo "copy source/images/ directory to dist/..."
cp -r source/images dist/images

# copy docinfo.html file to dist/
echo "copy docinfo.html file to dist/..."
cp -r docinfo.html dist/

# generate dist/assemblyInstructions.adoc
echo "generating dist/assemblyInstructions.adoc..."
node dof-helpers/generateAssemblyInstructions.js

# generate dist/assemblyInstructions.html
echo "generating dist/assemblyInstructions.html..."
asciidoctor dist/assemblyInstructions.adoc -o dist/index.html

# generate dist/assemblyInstructions.pdf
echo "generating dist/assemblyInstructions.pdf..."
asciidoctor dist/assemblyInstructions.adoc -o dist/assemblyInstructions.pdf -r asciidoctor-pdf -b pdf -a pdf-theme=theme.yml