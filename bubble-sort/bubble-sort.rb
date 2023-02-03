def bubble_sort (array)
   cont = true
   while cont
    cont = false
    array.each_index do |index|
        if (!array[index+1].nil? && (array[index] > array[index+1]))
            cont = true
            array[index], array[index+1] = array[index+1], array[index]
        end
    end
   end
   array 
end

puts array = bubble_sort([4,3,78,2,0,2])