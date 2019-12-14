local modpath, S = ...

--
-- Mount Engine
--

petz.get_os_month = function()
	local nowTable= os.date('*t')
	return nowTable.month
end
