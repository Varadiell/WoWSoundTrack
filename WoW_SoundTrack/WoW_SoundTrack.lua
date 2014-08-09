
-- ============================
-- Variables locales de l'addOn
-- ============================

-- Musique définie directement en attendant d'être meilleur en LUA !
local musicselected = "";



-- ===================================================
-- Création des évènements et des scripts déclencheurs
-- ===================================================

-- Création de la Frame EventFrame
local EventFrame = CreateFrame("Frame");

-- Création des évènements déclencheurs de EventFrame
EventFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
EventFrame:SetScript("OnEvent", EventFunction);

-- Création du script déclenché par les évènements déclencheurs de EventFrame
function EventFunction(self, event, ...)
	if event == "PLAYER_ENTERING_WORLD" then
		InitializeWST();
	end
end



-- ====================
-- Fonctions de l'addOn
-- ====================

-- InitializeWST() : Initialise l'addOn
function InitializeWST()
	-- HideMainFrame(); -- TODO: ligne à décommenter
	-- ButtonPlay:Disable(); -- TODO: ligne à décommenter
	ButtonStop:Disable();
	musicselected = "Sound\\Music\\ZoneMusic\\Naxxramas\\NaxxramasSpiderWing1.mp3"; -- TODO: ligne à enlever
	UpdateSoundTrackList();
end

-- UpdateSundTrackList() : Recherche dans les dossiers du jeu la liste des musiques
function UpdateSoundTrackList()
	-- TODO: Algorithme à ajouter
end

-- ShowMainFrame() : Affiche la fenêtre
function ShowMainFrame()
	if(MainFrame:IsShown()) then
		HideMainFrame();
		PlayCloseSound();
	else
		ShowUIPanel(MainFrame);
		PlayOpenSound();
	end
end

-- HideMainFrame() : Cache la fenêtre
function HideMainFrame()
	HideUIPanel(MainFrame);
	PlaySound("igCharacterInfoClose");
end

-- PlayOpenSound() : Joue le son d'ouverture de la fenêtre
function PlayOpenSound()
	PlaySound("igCharacterInfoOpen");
end

-- PlayCloseSound() : Joue le son de fermeture de la fenêtre
function PlayCloseSound()
	PlaySound("igCharacterInfoClose");
end

-- PlayButtonSound() : Joue le son d'un bouton actionné
function PlayButtonSound()
	PlaySound("UChatScrollButton");
end

-- EnableButtonPlay() : Rend le bouton Jouer utilisable
function EnableButtonPlay()
	ButtonPlay:Enable();
end

-- DisableButtonPlay() : Rend le bouton Jouer inutilisable
function DisableButtonPlay()
	ButtonPlay:Disable();
end

-- EnableButtonStop() : Rend le bouton Stop utilisable
function EnableButtonStop()
	ButtonStop:Enable();
end

-- DisableButtonStop() : Rend le bouton Stop inutilisable
function DisableButtonStop()
	ButtonStop:Disable();
end

-- PlayMusicFunction() : Joue la musique sélectionnée par l'utilisateur
function PlayMusicFunction()
	PlayMusic(musicselected, "Ambience");
end

-- StopMusicFunction() : Arrête la musique en cours de lecture
function StopMusicFunction()
	StopMusic();
end

-- SetMusicTitle(string) : Définit le titre de la musique en cours de lecture
function SetMusicTitle(title)
	StringMusiqueEnCours:SetText(title);
end

-- ClearMusicTitle() : Efface le nom de la musique en cours de lecture
function ClearMusicTitle()
	StringMusiqueEnCours:SetText("---");
end



-- ==========================
-- Commandes slash de l'AddOn
-- ==========================

-- "/ws" : ouvre ou ferme la fenêtre en fonction de son état
-- "/ws open" : ouvre ou ferme la fenêtre en fonction de son état
-- "/ws close" : ferme la fenêtre si elle est ouverte

SLASH_SlashCmd_1 = "/ws";
SLASH_SlashCmd_2 = "/wst";
SLASH_SlashCmd_3 = "/wost";
SLASH_SlashCmd_4 = "/wows";
SLASH_SlashCmd_5 = "/wowst";
SLASH_SlashCmd_6 = "/wowost";

SlashCmdList["SlashCmd_"] = function(msg)
	if(msg:trim() == "open" or msg:trim() == "run") then
		ShowMainFrame();
	elseif(msg:trim() == "close" or msg:trim() == "hide") then
		HideMainFrame();
	elseif(msg:trim() == "") then
		ShowMainFrame();
	else
		print("WoW_SoundTrack : cette commande (\""..msg.."\") n'existe pas.");
	end
end



-- ===================================================
-- Fonctions appelées lors de l'activation des boutons
-- ===================================================

-- ButtonPlayFunction() : Appelé lors d'une activation du bouton Jouer
function ButtonPlayFunction()
	PlayMusicFunction();
	PlayButtonSound();
	DisableButtonPlay();
	EnableButtonStop();
	SetMusicTitle("Naxxramas - Le Quartier des Arachniques"); -- TODO: à remplacer par la variable musicselected
end

-- ButtonStopFunction() : Appelé lors d'une activation du bouton Arrêter
function ButtonStopFunction()
	StopMusicFunction();
	PlayButtonSound();
	EnableButtonPlay();
	DisableButtonStop();
	ClearMusicTitle();
end

-- ButtonCloseFunction() : Appelé lors d'une activation du bouton Fermer
function ButtonCloseFunction()
	HideMainFrame();
	PlayCloseSound();
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

