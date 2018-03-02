force d1 9 2.5 ns
force d2 7 2.5 ns
force load 1 2.5 ns, 0 12.5 ns
force enable 1 2.5 ns, 0 62.5 ns, 1 82.5 ns
force up 1 12.5 ns, 1 22.5 ns, 1 32.5 ns, 1 42.5 ns, 1 52.5 ns, 0 62.5 ns, 0 72.5 ns, 0 82.5 ns, 0 92.5 ns
force clk 0 0 ns, 1 5 ns -repeat 10 ns
force clr 0 112.5
run 120 ns
