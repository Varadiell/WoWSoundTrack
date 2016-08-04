
-- ============================
-- Variables locales de l'addOn
-- ============================

local musicplayednumber = 0;
local musicselectedtitle = "";
local musicselectednumber = 0;
local MusicData = {} -- Names / Paths (tableau à deux dimensions)
local tabNumber = 1; --- 1:général / 2:favoris

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
	ScrollBarListFavori_Update();
	CheckButtonTab1:SetChecked(true);
	SetPortraitToTexture(MainFrame.portrait, "Interface/ICONS/Achievement_General");
	--ShowMainFrame(); -- TODO: ligne à commenter
	DisableButtonPlay();
	DisableButtonStop();
	DisableButtonFavori();
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
	ScrollBarFrameFavori:Hide();
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

-- EnableButtonFavori() : Rend le bouton Favori utilisable
function EnableButtonFavori()
	ButtonFavori:Enable();
end

-- DisableButtonFavori() : Rend le bouton Favori inutilisable
function DisableButtonFavori()
	ButtonFavori:Disable();
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

-- SetMusicSelection(nb) : Définit la musique actuellement sélectionnée
function SetMusicSelection(nb)
	musicselectednumber = nb;
	musicselectedtitle = MusicData[1][musicselectednumber];
	if musicselectednumber == musicplayednumber then
		DisableButtonPlay();
	else
		EnableButtonPlay();
	end
	if IsAFavoriteTrack(musicselectednumber) then
		DisableButtonFavori();
	else
		EnableButtonFavori();
	end
	PlayButtonSound();
	ScrollBarList_Update();
	ScrollBarListFavori_Update();
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
	elseif(msg:trim() == "next") then
		SlashCmdFunctionNext();
	elseif(msg:trim() == "previous") then
		SlashCmdFunctionPrevious();
	elseif(msg:trim() == "play") then
		SlashCmdFunctionPlay();
	elseif(msg:trim() == "playrandom") then
		SlashCmdFunctionPlayRandom();
	elseif(msg:trim() == "stop") then
		SlashCmdFunctionStop();
	elseif(msg:trim() == "") then
		ShowMainFrame();
	else
		print("|cff4BB5C1 WoW_ST :|r cette commande (\""..msg.."\") n'existe pas.");
	end
end



-- ===================================
-- Fonctions appelées par SlashCommand
-- ===================================

-- SlashCmdFunctionNext() : Musique suivante
function SlashCmdFunctionNext()
	if musicselectednumber == #SoundFiles_Paths then
		SetMusicSelection(1);
	else
		SetMusicSelection(musicselectednumber + 1);
	end
	ButtonPlayFunction();
end

-- SlashCmdFunctionPrevious() : Musique précédente
function SlashCmdFunctionPrevious()
	if musicselectednumber == 1 then
		SetMusicSelection(#SoundFiles_Paths);
	else
		SetMusicSelection(musicselectednumber - 1);
	end
	ButtonPlayFunction();
end

-- SlashCmdFunctionPlay() : Jouer la musique actuellement sélectionnée
function SlashCmdFunctionPlay()
	if musicselectednumber ~= 0 then
		PlayButtonSound()
		ButtonPlayFunction()
	end
end

-- SlashCmdFunctionPlayRandom() : Jouer une musique aléatoire
function SlashCmdFunctionPlayRandom()
	SetMusicSelection(math.random(1, #SoundFiles_Paths)); -- Nombre de musiques max
	print("|cff4BB5C1 WoW_ST|r |cff96CA2D"..musicselectednumber.."|r "..musicselectedtitle);
	ButtonPlayFunction();
end

-- SlashCmdFunctionNext() : Arrêter la musique actuellement en train d'être jouée
function SlashCmdFunctionStop()
	if musicplayednumber ~= 0 then
		PlayButtonSound()
		ButtonStopFunction()
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
	ScrollBarListFavori_Update();
end

-- ButtonStopFunction() : Appelé lors d'une activation du bouton Arrêter
function ButtonStopFunction()
	StopMusicFunction();
	PlayButtonSound();
	EnableButtonPlay();
	DisableButtonStop();
	ClearMusicTitle();
	ScrollBarList_Update();
	ScrollBarListFavori_Update();
end

-- ButtonCloseFunction() : Appelé lors d'une activation du bouton Fermer
function ButtonCloseFunction()
	HideMainFrame();
	PlayCloseSound();
end

-- ButtonListFunction(Int n) : Appelé lors d'une activation d'un des 14 boutons de la liste de sélection
function ButtonListFunction(n)
	if tabNumber == 1 then
		SetMusicSelection(n + FauxScrollFrame_GetOffset(ScrollBarList));
	elseif tabNumber == 2 then
		SetMusicSelection(WoW_SoundTrack_Favorites[n + FauxScrollFrame_GetOffset(ScrollBarListFavori)]);
	end
end

-- CheckButtonTabFunction(Int n) : Appelé lors d'une activation d'un des 2 CheckButtonTab
function CheckButtonTabFunction(n)
	PlayTabSound();
	if n == 1 then
		CheckButtonTab1:SetChecked(true);
		CheckButtonTab2:SetChecked(false);
		ScrollBarFrame:Show();
		ScrollBarFrameFavori:Hide();
		tabNumber = 1;
	else
		CheckButtonTab1:SetChecked(false);
		CheckButtonTab2:SetChecked(true);
		ScrollBarFrame:Hide();
		ScrollBarFrameFavori:Show();
		tabNumber = 2;
	end
end

-- ButtonFavoriFunction() : Appelé lors d'une activation du bouton Favori
function ButtonFavoriFunction()
	if IsAFavoriteTrack(musicselectednumber) == false then
		WoW_SoundTrack_Favorites[#WoW_SoundTrack_Favorites + 1] = musicselectednumber;
	end
	-- Tri (par ordre croissant) des id des musiques
	table.sort(WoW_SoundTrack_Favorites, compare);
	DisableButtonFavori();
	PlayButtonSound();
	ScrollBarList_Update();
	ScrollBarListFavori_Update();
end


-- ========================================================================
-- Fonction appelées lors de l'utilisation de la liste de choix (scrollbar)
-- ========================================================================

-- ScrollBarList_Update() : Met à jour le contenu affiché par les boutons de la liste de choix
function ScrollBarList_Update()
	local line; -- 14 lignes à afficher
	local lineplusoffset; -- Permettra d'afficher le texte d'un bouton grâce au numéro de ligne (de 1 à 14) et au décalage de l'affichage
	local textToSet; -- Texte à mettre sur un ButtonList
	FauxScrollFrame_Update(ScrollBarList, #SoundFiles_Paths, 14, 16); -- Scrollbarconcernée / nblignestotal / nblignesàafficher / tailleboutons
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(ScrollBarList);
		if lineplusoffset <= #SoundFiles_Paths then
			textToSet = "|cff4BB5C1"..lineplusoffset.."|r";
			if IsAFavoriteTrack(lineplusoffset)  then
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


-- ScrollBarListFavori_Update() : Met à jour le contenu favori affiché par les boutons de la liste de choix
function ScrollBarListFavori_Update()
	local line; -- 14 lignes à afficher
	local lineplusoffset; -- Permettra d'afficher le texte d'un bouton grâce au numéro de ligne (de 1 à 14) et au décalage de l'affichage
	local textToSet; -- Texte à mettre sur un ButtonList
	FauxScrollFrame_Update(ScrollBarListFavori, #WoW_SoundTrack_Favorites, 14, 16); -- Scrollbarconcernée / nblignestotal / nblignesàafficher / tailleboutons
	for line=1,14 do
		lineplusoffset = line + FauxScrollFrame_GetOffset(ScrollBarListFavori);
		if lineplusoffset <= #WoW_SoundTrack_Favorites then
			textToSet = "|cff4BB5C1"..WoW_SoundTrack_Favorites[lineplusoffset].."|r";
			if IsAFavoriteTrack(WoW_SoundTrack_Favorites[lineplusoffset]) then
				textToSet = textToSet.."|cffC03000*|r";
			end
			if WoW_SoundTrack_Favorites[lineplusoffset] == musicplayednumber then
				getglobal("ButtonList"..line.."Favori"):SetText(textToSet.." |cff96CA2D"..MusicData[1][WoW_SoundTrack_Favorites[lineplusoffset]].."|r");
			elseif WoW_SoundTrack_Favorites[lineplusoffset] == musicselectednumber then
				getglobal("ButtonList"..line.."Favori"):SetText(textToSet.." |cffFBD437"..MusicData[1][WoW_SoundTrack_Favorites[lineplusoffset]].."|r");
			else
				getglobal("ButtonList"..line.."Favori"):SetText(textToSet.." "..MusicData[1][WoW_SoundTrack_Favorites[lineplusoffset]]);
			end
			getglobal("ButtonList"..line.."Favori"):Show();
		else
			getglobal("ButtonList"..line.."Favori"):Hide();
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
-- Fonctions pour tri des favoris
function compare(a, b)
	return a < b;
end
