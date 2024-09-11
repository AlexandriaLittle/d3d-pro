#!/usr/bin/env bash

# Install dof-helpers/node_modules, if not already installed
if [ ! -r ./dof-helpers/node_modules ]; then
    podman run --rm -v $PWD:/src -w /src docker.io/node bash -c 'cd dof-helpers && npm ci'
fi

# Make dist/ directory, if none exists
if [ ! -r ./dist ]; then
    mkdir dist/
fi

# generate dist/component.yaml
echo "generating dist/component.yaml..."
podman run --rm -v $PWD:/src -w /src docker.io/node node dof-helpers/parseComponent.js

# copy source/images/ directory to dist/
echo "copy source/images/ directory to dist/..."
cp -r source/images dist/images

# copy docinfo.html file to dist/
echo "copy docinfo.html file to dist/..."
cp -r docinfo.html dist/

# copy preamble.adoc file to dist/
echo "copy preamble.adoc file to dist/..."
cp -r preamble.adoc dist/

# generate flattened BOM files
echo "generating bill of materials files"
node dof-helpers/generateFlattenedBOM.js

# generate dist/assemblyInstructions.adoc
echo "generating dist/assemblyInstructions.adoc..."
podman run --rm -v $PWD:/src -w /src docker.io/node node dof-helpers/generateAssemblyInstructions.js

# generate dist/assemblyInstructions.html
echo "generating dist/assemblyInstructions.html..."
podman run --rm --volume $PWD:/src -w "/src" docker.io/asciidoctor/docker-asciidoctor asciidoctor dist/assemblyInstructions.adoc -o dist/index.html

# generate dist/assemblyInstructions.pdf
#echo "generating dist/assemblyInstructions.pdf..."
#podman run --rm --volume $PWD:/src -w "/src" docker.io/asciidoctor/docker-asciidoctor asciidoctor dist/assemblyInstructions.adoc -o dist/assemblyInstructions.pdf -r asciidoctor-pdf -b pdf -a pdf-theme=theme.yml