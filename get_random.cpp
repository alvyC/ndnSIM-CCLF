#include <iostream>
#include<time.h> 

int main(int argc, char** argv) {
 
  int noOfNodes = std::stoi(argv[1]);
  srand(time(0)); 
  
  for (int i = 0; i < noOfNodes/2; i++) {
    std::cout << (rand() % noOfNodes) + 1 << " ";
  }
  std::cout << std::endl;
}
