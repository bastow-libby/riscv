
int main ();

/*
 * _start()
 *
 * startup code to initialize things and call main(). Should be located at
 * address 0 in instruction mem. Put it at the beginning of the C file to make
 * the compiler place it at addr 0.
 *
 */
__attribute__((naked)) void _start() {
  asm("li sp,4096");  // set up the stack pointer
  main();             // call main()
  while(1);           // Spin loop when main() returns
}

int main () {
  for (int k = 0; k < 100; k++) {
    asm("add x0,x0,x0");
  }
  return 0;
}
