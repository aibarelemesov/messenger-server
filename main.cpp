#include <iostream>
#include <cstring>
#include <unistd.h>
#include <netinet/in.h>

int main() {
    int server_fd, client_fd;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[1024] = {0};

    // Create socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == 0) {
        perror("socket failed");
        return 1;
    }

    // Allow port reuse
    setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(8080);

    // Bind to port
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
        perror("bind failed");
        return 1;
    }

    listen(server_fd, 3);
    std::cout << "Listening on port 8080..." << std::endl;

    client_fd = accept(server_fd, (struct sockaddr*)&address, (socklen_t*)&addrlen);
    if (client_fd < 0) {
        perror("accept");
        return 1;
    }

    read(client_fd, buffer, 1024);
    std::cout << "Received: " << buffer << std::endl;

    std::string response = "Hello from server\n";
    send(client_fd, response.c_str(), response.length(), 0);

    close(client_fd);
    close(server_fd);
    return 0;
}
