
class On_A_Ladder

  class << self
  end # === class self ===

  def initialize
    @ladder = {}
    @stack = []
  end

  def Ladder
    @stack.map { |v|
      @ladder[v]
    }
  end

  def Top r
    @ladder[r] = {
      :class => r,
      :child => nil,
      :parent => nil
    }
    @stack << r
    self
  end

  def Down r

    @ladder[r] = {
      :class => r,
      :child => nil,
      :parent => @stack.last
    }

    @ladder[@stack.last][:child] = r
    @stack << r

    self
  end

end # === class On_A_Ladder ===
