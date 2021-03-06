#!/usr/bin/env python3

import argparse
from textwrap import wrap

parser = argparse.ArgumentParser(add_help=True)
parser.add_argument("-c", "--create", type=int, nargs="?",
help="create pattern of x length")
parser.add_argument("-o", "--offset", type=str, nargs="?",
help="find offset of x character series")
parser.add_argument("-py", help="output in prettified python format",
action="store_true")
parser.add_argument("-cpp", help="output in prettified c/c++ format",
action="store_true")

args = parser.parse_args()
size = args.create
offset = args.offset
py = args.py
cpp = args.cpp

primaries = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c',
'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
'Z']

secondaries = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c',
'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's',
't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8',
'9']

tertiaries = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2',
'3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I',
'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y',
'Z']

def pattern_create(size):

    string = ''

    for x in primaries:
        for y in secondaries:
            for z in tertiaries:
                addition = (x + y + z)
                string += addition

    return(string[:size])

def pattern_offset(offset):

    offset_len = len(offset)
    new_offset = ''
    new_offset = offset[-2:]
    counter = -2
    while len(new_offset) < offset_len:
        new_offset += offset[counter - 2:counter]
        counter = counter - 2

    offset = bytes.fromhex(new_offset).decode('utf-8')

    string = ''

    for x in primaries:
        for y in secondaries:
            for z in tertiaries:
                addition = (x + y + z)
                string += addition

    if offset in string:
        result = len(string.split(offset)[0])
        print("Exact offset found at position: {}".format(str(result)))

    else:
        print("Characters not found in string.")

def python(result):

    output = 'pattern = (\'' + result + '\')'
    list = wrap(output,78)
    for x in list:
        if x == list[0]:
            x += "\'"
            print(x)
        elif x == list[-1]:
            x = '\'' + x
            print(x)
        else:
            print('\'' + x + '\'')

def seeplusplus(result):

    header = "char pattern[] = "
    output = result + "\";"
    list = wrap(output,78)
    print(header)
    for x in list:
        if x == list[-1]:
            x = '\"' + x
            print(x)
        else:
            print('\"' + x + '\"')

if size:
    result = pattern_create(size)
    if py:
        python(result)
    elif cpp:
        seeplusplus(result)
    else:
        print(result)

elif offset:
    pattern_offset(offset)

else:
    parser.print_help()
