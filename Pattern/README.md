## Pattern

`pattern.py` is simply a replacement for `pattern_create.rb` and `patter_offset.rp` on Kali.

## Usage

### Create pattern with Python formatted output
```
terminal_prompt> ./pattern.py -c 150 -py                                  
pattern = ('0Aa0Ab0Ac0Ad0Ae0Af0Ag0Ah0Ai0Aj0Ak0Al0Am0An0Ao0Ap0Aq0Ar0As0At0Au0Av'
'0Aw0Ax0Ay0Az0A00A10A20A30A40A50A60A70A80A90AA0AB0AC0AD0AE0AF0AG0AH0AI0AJ0AK0AL'
'0AM0AN')
```

### Create pattern with C/C++ formatted output
```
terminal_prompt> ./pattern.py -c 150 -cpp                                 
char pattern[] = 
"0Aa0Ab0Ac0Ad0Ae0Af0Ag0Ah0Ai0Aj0Ak0Al0Am0An0Ao0Ap0Aq0Ar0As0At0Au0Av0Aw0Ax0Ay0Az"
"0A00A10A20A30A40A50A60A70A80A90AA0AB0AC0AD0AE0AF0AG0AH0AI0AJ0AK0AL0AM0AN";
```

### Find offset
```
terminal_prompt> ./pattern.py -o 306f4c30
Exact offset found at position: 2088
```
