#!/usr/bin/env python

def flag_for_part_2(range_boundaries) -> bool:
    # unpack boundaries and return True if one range overlaps with another
    first_start, first_end = range_boundaries[0]
    second_start, second_end = range_boundaries[1]

    return (
        (second_start <= first_start <= second_end) or 
        (second_start <= first_end <= second_end) or
        (first_start <= second_start <= first_end) or
        (first_start <= second_end <= first_end)
    )

def flag_for_part_1(range_boundaries) -> bool:
    # unpack boundaries and return True if one range fully encapsulates another
    first_start, first_end = range_boundaries[0]
    second_start, second_end = range_boundaries[1]

    return (
        (first_start <= second_start and first_end >= second_end) or 
        (second_start <= first_start and second_end >= first_end)
    )


with open('../inputs/4.txt') as fh:
    data = fh.readlines()

part_1_count = 0
part_2_count = 0

for line in data:
    # split and cast each element to an int (example range_boundary: [[2, 4], [5, 6]])
    range_boundaries = [[int(e) for e in item.split('-')] for item in line.strip().split(',')]
    if flag_for_part_1(range_boundaries):
        part_1_count += 1
    if flag_for_part_2(range_boundaries):
        part_2_count += 1

print(f'Part 1: {part_1_count}')
print(f'Part 2: {part_2_count}')

