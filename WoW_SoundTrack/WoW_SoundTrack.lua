
-- ============================
-- Variables locales de l'addOn
-- ============================

local musicplayednumber = 0;
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
	LoadAndShowSoundTrackList();
	ScrollBarList_Update();
	CheckButtonTab1:SetChecked(true);
	SetPortraitToTexture(MainFrame.portrait, "Interface/ICONS/Achievement_General")
	ShowMainFrame(); -- TODO: ligne à enlever
	DisableButtonPlay(); -- TODO: ligne à décommenter
	DisableButtonStop();
	InitSavedVariables();
end

-- InitSavedVariables() : Initialise les SavedVariables si elles n'existent pas
function InitSavedVariables()
	if(WoW_SoundTrack_Favorites == nil) then
		WoW_SoundTrack_Favorites = {};
	end
end

-- LoadAndShowSoundTrackList() : Recherche dans les fichiers la liste des noms et des emplacements des musiques et l'affiche
function LoadAndShowSoundTrackList()
	MusicData[1] = SoundFiles_Names;
	MusicData[2] = SoundFiles_Paths;
	ScrollBarList:Show() -- Note: Cela doit toujours être fait après avoir chargé les listes !
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

-- PlayTabSound() : Joue le son d'un onglet ouvert
function PlayTabSound()
	PlaySound("igCharacterInfoTab");
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
	musicplayednumber = musicselectednumber;
end

-- StopMusicFunction() : Arrête la musique en cours de lecture
function StopMusicFunction()
	StopMusic();
	musicplayednumber = 0;
end

-- SetMusicTitle(string) : Définit le titre de la musique en cours de lecture
function SetMusicTitle(title, number)
	StringMusiqueEnCours:SetText("|cff4BB5C1"..number.."|r "..title);
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
	SetMusicTitle(musicselectedtitle, musicselectednumber); -- TODO: à remplacer par la variable musicselected
	ScrollBarList_Update();
end

-- ButtonStopFunction() : Appelé lors d'une activation du bouton Arrêter
function ButtonStopFunction()
	StopMusicFunction();
	PlayButtonSound();
	EnableButtonPlay();
	DisableButtonStop();
	ClearMusicTitle();
	ScrollBarList_Update()
end

-- ButtonCloseFunction() : Appelé lors d'une activation du bouton Fermer
function ButtonCloseFunction()
	HideMainFrame();
	PlayCloseSound();
end

-- ButtonListFunction(Int n) : Appelé lors d'une activation d'un des 14 boutons de la liste de sélection
function ButtonListFunction(n)
	musicselectednumber = n + FauxScrollFrame_GetOffset(ScrollBarList);
	musicselectedtitle = MusicData[1][musicselectednumber];
	if musicselectednumber == musicplayednumber then
		DisableButtonPlay();
	else
		EnableButtonPlay();
	end
	PlayButtonSound();
	ScrollBarList_Update();
end

-- CheckButtonTabFunction(Int n) : Appelé lors d'une activation d'un des 2 CheckButtonTab
function CheckButtonTabFunction(n)
	PlayTabSound();
	if n == 1 then
		CheckButtonTab1:SetChecked(true);
		CheckButtonTab2:SetChecked(false);
		ScrollBarFrame:Show();
	else
		CheckButtonTab1:SetChecked(false);
		CheckButtonTab2:SetChecked(true);
		ScrollBarFrame:Hide();
	end
end


-- ========================================================================
-- Fonction appelées lors de l'utilisation de la liste de choix (scrollbar)
-- ========================================================================

-- ScrollBarList_Update() : Met à jour le contenu affiché par les boutons de la liste de choix
function ScrollBarList_Update()
	local line; -- 14 lignes à afficher
	local lineplusoffset; -- Permettra d'afficher le texte d'un bouton grâce au numéro de ligne (de 1 à 14) et au décalage de l'affichage
	local textToSet; -- Texte à mettre sur un ButtonList
	FauxScrollFrame_Update(ScrollBarList,#SoundFiles_Paths,14,16); -- Scrollbarconcernée / nblignestotal / nblignesàafficher / tailleboutons
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(ScrollBarList);
		if lineplusoffset <= #SoundFiles_Paths then
			textToSet = "|cff4BB5C1"..lineplusoffset.."|r";
			if(IsAFavoriteTrack(lineplusoffset)) then
				textToSet = textToSet.."|cffC03000*|r";
			end
			if lineplusoffset == musicplayednumber then
				getglobal("ButtonList"..line):SetText(textToSet.." |cff96CA2D"..MusicData[1][lineplusoffset].."|r");
			elseif lineplusoffset == musicselectednumber then
				getglobal("ButtonList"..line):SetText(textToSet.." |cffFBD437"..MusicData[1][lineplusoffset].."|r");
			else
				getglobal("ButtonList"..line):SetText(textToSet.." "..MusicData[1][lineplusoffset]);
			end
			getglobal("ButtonList"..line):Show();
		else
			getglobal("ButtonList"..line):Hide();
		end
	end
end

-- IsAFavoriteTrack() : Répond par un booléen si la piste en paramètre est une piste favorite.
function IsAFavoriteTrack(musicNumber)
	if WoW_SoundTrack_Favorites then
		for i=1, #WoW_SoundTrack_Favorites do
			if(WoW_SoundTrack_Favorites[i] == musicNumber) then
				return true;
			end
		end
	end
	return false;
end


-- ==============================






