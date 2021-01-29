#!/usr/bin/env sh

# Ensure we are in the directory that contains the relevant docker
# files. This still allows the script to work even if we call it
# from outside the "docker" directory.
cd "${0%/*}"

# Get the project name, which is the root directory name of this
# project (we assume the root is one level up). This is a single
# line way of doing it, essentially, cd up one dir, get the name
# of that dir using shell Parameter Expansion, then cd back to
# where we were.
tPWD="$PWD"; cd ..; project_name="${PWD##*/}"; cd "$tPWD"

# Create and bring up the Docker Compose containers
docker-compose --project-name "$project_name" up -d
