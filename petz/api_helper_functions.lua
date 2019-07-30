local modpath, S = ...

--
--Helper Functions
--

function petz:split(inSplitPattern, outResults)
  if not inSplitPattern then
    inSplitPattern = ','
  end
  if not outResults then
    outResults = { }
  end
  self = self:gsub("%s+", "") --firstly trim spaces
  local theStart = 1
  local theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  while theSplitStart do
    table.insert(outResults, string.sub(self, theStart, theSplitStart-1))
    theStart = theSplitEnd + 1
    theSplitStart, theSplitEnd = string.find(self, inSplitPattern, theStart)
  end
  table.insert(outResults, string.sub(self, theStart))
  return outResults
end

function petz.to_boolean(val)
	if val and (val == "true" or val == 1) then
		return true
	else
		return false
	end	
end

function petz.is_night()
	local timeofday = minetest.get_timeofday() * 24000
	if (timeofday < 4500) or (timeofday > 19500) then
		return true
	else
		return false
	end 
end

function petz.round(x, n)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end
