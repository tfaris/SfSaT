"""
Windows installer (MSI) stores installer product codes and
component codes, which are UUIDs, in a packed format.

These are the steps that it takes:

https://flexeracommunity.force.com/customer/articles/en_US/INFO/Q105971

    Here is the typical GUID format:
    {ABCDEFGH-1234-IJKL-5678-MNPQRSTUVWXY}
    The following steps are taken to convert this GUID to its compressed counterpart:
    The first group of eight hexadecimal digits are placed in reverse order:
    ABCDEFGH becomes HGFEDCBA
     
    The same is done with the second group of four hexadecimal digits:
    1234 becomes 4321
     
    The same is done with the third group of four hexadecimal digits:
    IJKL becomes LKJI
     
    In the fourth group of four hexadecimal digits, every two digits switch places:
    5678 becomes 6587
     
    In the last group of 12 hexadecimal digits, again every two digits switch places:
    MNPQRSTUVWXY becomes NMQPSRUTWVYX
     
    Finally, the hyphens and curly braces are dropped:
    {ABCDEFGH-1234-IJKL-5678-MNPQRSTUVWXY} becomes
    {HGFEDCBA-4321-LKJI-6587-NMQPSRUTWVYX} becomes
    HGFEDCBA4321LKJI6587NMQPSRUTWVYX
"""
import sys
import uuid

if __name__ == '__main__':
    uuid_in = sys.argv[1].replace('{', '').replace('}', '')
    u = str(uuid.UUID(uuid_in)).upper()
    pieces = u.split('-')
    def rev(s):
        return s[::-1]
    pieces[0] = rev(pieces[0])
    pieces[1] = rev(pieces[1])
    pieces[2] = rev(pieces[2])
    def swap_skip(s):
        sn = ''
        for i in range(0, len(s) / 2):
            sn += s[i * 2 + 1] + s[i * 2]
        return sn
    pieces[3] = swap_skip(pieces[3])
    pieces[4] = swap_skip(pieces[4])
    print(''.join(pieces))
