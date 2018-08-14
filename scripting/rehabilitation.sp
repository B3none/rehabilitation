#include <sourcemod>
#include <sdktools>
#include <cstrike>

#pragma semicolon 1
#pragma newdecls required

#define MESSAGE_PREFIX "[\x02MelonCartel\x01]"

public Plugin myinfo = 
{
	name = "[MelonCartel] Rehabilitation",
	author = "B3none, Venom",
	description = "A simple chat command to let admins respawn a player in Counter Strike.",
	version = "1.0.2",
	url = "https://github.com/b3none"
}

public void OnPluginStart()
{
	RegAdminCmd("sm_respawn", RespawnTarget, ADMFLAG_GENERIC);
}

public Action RespawnTarget(int client, int args)
{
	if (args < 1) {
		PrintToChat(client, "%s Usage: sm_respawn <#userid|name>", MESSAGE_PREFIX);
		return;
	}
	
	char queryString[64];
	GetCmdArg(1, queryString, sizeof(queryString));
	
	int foundTargets[MAXPLAYERS + 1];
	bool uselessShit;
	char targetName[64];
	int foundTargetsCount = 0;
	
	foundTargetsCount = ProcessTargetString(queryString, client, foundTargets, MAXPLAYERS + 1, COMMAND_FILTER_CONNECTED, targetName, sizeof(targetName), uselessShit);
	
	if (foundTargetsCount > 1) {
		PrintToChat(client, "%s Multiple targets found!", MESSAGE_PREFIX);
		return;
	} else if (foundTargetsCount == 0) {
		PrintToChat(client, "%s Nobody found!", MESSAGE_PREFIX);
		return;
	}
	
	for (int target = 0; target <= sizeof(foundTargets); target++) {
		if (IsValidClient(foundTargets[target])) {
			if (!IsPlayerAlive(foundTargets[target])) {
				PrintToChatAll("%s %N has just respawned %s", MESSAGE_PREFIX, client, targetName);
				
				Respawn(foundTargets[target]);
				return;
			}
			
			PrintToChat(client, "%s The target is already alive.", MESSAGE_PREFIX);
			return;
		}
	}
	
	PrintToChat(client, "%s The target is not valid.", MESSAGE_PREFIX);
}

void Respawn(int target)
{
	CS_RespawnPlayer(target);
}

stock bool IsValidClient(int client)
{
	return client > 0 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client);
}