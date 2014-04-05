
unless Object.const_defined?(:I_Dig_Sql)
  require 'i_dig_sql'
end


module Okdoki_Sql_Ladder_Because_I_Dig_Sql
  def ladder
    @ladder ||= Okdoki_Sql_Ladder.new(self)
  end
end # === module Okdoki_Sql_Ladder_Because_I_Dig_Sql ===

class I_Dig_Sql
  include Okdoki_Sql_Ladder_Because_I_Dig_Sql
end # === class I_Dig_Sql ===
