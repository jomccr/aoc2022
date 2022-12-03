/* SQLite */

.mode csv

create table guide (
  "input" char,
  "response" char
);

.separator ' '
.import ../inputs/2.txt guide
.headers on
.mode column

/* 
 * The first column is what your opponent is going to play: A for Rock, B for
 * Paper, and C for Scissors. The second column--" Suddenly, the Elf is called
 * away to help with someone's tent.
 * 
 * The second column, you reason, must be what you should play in response: X
 * for Rock, Y for Paper, and Z for Scissors.
 * 
 * For example, suppose you were given the following strategy guide:
 * 
 * A Y
 * B X
 * C Z
 * 
 * This strategy guide predicts and recommends the following:
 * 
 *   In the first round, your opponent will choose Rock (A), and you should
 *   choose Paper (Y). This ends in a win for you with a score of 8 (2 because
 *   you chose Paper + 6 because you won).
 * 
 *   In the second round, your opponent will choose Paper (B), and you should
 *   choose Rock (X). This ends in a loss for you with a score of 1 (1 + 0).
 * 
 *   The third round is a draw with both players choosing Scissors, giving you
 *   a score of 3 + 3 = 6.
 * 
 * X = 1, Y = 2, Z = 3
 * loss = 0, draw = 3, win = 6
 */

with inputs as (
  select
    input,
    response,
    case 
      when input = 'A' then 0
      when input = 'B' then 1
      else 2
    end as p1,
    case
      when response = 'X' then 0
      when response = 'Y' then 1
      else 2
    end as p2
  from guide
),

scores as (
  select 
    input,
    response,
    p1+1 as p1_value,
    p2+1 as p2_value, 
    case 
      when (p2 + 1) % 3 = p1 then 0
      when p2 = p1 then 3
      else 6
    end as result
  from inputs
)

select sum(score) as part_1
from (
  select 
    input, p1_value, 
    response, p2_value, 
    result,
    p2_value + result as score
  from scores
)
;

/* 
 * Anyway, the second column says how the round needs to end: 
 * X means you need to lose, 
 * Y means you need to end the round in a draw, and 
 * Z means you need to win
 * 
 * 
 */

with inputs as (
  select
    input,
    response as result,
    case 
      when input = 'A' then 0
      when input = 'B' then 1
      else 2
    end as input_value,
    case
      when response = 'X' then 0
      when response = 'Y' then 3
      else 6
    end as result_value
  from guide
),

scores as (
  select 
    input,
    result,
    input_value,
    result_value
  from inputs
)

select sum(score) as part_2
from (
  select 
    input,
    input_value,
    result,
    result_value,
    play + 1 + result_value as score
  from (
    select
      input,
      input_value,
      result,
      result_value,
      case
        when result_value = 0 -- loss 
          then (input_value + 2) % 3 
        when result_value = 3 -- draw 
          then (input_value + 0)  % 3
        when result_value = 6 -- win 
          then (input_value + 1) % 3
      end as play
    from inputs
  )
)
;




















