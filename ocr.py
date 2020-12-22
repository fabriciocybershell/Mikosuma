#! bin/bash/python3
# -*- coding: UTF-8 -*-
from PIL import Image 
import pytesseract
import os 
import sys

image=sys.argv[1]
arq=open('dados.txt', 'w')
arq.write(pytesseract.image_to_string(Image.open(image)))
arq.close()
print(pytesseract.image_to_string(Image.open(image)))
