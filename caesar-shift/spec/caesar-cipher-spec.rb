#spec/caesar-cipher-spec.rb
require './lib/caesar-cipher.rb'

describe Object do
  it "basic one letter shift" do
    expect(caesar_cipher("abcde", 1)).to eql("bcdef")
  end
  it "CAPITAL LETTERS" do
    expect(caesar_cipher("ABCDE",1)).to eql("BCDEF")
  end
  it "Wraparound" do
    expect(caesar_cipher("XxXyYy", 3)).to eql("AaAbBb")
  end
  it "Ignore punctuation" do
    expect(caesar_cipher("a-. ';b",4)).to eql("e-. ';f")
  end
end
