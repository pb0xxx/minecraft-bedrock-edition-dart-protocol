// https://github.com/pb0xxx

import 'package:bedrock_edition_protocol/bedrock_edition_protocol.dart';

void main() async {
  // Obtain information about the Minecraft Bedrock server.
  // smc.mc-complex.com may not work every time
  // https://servers-minecraft.net/minecraft-bedrock-servers
  try {
    PingResponse bedrockServer = await ping('smc.mc-complex.com', 19132, 500);

    if (bedrockServer.protocolNumber != null) {
      print("Server MOTD: ${bedrockServer.description}");
      print("Server Version: ${bedrockServer.version}");
      print("Default Game Mode: ${bedrockServer.defaultMode}");
      print("Players: ${bedrockServer.onlinePlayers} / ${bedrockServer.maxPlayers}");
    } else {
      print("An error occurred: The server did not respond.");
    }
  } catch (e) {
    // Handle any exceptions, such as timeouts or network errors.
    print("An error occurred: $e");
  }
}