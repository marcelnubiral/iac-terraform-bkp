#!/bin/bash
sudo mkdir /home/pruebam
sudo echo ${var.domain_pwd} | realm join -U ${var.domain_user} aws.local