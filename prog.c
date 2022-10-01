int fib(int n);

void main(void)
{
    // calc fib(16) to reg a5
    register int* a5 asm("a5");
    *a5 = fib(16);

    // magic halt inst
    __asm__("li x0, 0x123");
}

/** iterative fib */
int fib(int n)
{
    int a = 0, b = 1, c;
    while (--n > 0)
    {
        c = a + b;
        a = b;
        b = c;
    }
    return b;
}
