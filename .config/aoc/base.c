#include <stdio.h>

int part1(char *line) {
  return 0;
}

int part2(char *line) {
  return 0;
}

int main() {
  FILE *file = fopen("../input.txt", "r");
  if (file == NULL) {
    printf("could not open file\n");
    return 1;
  }

  char line[8192];
  if (fgets(line, sizeof(line), file) != NULL) {
    printf("%d\n", part1(line));
    printf("%d\n", part2(line));
  }

  fclose(file);
  return 0;
}
