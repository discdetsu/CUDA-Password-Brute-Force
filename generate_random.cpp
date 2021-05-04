#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

const char alphanum[] = "0123456789!@#$%^&*abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
int string_length = sizeof(alphanum)-1;

// bool check(char *pass, char c1, char c2, char c3){

//     if (c1 == pass[0] && c2 == pass[1] && c3 == pass[2])
//         return true;

//     return false;
// }



int main()
{
    int n;
    char command;
    string generated = "", pass = "ll";
    cout<<"Enter the length of password: ";
    cin>>n;
    srand((unsigned int)(time(NULL)));

    int index = 0;
    string temp = "";
    while (true){
        for(index = 0; index < n; index++)
        {
        temp += alphanum[rand() % (sizeof alphanum - 1)];
        }
        cout << temp << endl;
        
        if (temp == pass)
            break;
        temp = "";
    }


	// string temp = ""; 
    // char pass[4] = "abc";
    // int c1,c2,c3 = 32;

    // cout << pass[2]++ << endl;
    // for (c1 = 32; c1 < 127; c1++){
     
    //     for (c2 = 32; c2 < 127; c2++){

    //         for (c3 = 32; c3 < 127; c3++){
                
    //             if(check(pass, (char)c1, (char)c2, (char)c3)){ 
    //                 cout << "found!" << endl;
    //                 break;
    //             }
          

                
    //         }
    //     }
    // }
    
    
    
	return 0;

}