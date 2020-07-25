# -*- coding: utf-8 -*-
"""
Created on Sat Jul 25 13:33:09 2020

@author: qtckp
"""

import os



result_path = 'Data'
result_path = os.path.join(os.path.dirname(__file__), result_path)

if not os.path.exists(result_path):
    os.mkdir(result_path)


def string_without_numbers(string):
    return ''.join([s for s in string if not s.isdigit()])

def is_valid(string):
    return string and any((s.isalpha() for s in string)) and not string.startswith('Матфей') and not string.startswith('Иоанн') and not string.startswith('Марк') and not string.startswith('Лука')



with open('Том 5.txt', 'r') as f:
    lines = [line for line in f.readlines() if not line.isupper() and '|' not in line]



def split_list_and_combine(lst, splitter = '\n'):
    
    if len(lst)< 3:
        return lst
    
    size = len(lst) 
    idx_list = [idx + 1 for idx, val in enumerate(lst) if val == splitter] 
    
    res = [lst[i: j] for i, j in zip([0] + idx_list, idx_list + ([size] if idx_list[-1] != size else []))]

    
    res2 = []
    for r in res:
        res2 += [p for p in r if p != splitter] + [splitter]
    
    return res2

    
def save_sample(data, index):
    with open(os.path.join(result_path, f'{index}.txt'), 'w') as f:
        cleaned = [string_without_numbers(s).strip() for s in data]
        convert = lambda txt: txt + '\n' if is_valid(txt) else '\n'
        cleaned = [convert(s) for s in cleaned]
        
        if len(cleaned[-1]) == 1:
            cleaned = cleaned[:-1]
        if len(cleaned[-2]) == 1:
            cleaned = cleaned[:-2]
        
        f.writelines(split_list_and_combine(cleaned))





sample = []
k = 0

empty = lambda txt: not bool(txt.strip())

def config1(next1, next2):
    return len(next1.strip())>60 and empty(next2)

def config2(next1, next2):
    return len(next2.strip())>1 and empty(next1)

for i, s in enumerate(lines[1:-1]):
    
    if s[0].isdigit():
        #print(s)
        continue
    
    if not empty(s) and empty(lines[i-1]) and ( config1(lines[i+2], lines[i+3]) or config2(lines[i+2], lines[i+3])  ):
        print(f'{s} {lines[i+2]} {lines[i+3]}')
        print()
        if sample:
            save_sample(sample, k)
            k += 1
            sample = []
    else:
        sample.append(s)



if sample:
    save_sample(sample, k)























