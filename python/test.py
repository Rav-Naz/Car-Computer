from itertools import count
import os

with open("E:/debug_data.txt", "r+") as file_object:
    debug_lines_count = len(file_object.readlines())
    if debug_lines_count < 10:
        file_object.write(str(debug_lines_count) + str('\n'))
    else:
        print("Maximum")
    file_object.close()