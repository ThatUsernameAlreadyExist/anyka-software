#!/bin/bash


if [ ! -d "arm-anykav200-crosstool" ]; then
    echo "Unpacking crosscompiler..."
    unzip -q "./arm-anykav200-crosstool.zip"
    echo "Unpacking crosscompiler done"
fi

