
require 'Bacon_Colored'
require 'okdoki_sql_ladder'
require 'pry'
require "diffy"

require "i_dig_sql"

Diffy::Diff.default_format = :color

def diff actual, target
  Diffy::Diff.new(actual, target)
end

def common o
  case o
  when I_Dig_Sql
    common(o.to_sql[:sql])
  else
    o.strip.split.join(" ").upcase
  end
end
