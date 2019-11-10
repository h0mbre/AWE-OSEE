import binascii
import sys
from textwrap import wrap

our_input = sys.argv[1]

our_list = wrap(binascii.hexlify(our_input), 4)
length = len(our_list)

output_string = ""
counter = 0

while counter <= (length - 1):
	if (len(our_list[counter]) % 4) != 0:
		our_list[counter] = our_list[counter] + "90"
	chunk = our_list[counter][2] + our_list[counter][3] + our_list[counter][0] + our_list[counter][1]
	output_string += "%u" + chunk
	counter += 1

print output_string
