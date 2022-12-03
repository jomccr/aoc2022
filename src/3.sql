/* SQLite */

.mode csv

create table rucksacks (
  "contents" varchar(100)
);

.import ../inputs/3.txt rucksacks
.headers on
.mode column

/* Generate the priority value for each letter in alphabet, lowercase and then
 * uppercase. */
create table priority_values as 
with uppercase_values as (
  select 
    1 as i,
    27 as priority,
    char(65) as letter
  union all 
  select 
    i + 1,
    priority + 1,
    char(65 + i)
  from uppercase_values
  where priority < 52
),
lowercase_values as (
  select 
    1 as priority,
    char(97) as letter
  union all 
  select
    priority + 1,
    char(97 + priority)
  from lowercase_values 
  where priority < 26
)
select priority, letter from lowercase_values
union all 
select priority, letter from uppercase_values
;

create table prepped_letters as 
with compartments as (
  select 
    rowid as id,
    substr(contents, 1, length(contents) / 2) as first_half,
    substr(contents, (length(contents) / 2) + 1) as second_half
  from rucksacks
),
letters as (
  select 
    id,
    1 as i, 
    1 as j,
    substr(first_half,1,1) as first_letter, 
    first_half,
    substr(second_half,1,1) second_letter, 
    second_half
  from compartments 
  union all 
  select 
    id,
    i + 1, 
    j + 1,
    substr(first_half, i+1, 1), 
    first_half,
    substr(second_half, j+1, 1), 
    second_half
  from letters
  where i < length(first_half)
)
select * from letters;
;

/* This query will help explain wtf is going on for part 1 lol */

-- select * from prepped_letters where id = 1;

select sum(priority) as part_1
from (
  select distinct a.id, a.letter, c.priority
  from (select id, first_letter as letter from prepped_letters) a
  inner join (select id, second_letter as letter from prepped_letters) b
    on a.id = b.id 
    and a.letter = b.letter
  inner join priority_values c 
    on a.letter = c.letter
)
;


with sacks as (
  select 
    rowid as id,
    contents 
  from rucksacks
),
grouped as (
  select a.id as groupid, 
    a.contents as item1, 
    b.contents as item2, 
    c.contents as item3
  from sacks a
  left join (select id + 1 as id, contents from sacks) b on a.id = b.id
  left join (select id + 2 as id, contents from sacks) c on b.id = c.id
  where a.id % 3 = 0
),
letters as (
  select groupid,
    1 as i, 
    1 as j,
    1 as k,
    substr(item1,1,1) as first_letter, 
    item1,
    substr(item2,1,1) second_letter, 
    item2,
    substr(item3,1,1) third_letter, 
    item3
  from grouped 
  union all 
  select groupid,
    i + 1, 
    j + 1,
    k + 1,
    substr(item1,i+1,1), 
    item1,
    substr(item2,j+1,1), 
    item2,
    substr(item3,k+1,1), 
    item3
  from letters
  where i < max(length(item1), length(item2), length(item3))
)
select sum(b.priority) as part_2
from (
  select distinct a.groupid, a.letter
  from (
    select groupid, first_letter as letter 
    from letters 
    where first_letter is not null
  ) a
  inner join (
    select groupid, second_letter as letter 
    from letters 
    where second_letter is not null
  ) b on a.groupid = b.groupid and a.letter = b.letter
  inner join (
    select groupid, third_letter as letter 
    from letters 
    where third_letter is not null
  ) c on b.groupid = c.groupid and b.letter = c.letter
  order by a.groupid
) a
left join priority_values b on a.letter = b.letter
;

