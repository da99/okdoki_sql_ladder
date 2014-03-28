
class On_A_Ladder

  class << self
  end # === class self ===

  def initialize sql
    @ladder = []
    @sql    = sql
  end

  def Ladder
    @ladder
  end

  def Bottom r

    @ladder = @ladder.concat(r.parent_sql)
    @ladder << r
    size = @ladder.size
    @ladder.each_with_index { |v, i|
      case i
      when 0           # top
      when size - 1    # bottom
      else             # middle
      end
    }
    self
  end

  def position
    @ladder[0]
  end

end # === class On_A_Ladder ===



