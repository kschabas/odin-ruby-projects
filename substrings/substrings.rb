def substrings (str, dictionary)
    str = str.downcase
    dictionary.reduce(Hash.new(0)) do |hash, word|
        if str.include?(word)
            hash[word] += str.scan(word).length
        end
        hash
    end
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
puts substrings("Howdy partner, sit down! How's it going?", dictionary)