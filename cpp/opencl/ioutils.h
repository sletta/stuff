#pragma once

#include <iostream>
#include <fstream>
#include <string>

inline std::string io_read_file(const char *fileName)
{
    std::string content, line;
    std::ifstream file(fileName);
    if (file.is_open()) {
        while (getline(file,line)) {
            content.append(line);
            content.append("\n");
        }
    }
    file.close();
    return content;
}