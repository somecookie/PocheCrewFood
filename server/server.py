from handler import Image_handler
import time
from http.server import HTTPServer
import sys
sys.path.append('tensorflow/models/research/object_detection')
import load_module_script
from functools import partial

HOST_NAME = '128.179.154.130'
PORT_NUMBER = 9000

if __name__ == '__main__':
    detection_graph = load_module_script.load_model()
    handler = partial(Image_handler, detection_graph)
    httpd = HTTPServer((HOST_NAME, PORT_NUMBER), handler)
    print(time.asctime(), 'Server Starts - %s:%s' % (HOST_NAME, PORT_NUMBER))

    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()
print(time.asctime(), 'Server Stops - %s:%s' % (HOST_NAME, PORT_NUMBER))
