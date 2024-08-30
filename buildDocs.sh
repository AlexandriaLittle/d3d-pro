#!/usr/bin/env bash

#### set environment variable for project root ####
project_root=$PWD


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
cp -r source/images/ dist/

# generate dist/assemblyInstructions.adoc
echo "generating dist/assemblyInstructions.adoc..."
node dof-helpers/generateAssemblyInstructions.js

# generate dist/assemblyInstructions.html
clitool="asciidoctor"
cmdargs="assemblyInstructions.adoc -o dist/assemblyInstructions.html"
cmd="$clitool $cmdargs"
workdir=$project_root/dist
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating manual as pdf via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating manual as pdf..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

# generate dist/assemblyInstructions.pdf
clitool="asciidoctor"
cmdargs="assemblyInstructions.adoc -o dist/assemblyInstructions.pdf -r asciidoctor-pdf -b pdf -a pdf-theme=theme.yml"
cmd="$clitool $cmdargs"
workdir=$project_root/dist
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating manual as pdf via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating manual as pdf..."
    cd $workdir
    eval $cmd
    cd $project_root
fi


# generate dist/assemblyInstructions.html
#echo "generating dist/assemblyInstructions.html..."
#asciidoctor dist/assemblyInstructions.adoc -o dist/assemblyInstructions.html

# generate dist/assemblyInstructions.pdf
#echo "generating dist/assemblyInstructions.pdf..."
#asciidoctor dist/assemblyInstructions.adoc -o dist/assemblyInstructions.pdf -r asciidoctor-pdf -b pdf -a pdf-theme=theme.yml
