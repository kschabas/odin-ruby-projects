#lib/caesar-cipher.rb

def caesar_cipher(str,shift)
    result = ""
    str.each_char do |char| 
       if char.ord.between?('a'.ord,'z'.ord)
            next_char = (char.ord + shift).chr
            if next_char.ord > 'z'.ord
                next_char = (next_char.ord - 'z'.ord + 'a'.ord - 1).chr
            end 
       elsif char.ord.between?('A'.ord,'Z'.ord)
            next_char = (char.ord + shift).chr
            if next_char.ord > 'Z'.ord
                next_char = (next_char.ord-'Z'.ord + 'A'.ord - 1).chr
            end
        else
            next_char = char;
        end
        result += next_char
    end
    result
end