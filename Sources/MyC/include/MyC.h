struct tty {
   int num1;
   int num2;
};

void my_c_func1();
void my_c_func2(struct tty *tty);
void my_c_func3(struct tty tty);
void createPseudoTerminal(struct tty **tty);
