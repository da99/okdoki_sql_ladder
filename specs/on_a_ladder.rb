
class A
end

class B
end

class B1
end

class B2
end

class B3
end

class C
end

def keys o
  o.keys.sort { |a, b| return a.to_s > b.to_s }
end

def parents o
  keys(o).map { |k| o[k][:parent] }
end

describe ".Top" do

  it "saves class" do
    o = On_A_Ladder.new
    .Top(A)
    .Top(B)

    keys(o.Ladder).should == [A, B]
  end

end # === describe on_a_ladder ===

describe ".Down" do

  it "saves class" do
    o = On_A_Ladder.new
    .Top(A)
    .Down(B)
    .Down(C)

    keys(o.Ladder).should == [A, B, C]
  end

  it "sets :parent to previous entry" do
    o = On_A_Ladder.new
    .Top(A)
    .Down(B)
    .Down(C)

    parents(o.Ladder).should == [nil, B, C]
  end

end # === describe .Down ===

