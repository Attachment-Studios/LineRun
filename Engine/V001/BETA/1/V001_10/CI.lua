chars = function(text)
	local i=0
	local n = #text
	--print(text)
	return function()
		i=i+1
		if i <= n then return string.sub(text,i,i),i end
	end
end

words = function(text,spaces)
	local i=0
	local wordss = {}
	local onspace = false
	local word = {}
	for l,p in chars(text) do
		if l == ' ' then
			if not onspace then
				if #word > 0 then
					wordss[#wordss+1] = table.concat(word)
				end
				if spaces then
					word = {' '}
				else
					word = {}
				end
				onspace = true
			else
				if spaces then
					word[#word+1] = ' '
				end
			end
		else
			if onspace then
				if #word > 0 then
					wordss[#wordss+1] = table.concat(word)
				end
				word = {l}
				onspace = false
			else
				word[#word+1] = l
			end
		end
	end
	if #word > 0 then
		wordss[#wordss+1] = table.concat(word)
	end
	return function()
		i = i + 1
		if i <= #wordss then return wordss[i] end
	end
end

function string.getCharacterInt(text, character)
	for i, v in chars(text) do
		if i == character then
			return v
		end
	end
end

function string.getCharacter(text, characterInt)
	for i, v in chars(text) do
		if v == characterInt then
			return i
		end
	end
end

function string.wordExists(string, word, spaceAccepted)
	local wordCount = 0
	local wordExists = false
	for i, v in words(string,spaceAccepted) do
		if i == word then
			wordCount = wordCount + 1
		end
	end
	if wordCount > 0 then
		wordExists = true
	end
	return tostring(wordExists)..", found "..wordCount.." times"
end