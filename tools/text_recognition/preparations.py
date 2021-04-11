# -*- coding: utf-8 -*-
"""
Created on Sat Jan  2 21:06:07 2021

@author: qtckp

source: https://nanonets.com/blog/ocr-with-tesseract/
"""


import cv2
import numpy as np
import matplotlib.pyplot as plt



def nothing(image):
    return image

# get grayscale image
def get_grayscale(image):
    return cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

# noise removal
def remove_noise(image):
    return cv2.medianBlur(image,5)
 
#thresholding
def thresholding(image):
    return cv2.threshold(image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)[1]

#dilation
def dilate(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.dilate(image, kernel, iterations = 1)
    
#erosion
def erode(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.erode(image, kernel, iterations = 1)

#opening - erosion followed by dilation
def opening(image):
    kernel = np.ones((5,5),np.uint8)
    return cv2.morphologyEx(image, cv2.MORPH_OPEN, kernel)

#canny edge detection
def canny(image):
    return cv2.Canny(image, 100, 200)

#skew correction
def deskew(image):
    coords = np.column_stack(np.where(image > 0))
    angle = cv2.minAreaRect(coords)[-1]
    if angle < -45:
        angle = -(90 + angle)
    else:
        angle = -angle
    (h, w) = image.shape[:2]
    center = (w // 2, h // 2)
    M = cv2.getRotationMatrix2D(center, angle, 1.0)
    rotated = cv2.warpAffine(image, M, (w, h), flags=cv2.INTER_CUBIC, borderMode=cv2.BORDER_REPLICATE)
    return rotated

#template matching
def match_template(image, template):
    return cv2.matchTemplate(image, template, cv2.TM_CCOEFF_NORMED)






def show_all(imageCV2, save_as = 'example.png'):
    
    methods = (
        nothing,
        get_grayscale,
        remove_noise,
        thresholding,
        dilate,
        erode,
        opening,
        canny,
        deskew
        )
    
    fig, axes = plt.subplots(3, 3)
    
    imim = cv2.cvtColor(imageCV2, cv2.COLOR_BGR2RGB)
    
    for ax, met in zip(axes.ravel(), methods):
    
        ax.axis("off")
        ax.set_title(met.__name__)
        
        try: ax.imshow(met(imim))
        except: pass
    
    
    plt.savefig(save_as, dpi = 400)
    plt.show()


if __name__ == '__main__':
    
    path = "images/17.png"
    
    img = cv2.imread(path) 
    
    show_all(img)





