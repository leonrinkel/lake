int fib(int n)
{
    if (n <= 1) return n;
    return fib(n - 1) + fib(n - 2);
}

void main(void)
{
    // calc fib(16) to reg a5
    register int* a5 asm("a5");
    *a5 = fib(16);

    // magic halt inst
    __asm__("li x0, 0x123");
}
