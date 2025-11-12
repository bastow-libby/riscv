
int main ();

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
