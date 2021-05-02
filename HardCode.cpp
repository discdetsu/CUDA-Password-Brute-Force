#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

bool check(char *pass, char c1, char c2, char c3){

    if (c1 == pass[0] && c2 == pass[1] && c3 == pass[2])
        return true;

    return false;
}
int main()
{
	string temp = ""; 
    char pass[4] = "abc";
    int c1,c2,c3 = 32;

    cout << pass[2]++ << endl;
    for (c1 = 32; c1 < 127; c1++){
     
        for (c2 = 32; c2 < 127; c2++){

            for (c3 = 32; c3 < 127; c3++){
                
                if(check(pass, (char)c1, (char)c2, (char)c3)){ 
                    cout << "found!" << endl;
                    break;
                }
                // else {cout << (char)c1 << (char)c2 << (char)c3 << endl;}

                
            }
        }
    }
    
    
    
	return 0;

}