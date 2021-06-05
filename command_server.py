#!/bin/env python3

from http.server import BaseHTTPRequestHandler, HTTPServer
import time

hostName = "localhost"
serverPort = 7112

commands = ["turtle.forward()", "turtle.turnLeft()"]
current_command = 0


class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        global current_command
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes(commands[current_command], "utf-8"))
        current_command = 1 - current_command


if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
