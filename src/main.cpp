#include "main.h"
#include "test.h"
#include <iostream>
#include <stdio.h>

extern "C" int add(int a, int b);

int main(void) {
  int a = 10, b = 20;
  int result = add(a, b);
  std::cout << "result = " << result << std::endl;
  std::cout << "hello" << std::endl;
  print_test();
  return 0;
}