int main();

__attribute__((naked)) void _start() {
  asm("li sp,4096");  // set up the stack pointer
  main();             // call main()
  while(1);           // Spin loop when main() returns
}

int expo(int a, int b) {
    // Tests BLT & BEQ
    if (b == 0) {
        return 1;
    }
    int result = a;
    for (int i = 0; i < b; i++) {
        result *= a;
    }
    return result;
}

int factorial(int a) {
    // Tests BGE
    if (a == 0) {
        return 1;
    }
    int result = a;
    for (int i = a - 1; i > 0; i--) {
        result *= i;
    }
    return result;
}

int main() {
    // Test BNE
    int x = 5;
    int z = 0;
    if (x != z) {
        z = factorial(x);
    }

    // Test Negative Arithmetic
    x = -3;
    int y = 3;
    int n = expo(x, y);
    int result = 0;
    result = z + n;
    return 0;
}
