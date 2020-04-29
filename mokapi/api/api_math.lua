function mokapi.delimit_number(number, range)
	if number < range.min then
		number = range.min
	elseif number > range.max then
		number = range.max
	end
	return number
end
