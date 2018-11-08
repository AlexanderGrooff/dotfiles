#!/usr/bin/python3
import requests
import re
from lxml import html

url = 'https://www.positrondream.com/wallpapers-all/'
resp = requests.get(url)
tree = html.fromstring(resp.content)

images = tree.xpath('//img[@class="thumb-image"]')
for img_element in images:
    img_resp = requests.get(img_element.get('data-src'))
    image_name = img_element.get('alt')
    image_path = "".join([c for c in image_name if re.match(r'\w', c)]) + '.png'
    with open(image_path, 'wb') as fp:
        print('Downloading {} to {}'.format(image_name, image_path))
        fp.write(img_resp.content)
