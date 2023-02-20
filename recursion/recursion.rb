# frozen_string_literal: true

def fibs_rec(n)
  return 0 if n == 1
  return 1 if n == 2

  fibs_rec(n - 2) + fibs_rec(n - 1)
end

# puts fibs_rec(15)

def merge_sort(array)
  return array if array.length == 1

  midpoint = array.length / 2
  left_array = merge_sort(array[0...midpoint])
  right_array = merge_sort(array[midpoint..])
  combine_sorted_arrays(left_array, right_array)
end

def combine_sorted_arrays(larray, rarray)
  lindex = 0
  rindex = 0
  result = []

  until lindex == larray.length && rindex == rarray.length
    if rindex == rarray.length || (lindex < larray.length && larray[lindex] < rarray[rindex])
      result << larray[lindex]
      lindex += 1
    else
      result << rarray[rindex]
      rindex += 1
    end
  end
  result
end

array = [1, 231, 38, 27, 38, 43, 3, 9, 82, 10]
puts merge_sort(array)
