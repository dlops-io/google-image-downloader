"""
Module that contains the command line app.
"""
import os
import sys
import time
import argparse
import json
import tensorflow as tf
from downloader import download_google_images

# Generate the inputs arguments parser
parser = argparse.ArgumentParser(description='Command description.')

def main(args=None):
    parse_args, unknown = parser.parse_known_args(args=args)
    print("Args:", parse_args)

    download_google_images()
    
    # Verify downloaded images
    # base_path = "<path>"
    # label_names = os.listdir(base_path)
    # print("Labels:", label_names)
    
    # # Generate a list of labels and path to images
    # data_list = []
    # for label in label_names:
    #     # Images
    #     image_files = os.listdir(os.path.join(base_path,label))
    #     data_list.extend([(label,os.path.join(base_path,label,f)) for f in image_files])

    # print("Full size of the dataset:",len(data_list))
    # print(data_list[:5])
    
    # image_width = 224
    # image_height = 224
    # num_channels = 3
    
    # for label,path in data_list:
    #     try:
    #         image = tf.io.read_file(path)
    #         image = tf.image.decode_jpeg(image, channels=num_channels)
    #     except:
    #         print(path)
    #         #os.remove(path)

if __name__ == "__main__":
    main()