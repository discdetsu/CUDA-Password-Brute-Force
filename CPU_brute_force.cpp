#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>
#include <time.h>

using namespace std;

const string ALPHABET_SET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

//sequential brute force
void cpu_bruteforce(string alphabet_set){
    int len = alphabet_set.length();
    for (int c1 = 0; c1 < len; c1++){
        for (int c2 = 0; c2 < len; c2++){
            for (int c3 = 0; c3 < len; c3++){
                cout << alphabet_set[c1] << alphabet_set[c2] << endl;
            }
        }
    }
}


int main()
{
    clock_t start = clock();
    cpu_bruteforce(ALPHABET_SET);
    clock_t end = clock();
    double elapsed = double(end - start)/CLOCKS_PER_SEC * 1000;
    cout << "All combination with password length: " << 3 << " in: " << elapsed << " milliseconds." << endl;
    
	return 0;

}