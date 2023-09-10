#include <iostream>
#include <fstream>

int main(int argc, char* argv[]){
    if(argc != 2){
        std::cerr << "Mauvais arguments" << std::endl;
        std::cerr << "ludo <entree.lc>" << std::endl;
        return EXIT_FAILURE;
    }

    std::fstream input(argv[1], std::ios::in); //on lit le fichier d'entré
    char* contenu;
    input.read(contenu, )

    std::cout << argv[1] << std::endl;
    return EXIT_SUCCESS;
}