/* SQLite */

.mode csv

create table foodbanks (
"calories" number
);

.import ../inputs/1.txt foodbanks
.headers on
.mode column

select max(total) as part_1, sum(total) as part_2
from (
  with grouped_foodbanks as (
    select rowid - row_number() over (order by rowid) as groupid, * 
    from foodbanks where calories <> ''
  )
  select distinct total 
  from (
    select sum(calories) over (partition by groupid) as total 
    from grouped_foodbanks
  ) 
  order by 1 desc limit 3
)



