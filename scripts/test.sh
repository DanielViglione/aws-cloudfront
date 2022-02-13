#!/bin/bash
cd tests/terratest
go test -timeout 30m
cd -