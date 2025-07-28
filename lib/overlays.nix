{ aoc-runtime }:

final: prev: {
  aoc-runtime = aoc-runtime.packages.${final.system}.default;
}
