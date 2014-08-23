
-- ============================
-- Variables locales de l'addOn
-- ============================

local musicselectedtitle = "";
local musicselectednumber = 0;
local MusicData = {} -- Names / Paths (tableau à deux dimensions)

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
	SetPortraitToTexture(MainFrame.portrait, "Interface/ICONS/Achievement_General")
	-- HideMainFrame(); -- TODO: ligne à décommenter
	DisableButtonPlay(); -- TODO: ligne à décommenter
	DisableButtonStop();
	UpdateSoundTrackList();
end

-- UpdateSundTrackList() : Recherche dans les dossiers du jeu la liste des musiques
function UpdateSoundTrackList()
	-- TODO: Algorithme à ajouter ?
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
	PlayMusic(MusicData[2][musicselectednumber], "Ambience");
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
	StringMusiqueEnCours:SetText("");
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
	SetMusicTitle(musicselectedtitle); -- TODO: à remplacer par la variable musicselected
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

-- ButtonListFunction(Int n) : Appelé lors d'une activation d'un des 13 boutons de la liste de sélection
function ButtonListFunction(n)
	musicselectednumber = n + FauxScrollFrame_GetOffset(MyModScrollBar);
	musicselectedtitle = MusicData[1][musicselectednumber];
	EnableButtonPlay();
	PlayButtonSound();
end

-- =================================



function MyMod_OnLoad()
	MusicData[1] = SoundFiles_Names;
	MusicData[2] = SoundFiles_Paths;
	MyModScrollBar:Show()
end

function MyModScrollBar_Update()
  local line; -- 13 lignes à afficher
  local lineplusoffset; -- Permettra d'afficher le texte d'un bouton grâce au numéro de ligne (de 1 à 13) et au décalage de l'affichage
  FauxScrollFrame_Update(MyModScrollBar,#SoundFiles_Paths,13,16); -- Scrollbarconcernée / nblignestotal / nblignesàafficher / tailleboutons
  for line=1,13 do
    lineplusoffset = line + FauxScrollFrame_GetOffset(MyModScrollBar);
    if lineplusoffset <= #SoundFiles_Paths then
      getglobal("MyModEntry"..line):SetText(MusicData[1][lineplusoffset]);
      getglobal("MyModEntry"..line):Show();
    else
      getglobal("MyModEntry"..line):Hide();
    end
  end
end

