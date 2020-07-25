# -*- coding: utf-8 -*-
"""
Created on Sat Jul 25 16:52:45 2020

@author: qtckp
"""



import os
import re


result_path = 'Data'
result_path = os.path.join(os.path.dirname(__file__), result_path)

latin = list("qwertyuiopasdfghjklzxcvbnm")
contains_latin = lambda txt: any((s in latin for s in txt))


lines = []

for i in range(0, 69):
    with open(os.path.join(result_path, f'{i}.txt'), 'r') as f:
        lines += f.readlines()+['\n']



size = len(lines) 
splitter = '\n'

idx_list = [idx + 1 for idx, val in enumerate(lines) if val == splitter] 
    
res = [lines[i: j] for i, j in zip([0] + idx_list, idx_list + ([size] if idx_list[-1] != size else []))]

    
res2 = []
for r in res:
    
    for p in r:
        if '\r' in p:
            print(p)
    
    
    if not contains_latin(''.join(r)) and len(r) > 3:
        res2 += [re.sub(r'\(\W+\)', '', p.strip().replace('?', 'е').replace('i','и').replace('@','о').replace('*', '').replace('`', '')) + '\n' for p in r]
    
with open(os.path.join(result_path, 'combined.txt'), 'w') as f:
        f.writelines(res2)
        
        
        