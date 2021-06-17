#!/usr/bin/env python
#-*-coding:utf-8 -*-
#
#Author: tony - birdaccp at gmail.com
#Create by:2015-09-30 14:04:12
#Last modified:2020-12-16 12:21:15
#Filename:delete_pyc.py
#Description:

import os

class listFiles(object):
    def __init__(self, destPath):
        self.files = []
        self._listAllFile(destPath)

    def getAllFiles(self):
        return self.files

    def _listAllFile(self, destPath):
        lists = os.listdir(destPath)
        for l in lists:
            p = os.path.join(destPath, l)
            if os.path.isdir(p):
                os.system("chmod 755 '%s'" % p)
                self._listAllFile(p)
            elif os.path.isfile(p):
                self.files.append(p)

ls = listFiles(os.getcwd())
for l in ls.getAllFiles():
    print(l)
    #print(l, os.path.isdir(l))
    file, ext = os.path.splitext(l)
    if not ext in ['.sh']:
        os.system("chmod -x '%s'" % l)

    if ext in ['.pyc']:
        print(l)
        os.unlink(l)

