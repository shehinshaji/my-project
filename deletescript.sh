#!/bin/bash

if [ "$(ls -A /home/ansadmin/instanceconfigure/warfile/)" ]; then
  rm -r /home/ansadmin/instanceconfigure/warfile/*
else
  exit 0
fi

