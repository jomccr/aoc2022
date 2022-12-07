#!/bin/env python3

def uniq(chunk: str) -> bool:
    return len(chunk) == len(set(chunk))

def get_first_uniq_substr(buffer: str, uniq_length: int) -> int:
    buffer_length = len(buffer)

    for i in range(buffer_length - uniq_length):
        chunk = buffer[i:i+uniq_length]
        if uniq(chunk):
            return i + uniq_length

with open('../inputs/6.txt') as fh:
    buffer = fh.read()

print('Part 1:', get_first_uniq_substr(buffer, 4))
print('Part 2:', get_first_uniq_substr(buffer, 14))



