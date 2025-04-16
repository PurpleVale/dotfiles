#!/bin/zsh

/home/vale/.bin/myIP | sed -nE 's/^(([0-9]{1,3}\.*){4})$/ \1/p'
