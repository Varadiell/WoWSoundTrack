
-- ==========================================================
-- Fonctions de visibilité de la MainFrame et sons de l'addOn
-- ==========================================================

-- MainFrame_Show() : affiche la fenêtre
function MainFrame_Show()
	if(MainFrame:IsShown()) then
		MainFrame_Hide();
		PlayCloseSound();
	else
		ShowUIPanel(MainFrame);
		PlayOpenSound();
	end
end

-- MainFrame_Close() : cache la fenêtre
function MainFrame_Hide()
	HideUIPanel(MainFrame);
	PlaySound("igCharacterInfoClose");
end

-- PlayCloseSound() : joue le son de fermeture de la fenêtre
function PlayCloseSound()
	PlaySound("igCharacterInfoClose");
end

-- PlayOpenSound() : joue le son d'ouverture de la fenêtre
function PlayOpenSound()
	PlaySound("igCharacterInfoOpen");
end

-- PlayButtonSound() : joue le son d'un bouton actionné
function PlayButtonSound()
	PlaySound("UChatScrollButton");
end


-- ==========================
-- Commandes slash de l'AddOn
-- ==========================

-- "/ws" : ouvre ou ferme la fenêtre en fonction de son état
-- "/ws open" : ouvre ou ferme la fenêtre en fonction de son état
-- "/ws close" : ferme la fenêtre si elle est ouverte

SLASH_SlashCmd_1 = "/ws"
SLASH_SlashCmd_2 = "/wst"
SLASH_SlashCmd_3 = "/wost"
SLASH_SlashCmd_4 = "/wows"
SLASH_SlashCmd_5 = "/wowst"
SLASH_SlashCmd_6 = "/wowost"

SlashCmdList["SlashCmd_"] = function(msg)
	if(msg:trim() == "open" or msg:trim() == "run") then
		MainFrame_Show();
	elseif(msg:trim() == "close" or msg:trim() == "hide") then
		MainFrame_Hide();
	elseif(msg:trim() == "") then
		MainFrame_Show();
	else
		print("WoW_SoundTrack : cette commande (\""..msg.."\") n'existe pas.");
	end
end

-- ==========================================
-- Fonctions de lecture et d'arrêt de musique
-- ==========================================

local musicselected = "Sound\\Music\\ZoneMusic\\Naxxramas\\NaxxramasSpiderWing1.mp3"

-- PlayMusicFunction() : joue la musique sélectionnée
function PlayMusicFunction()
	PlayMusic(musicselected, "Ambience");
	PlayButtonSound();
end

-- StopMusicFunction() : arrête la musique en train d'être jouée
function StopMusicFunction()
	StopMusic();
	PlayButtonSound()
end

-- =================================






MyModData = {}

function MyMod_OnLoad()
  local nb = 1
  for i=1,50 do
    MyModData[i] = "Test "..nb
	nb = nb + 1
  end
  MyModScrollBar:Show()
end

function MyModScrollBar_Update()
  local line; -- 1 through 5 of our window to scroll
  local lineplusoffset; -- an index into our data calculated from the scroll offset
  FauxScrollFrame_Update(MyModScrollBar,50,10,16); -- Scrollbarconcernée / nbboutons / nbaffichagesfinscroll / tailleboutons
  for line=1,10 do
    lineplusoffset = line + FauxScrollFrame_GetOffset(MyModScrollBar);
    if lineplusoffset <= 50 then
      getglobal("MyModEntry"..line):SetText(MyModData[lineplusoffset]);
      getglobal("MyModEntry"..line):Show();
    else
      getglobal("MyModEntry"..line):Hide();
    end
  end
end

