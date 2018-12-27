#include <fstream>
#include <iostream>
#include <regex>
#include <string>
#include <vector>

using namespace std;

#define A(a, b)                                   \
  if (tokens[0] == a)                             \
    rlt = b + format(bin(search(tokens[2])), 5) + \
          format(bin(search(tokens[3])), 5) +     \
          format(bin(search(tokens[1])), 5) + format("0", 11);
#define B(a, b, i, j)                             \
  if (tokens[0] == a)                             \
    rlt = b + format(bin(search(tokens[i])), 5) + \
          format(bin(search(tokens[j])), 5) + format(bin(tokens[3]), 16);
#define C(a, b)                                                           \
  if (tokens[0] == a) {                                                   \
    string immediate = search(tokens[2]);                                 \
    string tmp = tokens[2].substr(tokens[2].find("$"));                   \
    rlt = b + format(bin(search(tmp)), 5) +                               \
          format(bin(search(tokens[1])), 5) + format(bin(immediate), 16); \
  }
#define D(a, b) \
  if (tokens[0] == a) rlt = b + format(hex(tokens[1]), 26);

vector<string> &split(const string &str, const string &delimiters,
                      vector<string> &elems) {
  string::size_type pos, prev = 0;
  while ((pos = str.find_first_of(delimiters, prev)) != string::npos) {
    if (pos > prev) elems.emplace_back(str, prev, pos - prev);
    prev = pos + 1;
  }
  if (prev < str.size()) elems.emplace_back(str, prev, str.size() - prev);
  return elems;
}

string search(string str) {
  smatch sm;
  regex r("\\d+");
  regex_search(str.cbegin(), str.cend(), sm, r);
  return sm[0].str();
}

string bin(string str) {
  char bin[33];
  return string(itoa(atoi(str.c_str()), bin, 2));
}

string hex(string str) {
  char buf[33];
  return string(itoa(strtol(str.c_str(), NULL, 16), buf, 2));
}

string format(string str, int length) {
  if (str.length() > length) return str.substr(str.length() - length, length);
  return string(length, '0').substr(0, length - str.length()) + str;
}

string decode(string str) {
  vector<string> tokens;
  split(str, ", ", tokens);
  string rlt = "";
  A("add", "000000")
  A("sub", "000001")
  A("and", "010000")
  A("slt", "100111")
  B("addiu", "000010", 2, 1)
  B("andi", "010001", 2, 1)
  B("ori", "010010", 2, 1)
  B("xori", "010011", 2, 1)
  B("slti", "100110", 2, 1)
  B("beq", "110100", 1, 2)
  B("bne", "110101", 1, 2)
  C("sw", "110000")
  C("lw", "110001")
  D("j", "111000")
  D("jal", "111010")
  if (tokens[0] == "sll")
    rlt = "011000" + format("0", 5) + format(bin(search(tokens[2])), 5) +
          format(bin(search(tokens[1])), 5) +
          format(bin(search(tokens[3])), 5) + format("0", 6);
  if (tokens[0] == "bltz")
    rlt = "110110" + format(bin(search(tokens[1])), 5) + format("0", 5) +
          format(bin(tokens[2]), 16);
  if (tokens[0] == "jr")
    rlt = "111001" + format(bin(search(tokens[1])), 5) + format("0", 21);
  if (tokens[0] == "halt") rlt = "111111" + format("0", 26);
  return rlt;
}

int main(int argc, char *argv[]) {
  string in = argc >= 2 ? argv[1] : "in", out = argc >= 3 ? argv[2] : "out";
  ifstream is(in);
  ofstream os(out);
  if (is.fail() || os.fail()) return 1;
  for (string line; getline(is, line);) os << decode(line) << std::endl;
  is.close();
  os.close();
  return 0;
}