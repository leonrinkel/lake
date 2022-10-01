#include <cstdint>

#include <gtest/gtest.h>
#include <verilated.h>

#include "Vlake.h"

class LAKE_Test : public ::testing::Test
{
protected:

    VerilatedContext* context;
    Vlake* uut;

    void SetUp() override
    {
        this->context = new VerilatedContext;
        this->context->traceEverOn(true);
        this->uut = new Vlake{context};
    }

    void TearDown() override
    {
        delete this->uut;
        delete this->context;
    }

    void Cycle()
    {
        this->uut->i_clk ^= 1;
        this->uut->eval();
        context->timeInc(1);
        this->uut->i_clk ^= 1;
        this->uut->eval();
        context->timeInc(1);
    }
};

TEST_F(LAKE_Test, Test)
{
    this->uut->i_clk = 0;

    // reset for 3 cycles
    this->uut->i_rst = 1;
    for (int i = 0; i < 3; i++)
    {
        this->Cycle();
    }

    // cycle till magic halt inst
    this->uut->i_rst = 0;
    do
    {
        this->Cycle();
    }
    while (!this->uut->o_halt);
}
