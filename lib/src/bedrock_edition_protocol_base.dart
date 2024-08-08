// https://github.com/pb0xxx

import 'dart:async';
import 'dart:io';
import 'package:convert/convert.dart';

/// A class to hold the response details of a ping request.
class PingResponse {
  String? description;
  int? protocolNumber;
  String? version;
  int? onlinePlayers;
  int? maxPlayers;
  String? type;
  String? defaultMode;
  String? worldName;
  int? latency;

  // Constructor
  PingResponse();
}

/// Sends a ping to a Minecraft server and returns the response details.
///
/// This function sends a UDP packet to the specified server and parses the
/// response to extract server information such as description, protocol version,
/// online players, and latency.
///
/// [hostname] is the server's hostname or IP address.
/// [port] is the server's port.
/// [timeout] is the maximum time to wait for a response in milliseconds.
///
/// Returns a [PingResponse] object containing the server's information.
Future<PingResponse> ping(String hostname, int port, int timeout) async {
  final PingResponse result = PingResponse(); // Initialize the response object
  final Duration timeoutDuration = Duration(milliseconds: timeout); // Set the timeout duration

  // Resolve the server's IP address
  List<InternetAddress> addresses = await InternetAddress.lookup(hostname);
  if (addresses.isEmpty) {
    throw Exception('Failed to resolve the server address.');
  }
  final InternetAddress destinationAddress = addresses.first;

  final Stopwatch latency = Stopwatch()..start(); // Start measuring latency

  // Bind a UDP socket to any available address and the specified port
  RawDatagramSocket udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
  udpSocket.broadcastEnabled = true;

  // The data to be sent in hexadecimal format
  List<int> data = hex.decode("0100000000240d12D300ffff00fefefefefdfdfdfd12345678");

  // Send the data to the specified address and port
  udpSocket.send(data, destinationAddress, port);

  try {
    await udpSocket.listen((RawSocketEvent event) {
      Datagram? dg = udpSocket.receive();
      if (dg != null) {
        latency.stop(); // Stop latency measurement on response

        // Convert the response data to a string and split by the delimiter ";"
        String packet = String.fromCharCodes(dg.data).trim();
        List<String> args = packet.split(";");

        // Populate the PingResponse object with data from the response
        if (args.isNotEmpty) {
          result.description = args[1].replaceAll('Â', '');
        }
        if (args.length > 1) {
          result.protocolNumber = int.tryParse(args[2]);
        }
        if (args.length > 2) {
          result.version = args[3];
        }
        if (args.length > 3) {
          result.onlinePlayers = int.tryParse(args[4]);
        }
        if (args.length > 5) {
          result.maxPlayers = int.tryParse(args[5]);
        }
        if (args.length > 7) {
          result.defaultMode = args[8];
        }

        // Determine the server type based on the response length
        if (args.length == 10) {
          result.type = "nukkitx"; // Nukkitx server
        } else if (args.length == 13) {
          result.type = "bedrock"; // Standard Bedrock server
          result.worldName = args[7];
        } else {
          result.type = "unknown"; // Unknown server type
        }

        udpSocket.close();
      }
    }).asFuture<void>().timeout(timeoutDuration, onTimeout: () {
      udpSocket.close();
      throw TimeoutException('Server did not respond within the timeout period.');
    });
  } catch (e) {
    // Handle any errors, including timeouts
    result.latency = -1; // Set latency to -1 in case of an error
  }

  // Calculate and store the latency
  result.latency = latency.elapsedMilliseconds;

  return result;
}