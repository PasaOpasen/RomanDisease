# -*- coding: utf-8 -*-
"""
Created on Mon Aug  3 20:32:23 2020

@author: qtckp
"""


from pathlib import Path

text = Path('2.txt').read_text(encoding = 'utf8')


from sklearn.feature_extraction.text import CountVectorizer

vectorizer = CountVectorizer()

X = vectorizer.fit_transform(text.split('\n'))

# most popular words

d = dict(zip(vectorizer.get_feature_names(), X.sum(axis=0).tolist()[0]))

d = {k:v for k, v in sorted(d.items(), key=lambda item: item[1], reverse = True)}

k = 0

for word, count in d.items():
    print(f'{word}: {count}')
    k += 1
    if k == 50:
        break
    
print(f'total words: {sum(d.values())}, unique: {len(d)}') 


with open('stopwords.txt','r', encoding = 'utf-8') as f:
    stop = [line.rstrip() for line in f if len(line) > 1]
    stop = set(stop)


total_vocab = {k: v for k, v in d.items() if (v > 75 and v < 650) and k not in stop }
print(f'total words: {sum(total_vocab.values())}, unique: {len(total_vocab)}') 



import imageio

mask = imageio.imread('cross.png')




from wordcloud import WordCloud

wordcloud = WordCloud(colormap = 'twilight', 
                      mask = mask, background_color = 'white' )

#wordcloud = wordcloud.generate(text)
wordcloud = wordcloud.fit_words(total_vocab)

wordcloud.to_file('cloud.png')

