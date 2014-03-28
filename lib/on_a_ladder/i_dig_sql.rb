
unless Object.const_defined?(:I_Dig_Sql)
  require 'i_dig_sql'
end


module On_A_Ladder_Because_I_Dig_Sql
  def ladder
    @ladder ||= On_A_Ladder.new(self)
  end
end # === module On_A_Ladder_Because_I_Dig_Sql ===

class I_Dig_Sql
  include On_A_Ladder_Because_I_Dig_Sql
end # === class I_Dig_Sql ===
