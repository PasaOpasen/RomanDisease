# -*- coding: utf-8 -*-
"""
Created on Mon Aug  3 21:31:43 2020

@author: qtckp
"""


from pathlib import Path

from textatistic import Textatistic


for i in (0,1,2,4,5):
    
    text = Path(f'{i}.txt').read_text(encoding = 'utf8', errors='ignore')
    readab = Textatistic(text)
    print(f'Book {i}:')
    print(readab.dict())
    print()


