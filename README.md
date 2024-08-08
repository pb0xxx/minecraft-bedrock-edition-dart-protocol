# Minecraft Bedrock Edition Protocol - Dart library

This documentation provides an overview of the Dart library that allows users to retrieve basic information about a Minecraft Bedrock Edition server.
The main feature of the library is the ability to ping a server and receive details such as the number of online players, the server's MOTD (Message of the Day), and more.
The library maximizes the use of standard libraries to ensure compatibility across multiple platforms, including Flutter, Android, iOS, Web, and Desktop.
Only one external package is used, which remains compatible with all platforms.

## Compatibility

- **Platforms:** Flutter, Android, iOS, Web, Desktop.
- **Languages:** Dart

## Library structure

The library is minimalist, containing only the main library file with functions and classes, along with a single example.
The main library file is located at `bedrock_edition_protocol/lib/src/bedrock_edition_protocol_base.dart`.

## Getting Started

### Example: Basic Server Information

Let's assume we have a Minecraft Bedrock server with the hostname `bedrock.vortexnetwork.net`. We want to obtain the following details:

- Number of online players
- Maximum player capacity
- Server MOTD
- Server version
- Default game mode

### Example Code

```dart
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
```

### Sample Output

```
Server MOTD: §r§b---------§r§8§l[-  §r§f§lCOMPLEX  §r§b§lGAMING  §r§8§l-]§r§b§l--------§r
Server Version: 1.21.2
Default Game Mode: Survival
Players: 1641 / 5000
```

### How it works?

1. **Import the library:** The library responsible for handling the ping process is imported.
2. **Ping the server:** Within the main function, a `PingResponse` object is created, which holds the server's ping response.
3. **Check the response:** A conditional check is performed to verify if the server responded correctly by checking the `protocolNumber`. This ensures the server's response is valid.
4. **Retrieve information:** If the server responds, the MOTD, version, player counts, and default game mode are printed using the appropriate properties of the `PingResponse` object.

### Parameters

- **Hostname:** The hostname or IP address of the Minecraft Bedrock server.
- **Port:** The server's port, typically `19132` for Bedrock Edition (the standard port for Minecraft Bedrock servers).
- **Timeout:** The maximum time to wait for a server response in milliseconds. For example, a timeout of `500 ms` means the function will stop waiting after half a second.

## Additional examples

### Example 2: Using an IP Address and measuring latency

```dart
import 'package:bedrock_edition_protocol/bedrock_edition_protocol.dart';

void main() async {
  PingResponse bedrockServer = await ping('51.195.63.77', 19132, 500); // Obtain server data.
  
  if (bedrockServer.protocolNumber != null) {
    print("Ping: ${bedrockServer.latency} ms");
  } else {
    print("The server did not respond.");
  }
}
```

#### Output

```
Ping: 37 ms
```

### Example 3: Non-existent host

```dart
import 'package:bedrock_edition_protocol/bedrock_edition_protocol.dart';

void main() async {
  PingResponse bedrockServer = await ping('255.255.255.0', 19132, 500); // Obtain server data.
  
  if (bedrockServer.protocolNumber != null) {
    print("Ping: ${bedrockServer.latency} ms");
  } else {
    print("The server did not respond.");
  }
}
```

#### Output

```
The server did not respond.
```

## PingResponse class

- **`description` ⇒ String, null**  
  Returns the server's description (MOTD).

- **`protocolNumber` ⇒ int, null**  
  Returns the server's protocol number.

- **`version` ⇒ String, null**  
  Returns the server's version.

- **`onlinePlayers` ⇒ int, null**  
  Returns the number of online players on the server.

- **`maxPlayers` ⇒ int, null**  
  Returns the maximum number of players the server can accommodate.

- **`type` ⇒ String, null**  
  Returns the server type. Possible types:
  - `nukkitx`
  - `bedrock`
  - `unknown`

- **`defaultMode` ⇒ String, null**  
  Returns the server's default game mode.

- **`worldName` ⇒ String, null**  
  Returns the name of the main game world.  
  **Note:** This is only returned for Bedrock-type servers. It is not returned for NukkitX servers.

- **`latency` ⇒ int, null**  
  Returns the server's latency in milliseconds.

## Code readability

The source code of the library is designed to be clear and straightforward, supported by detailed comments to enhance understanding.
