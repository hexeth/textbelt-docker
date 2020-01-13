#!/bin/bash

echo -e '\e[41mremoving containers\e[0m'
docker-compose down

echo -e '\e[41mrebuilding image\e[0m'
docker build . -t textbelt-test

echo -e '\e[41mrebuilding containers\e[0m'
docker-compose up -d

echo -e '\e[41mdone!\e[0m'
