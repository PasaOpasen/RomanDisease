# -*- coding: utf-8 -*-
"""
Created on Sat Jan  2 21:08:17 2021

@author: qtckp
"""

import os, re
import numpy as np
import cv2
import pytesseract

from preparations import nothing, get_grayscale, remove_noise, thresholding, dilate

pytesseract.pytesseract.tesseract_cmd = 'C:/Program Files/Tesseract-OCR/tesseract.exe'

# Adding custom options
custom_config = r'--oem 3 --psm 6'

prep = get_grayscale



pg = [
      133, 197,201,
      217,269,278,326,
      339, 346, 475
      ]


folders = list(map(str, pg))

#images_files = glob.glob(fr'{folder}/*\.(jpg|png|jpeg)')

for folder in folders:

    images_files = [os.path.join(folder, f) for f in os.listdir(f'./{folder}') if re.match(r'.+\.(jpg|png)', f)]
    
    text = [pytesseract.image_to_string(prep(cv2.imread(file)), lang = 'rus+eng', config=custom_config) for file in images_files]
    
    
    with open(os.path.join(folder, 'result.txt'), 'w', encoding='utf-8') as file:
        file.writelines([line + '\n'*5 for line in text])




