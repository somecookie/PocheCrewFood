# coding: utf-8
from http.server import SimpleHTTPRequestHandler
import hashlib
import json
import binascii
import os
import sys


sys.path.append('tensorflow/models/research/object_detection')
import create_ingredient_images_script

class Image_handler(SimpleHTTPRequestHandler):
    def __init__(self, detection_graph, *args, **kwargs):
        self.detection_graph = detection_graph
        super().__init__(*args, **kwargs)

    def do_POST(self):

        os.chdir("/home/rferreir/Hackaton/PocheCrew/server")

        #get data from the post
        content_length = int(self.headers['Content-Length'])   
        post_data = self.rfile.read(content_length)
        
        image_json = json.loads(post_data)
        image_data = binascii.a2b_base64(image_json['image'])
        #create a unique file_name
        m = hashlib.sha1(post_data)
        file_name = m.hexdigest()

        #convert text into an image and save it in ./images/
        path_name = "./images/{}.png".format(file_name)
        
        with open(path_name, "wb") as file:
            file.write(image_data)

        print("Image correctly received")
        path_name = os.path.abspath(path_name)
        matches = create_ingredient_images_script.create_ingredient_images(path_name, self.detection_graph)

        print("Image correctly processed")

        if matches is None:
            self.protocol_version = 'HTTP/1.1'
            self.send_response(204)
            message = "No match"
            self.send_header("Content-type", "")
            self.send_header("Content-length", len(message))
            self.end_headers()
            self.wfile.write(bytes(message, 'utf-8'))
        else:
            message = json.dumps(matches)
            self.protocol_version = 'HTTP/1.1'
            self.send_response(200)
            self.send_header("Content-type", "")
            self.send_header("Content-length", len(message))
            self.end_headers()
            self.wfile.write(bytes(message, 'utf-8'))
