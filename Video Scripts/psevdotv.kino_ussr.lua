-- видеоскрипт "Кино СССР" [псевдо тв] https://yandex.ru (9/3/21)
-- Copyright © 2017-2021 Nexterr | https://github.com/Nexterr-origin/simpleTV-Scripts
-- ## необходим ##
-- скрапер TVS: psevdotv_pls.lua
-- видоскрипт: yandex-vod.lua
-- ## открывает ссылку ##
-- https://psevdotv.kino_ussr
-- ##
		if m_simpleTV.Control.ChangeAddress ~= 'No' then return end
	local inAdr = m_simpleTV.Control.CurrentAddress
		if not inAdr then return end
		if not inAdr:match('^https?://psevdotv%.kino_ussr') then return end
	if m_simpleTV.Control.MainMode == 0 then
		m_simpleTV.Interface.SetBackground({BackColor = 0, TypeBackColor = 0, PictFileName = '', UseLogo = 0, Once = 1})
		if m_simpleTV.Control.ChannelID == 268435455 then
			m_simpleTV.Control.ChangeChannelLogo('https://raw.githubusercontent.com/Nexterr-origin/simpleTV-Images/main/kino_ussr.png', m_simpleTV.Control.ChannelID)
		end
	end
	local function showError(str)
		m_simpleTV.OSD.ShowMessageT({text = 'kino ussr ошибка: ' .. str, showTime = 5000, color = 0xffff1000, id = 'channelName'})
	end
	m_simpleTV.Control.ChangeAddress = 'Yes'
	m_simpleTV.Control.CurrentAddress = 'error'
	local session = m_simpleTV.Http.New('Mozilla/5.0 (Windows NT 10.0; rv:81.0) Gecko/20100101 Firefox/81.0')
		if not session then
			showError('0')
		 return
		end
	m_simpleTV.Http.SetTimeout(session, 8000)
	require 'json'
	local content_id = '44714eae223f8af398ea86f676b73ed7'
	local pls = decode64('aHR0cHM6Ly9mcm9udGVuZC52aC55YW5kZXgucnUvZXBpc29kZXM/cGFyZW50X2lkPQ') .. content_id
				.. '&end_date__from=' .. os.time()
	local rc, answer = m_simpleTV.Http.Request(session, {url = pls})
		if rc ~= 200 then
			m_simpleTV.Http.Close(session)
			showError('3')
		 return
		end
	answer = answer:gsub('%[%]', '""')
	t = json.decode(answer)
		if not t
			or not t.set
		then
			showError('4')
		 return
		end
	local tab, i = {}, 1
		while t.set[i] do
			tab[i] = {}
			tab[i].Id = i
			tab[i].Name = t.set[i].title
			tab[i].Address = t.set[i].content_url:gsub('%?.-$', '') .. '$OPT:INT-SCRIPT-PARAMS=psevdotv'
			i = i + 1
		end
		if i == 1 then
			showError('5')
		 return
		end
	tab.ExtParams = {}
	tab.ExtParams.Random = 1
	tab.ExtParams.PlayMode = 1
	tab.ExtParams.StopOnError = 0
	local plstIndex = math.random(#tab)
	m_simpleTV.OSD.ShowSelect_UTF8('Кино СССР ☭🎞️', plstIndex - 1, tab, 0, 64 + 256)
	m_simpleTV.Control.ChangeAddress = 'No'
	m_simpleTV.Control.CurrentAddress = tab[plstIndex].Address
	dofile(m_simpleTV.MainScriptDir .. 'user\\video\\video.lua')
-- debug_in_file(tab[plstIndex].Address .. '\n')